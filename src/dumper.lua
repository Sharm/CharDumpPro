-- Author: for.sneg@gmail.com

Dumper = { 
	_db = nil, -- reference to save table for current char
}

function Dumper:init()
	local realmName = GetRealmName()
	local name = UnitName("player")

	Addon.db.global[realmName.." - "..name] = {}
	Addon.db.global[realmName.." - "..name] = {
		mainInfo = {
			realmName = realmName,
			name = name
		}
	}
	
	self._db = Addon.db.global[realmName.." - "..name]
end

function Dumper:isInited()
	return self._db
end

function Dumper:dumpMainInfo()
	if not self:isInited() then
		return false, "Dumper not inited yet!"
	end

	local _, build, _, _ = GetBuildInfo()
	local _, class = UnitClass("player")
	local _,race = UnitRace("player")

	local mainInfo = {
		charDumpVersion = VERSION,
		realmlist = GetCVar("realmList"),
		clientbuild = build,
		guid = UnitGUID("player"),
		class = class,
		level=UnitLevel("player"),
		race = race,
		gender=UnitSex("player"),
		honorableKills = GetPVPLifetimeStats(),
		honor = GetHonorCurrency(),
		arenapoints = GetArenaCurrency(),
		money = GetMoney()
	}


--	retTbl.specs = GetNumTalentGroups();

--	retTbl.titles = {}
--	for i=1,GetNumTitles() do
--		if IsTitleKnown(i) == 1 then
--			retTbl.titles[i] = true;
--		end
--	end

	self._db.mainInfo = table.join(self._db.mainInfo, mainInfo)

	return true, self._db.mainInfo.class.." "..self._db.mainInfo.name .." "..self._db.mainInfo.level.."lvl"
end

function Dumper:dumpInventory(options)
	if not self:isInited() then
		return false, "Dumper not inited yet!"
	end

	local inventorySave = {}
	local itemLink
	local allcount = 0

	for bagNum = 0, 4 do
		local bagString = "Bag"..bagNum
		itemLink = nil

		if bagNum == 0 then
			-- Backpack (bag 0)
			inventorySave[bagString] = {
				link = nil,
				size = GetContainerNumSlots(bagNum)
			}
		elseif not options.isOneBag then
			local bagNum_ID = ContainerIDToInventoryID(bagNum)
			itemLink = GetInventoryItemLink("player", bagNum_ID)
			if itemLink then
				inventorySave[bagString] = {
					link = itemLink,
					size = GetContainerNumSlots(bagNum)
				}
				allcount = allcount + 1
			end
		end

		if bagNum == 0 or itemLink then -- if bag exists
			for bagItem = 1, inventorySave[bagString].size do
				itemLink = GetContainerItemLink(bagNum, bagItem)
				if itemLink then
					local _, count = GetContainerItemInfo(bagNum, bagItem)
					inventorySave[bagString][bagItem] = {
						link = itemLink,
						count = count and count > 1 and count or nil
					}
					allcount = allcount + 1
				end
			end
		end
	end

	-- Save equipped items as bag 100
	inventorySave.Bag100 = {
		link = nil,
		size = 20
	}
	for invNum = 0, 19 do
		itemLink = GetInventoryItemLink("player", invNum)
		if itemLink then
			local count = GetInventoryItemCount("player", invNum)
			inventorySave.Bag100[invNum] = {
				link = itemLink,
				count = count and count > 1 and count or nil
			}
			allcount = allcount + 1
		end
	end

	self._db.inventory = inventorySave

	return true, "Saved "..allcount.." items prototypes"
end

-- return factionid, errorstring
function Dumper:_getFactionId(name)
	local locale = GetLocale()
	if locale ~= "ruRU" and locale ~= "enUS" then
		return nil, "Can't get faction id! Wrong client locale!"
	end
	for k,v in pairs(DB.Factions) do
		if name == v["name_"..locale] then
			return k, nil
		end
	end
	return nil, "Can't get faction id! Faction not found ("..name..")"
end

function Dumper:dumpReputation()
	if not self:isInited() then
		return false, "Dumper not inited yet!"
	end

	-- Expand all faction first. Otherwise we get wrong GetNumFactions()
	local collapsed = {}
	for i=1,GetNumFactions() do 
		local _,_,_,_,_,_,_,_,isHeader,isCollapsed = GetFactionInfo(i) 
		if isHeader and isCollapsed then
			table.insert(collapsed, i)
		end
	end
	for k,v in pairs(collapsed) do
		ExpandFactionHeader(v)
	end

	local reputation, count = {}, 0

	for i=1,GetNumFactions() do 
		local name,_,_,_,_,earnedValue,_,_,isHeader,isCollapsed = GetFactionInfo(i) 

		if not isHeader then
			local factionId, error = self:_getFactionId(name)

			if error then
				Addon:Print(error)
				return false, error
			end

			reputation[factionId] = {
				factionId = factionId,
				earnedValue = earnedValue,
				side = DB.Factions[factionId].side
			}

			count = count + 1
		end
	end

	self._db.reputation = reputation

	return true, "Saved "..count.." reputations"

end