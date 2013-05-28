-- Author: for.sneg@gmail.com

local BaseProfessionSpells = {
	{   -- Alchemy
        skillId = 171,
        spellName = GetSpellInfo(2259)
    },   
	{   -- Blacksmith
        skillId = 164,
        spellName = GetSpellInfo(2018)
    },
	{   -- Mining (Smelting)
        skillId = 186,
        spellName = GetSpellInfo(2656)
    },
	{   -- Engineering
        skillId = 202,
        spellName = GetSpellInfo(4036)
    },
	{   -- Leatherwork
        skillId = 165,
        spellName = GetSpellInfo(2108)
    },
	{   -- Tailor
        skillId = 197,
        spellName = GetSpellInfo(3908)
    },
	{   -- Cooking
        skillId = 185,
        spellName = GetSpellInfo(2550)
    },
	{   -- FirstAid
        skillId = 129,
        spellName = GetSpellInfo(3273)
    },
	{   -- RoguePoison
        skillId = 40,
        spellName = GetSpellInfo(2842)
    },
	{   -- Jewelcrafting
        skillId = 755,
        spellName = GetSpellInfo(25229)
    },
	{   -- Enchanting (IT IS *CRAFT* IN 2.4.3)
        skillId = 333,
        spellName = GetSpellInfo(7411)
    }
	
	--if (addon.wrath) then
	--	professiontable[GetSpellInfo(45357)] = addon.InitInscription
	--	professiontable[GetSpellInfo(7411)] = addon.InitEnchanting
	--end

}

local Specializations = {
    -- All Alchemy Specialities
    [171] = { 
        [28674] = GetSpellInfo(28674),
        [28678] = GetSpellInfo(28678),
        [28676] = GetSpellInfo(28676)
    },
    
    -- All Blacksmithing Specialities
    [164] = {
        [9788] = GetSpellInfo(9788),   -- Armorsmith
	    [17041] = GetSpellInfo(17041), -- Master Axesmith
	    [17040] = GetSpellInfo(17040), -- Master Hammersmith
	    [17039] = GetSpellInfo(17039), -- Master Swordsmith
	    [9787] = GetSpellInfo(9787)    -- Weaponsmith
    },

    -- All Engineering Specialities
    [202] = {
    	[20219] = GetSpellInfo(20219), -- Gnomish
	    [20222] = GetSpellInfo(20222)  -- Goblin
    },

    -- All Leatherworking Specialities
    [165] = {
	    [10657] = GetSpellInfo(10657), -- Dragonscale
	    [10659] = GetSpellInfo(10659), -- Elemental
	    [10661] = GetSpellInfo(10661)  -- Tribal
    },
    
    -- All Tailoring Specialities
    [197] = {
    	[26797] = GetSpellInfo(26797), -- Spellfire
	    [26801] = GetSpellInfo(26801), -- Shadoweave
	    [26798] = GetSpellInfo(26798)  -- Primal Mooncloth
    }
}

Dumper = { 
	_db = nil, -- reference to save table for current char
}

function Dumper:createRecord()
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

-- =================
-- Main info
-- =================

function Dumper:dumpMainInfo()
	if not self:isInited() then
		return false, "Dumper not inited yet!"
	end

	local _, build, _, _ = GetBuildInfo()
	local _, class = UnitClass("player")
	local _,race = UnitRace("player")

	local mainInfo = {
        charDumpVersion = VERSION,
        engineVersion = DUMP_ENGINE_VERSION,
        realmlist = GetCVar("realmList"),
        clientbuild = build,
        -- guid = UnitGUID("player"),
        class = class,
        level=UnitLevel("player"),
        race = race,
        -- gender=UnitSex("player"),
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

-- =================
-- Inventory
-- =================

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

-- =================
-- Reputation
-- =================

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
	for i=GetNumFactions(),1,-1 do 
		local _,_,_,_,_,_,_,_,isHeader,isCollapsed = GetFactionInfo(i) 
		if isHeader and isCollapsed then
			ExpandFactionHeader(i)
		end
	end

	local reputation, count = {}, 0

	for i=1,GetNumFactions() do 
		local name,_,_,_,_,earnedValue,_,_,isHeader,isCollapsed = GetFactionInfo(i) 

		if not isHeader then
			local factionId, error = self:_getFactionId(name)

			if error then
				return false, error
			end

			reputation[factionId] = {
				factionId = factionId,
				earnedValue = earnedValue
			}

			count = count + 1
		end
	end

	self._db.reputation = reputation

	return true, "Saved "..count.." reputations"

end

-- =================
-- Profession skills
-- =================

-- return skillid, errorstring
function Dumper:_getSkillId(name)
	local locale = GetLocale()
	if locale ~= "ruRU" and locale ~= "enUS" then
		return nil, "Can't get skill id! Wrong client locale!"
	end
	for k,v in pairs(DB.Skills) do
		if name == v["name_"..locale] then
			return k, nil
		end
	end
	return nil, "Can't get skill id! Skill not found ("..name..")"
end

function Dumper:dumpSkills()
	if not self:isInited() then
		return false, "Dumper not inited yet!"
	end

--  NEW API FUNCTIONS
--    local prof1, prof2, fishing, cooking, firstAid = GetProfessions()
--    local professions = {prof1, prof2, fishing, cooking, firstAid}

--    for i=1, 5 do
--        local prof = professions[i]
--        if prof then
--            name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof)
--            Addon:Print(name)
--        end
    
--    end


    -- Expand all skilllines first. Otherwise we get wrong GetNumSkillLines()
	for i=GetNumSkillLines(),1,-1 do 
		local _, isHeader, isExpanded = GetSkillLineInfo(i) 
		if isHeader and not isExpanded then
            ExpandSkillHeader(i)
		end
	end

    local skills, count = {}, 0

    for i=1,GetNumSkillLines() do 

		local skillName, isHeader, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(i)
        if not isHeader then
			local skillId, error = self:_getSkillId(skillName)

			if error then
				return false, error
			end

            if DB.Skills[skillId].id == 40              -- Poisons
                or DB.Skills[skillId].id == 762         -- Riding
                or DB.Skills[skillId].categoryId == 6   -- Weapon/Defense skills
                or DB.Skills[skillId].categoryId == 11  -- Professions
            then

			    skills[skillId] = {
				    skillId = skillId,
				    value = skillRank,
                    maxValue = skillMaxRank
			    }

                if skills[skillId].value > 375 then
                    skills[skillId].value = 375
                end

			    count = count + 1
            end
		end
	end


	self._db.skills = skills

	return true, "Saved "..count.." skills"
end

-- =================
-- Specializations
-- =================

function Dumper:_getCharacterSpecialization(professionId)
    local possibleSpecs = Specializations[professionId]

    local index = 1
    while (1) do
        local spellName = GetSpellName(index, BOOKTYPE_SPELL)
        if not spellName then
            break
        end
        
        for k,v in pairs(possibleSpecs) do
            if spellName == v then
                table.insert(self._db.specs, k)
            end
        end
        index = index + 1
    end
end

function Dumper:dumpSpecs()
	if not self:isInited() then
		return false, "Dumper not inited yet!"
	end

    if not self._db.skills then
        return false, "Dump skills first!"
    end

    self._db.specs = {}

    for k,v in pairs(self._db.skills) do    -- go through character skills
        if Specializations[k] then          -- if skill have possible specializations
            Dumper:_getCharacterSpecialization(k)
        end
    end

    return true, "Saved "..#self._db.specs.." specializations"
end

-- =================
-- Recieps
-- =================

function Dumper:_dumpRecipesForTradeSkill(baseSpellInfo)

    local name, rank, maxLevel = GetTradeSkillLine()
    if name == "UNKNOWN" then
        return false, 0, "Can't open profession window: "..baseSpellInfo.spellName
    end
    
    -- Validate
    if rank ~= self._db.skills[baseSpellInfo.skillId].value or maxLevel ~= self._db.skills[baseSpellInfo.skillId].maxValue then
        return false, 0, "Skills dump and profession window info are different: "..baseSpellInfo.spellName
    end
         
    -- Clear the "Have Materials" check box
	if TradeSkillFrameAvailableFilterCheckButton:GetChecked() then
		TradeSkillFrameAvailableFilterCheckButton:SetChecked(false)
		TradeSkillOnlyShowMakeable(false)
	end

	-- Clear the sub-classes filters
	SetTradeSkillSubClassFilter(0, 1, 1)
	UIDropDownMenu_SetSelectedID(TradeSkillSubClassDropDown, 1)

	-- Clear the inventory slot filter
	SetTradeSkillInvSlotFilter(0, 1, 1);
	UIDropDownMenu_SetSelectedID(TradeSkillInvSlotDropDown, 1)

	-- Expand all headers
	for i = GetNumTradeSkills(), 1, -1 do
		local _, tradeType = GetTradeSkillInfo(i)
		if tradeType == "header" then
			ExpandTradeSkillSubClass(i)
		end
	end

	-- Scan through all recipes
    local count = 0
    for i = 1, GetNumTradeSkills() do
		local skillName, tradeType = GetTradeSkillInfo(i)
		-- Ignore all trade skill headers
		if (tradeType ~= "header") then
            count = count + 1
            local spellId = string.match(GetTradeSkillRecipeLink(i), ".*Henchant:(%d+).*")
            table.insert(self._db.recipes, tonumber(spellId))
		end
    end

    return true, count
end


function Dumper:_dumpRecipesForCraft(baseSpellInfo)

    local name = GetCraftName()
    if name ~= baseSpellInfo.spellName then
        return false, 0, "Can't open profession window: "..baseSpellInfo.spellName
    end

	-- Clear the "Have Materials" check box
	if CraftFrameAvailableFilterCheckButton:GetChecked() then
		CraftFrameAvailableFilterCheckButton:SetChecked(false)
		CraftOnlyShowMakeable(false)
	end

	-- Clear the inventory slots filter
	UIDropDownMenu_SetSelectedID(CraftFrameFilterDropDown, 1)
	SetCraftFilter(1)
	CraftFrame.selected = 1

	-- Scans crafting recipes in opened window, expanding all headers
	for i = GetNumCrafts(), 1, -1 do
		local _, _, craftType = GetCraftInfo(i)
		if craftType == "header" then
			ExpandCraftSkillLine(i)
		end
	end

	-- Scan through all recipes
    local count = 0
	for i = 1, GetNumCrafts() do
		local skillName, _, craftType = GetCraftInfo(i)
		-- Ignore all trade skill headers
		if (craftType ~= "header") then
            count = count + 1
            local spellId = string.match(GetCraftRecipeLink(i), ".*Henchant:(%d+).*")
            table.insert(self._db.recipes, tonumber(spellId))
		end
	end

    return true, count
end


function Dumper:_dumpRecipesForSkill(baseSpellInfo)

    -- Open recipes window
    CastSpellByName(baseSpellInfo.spellName, "player")
    
    local isCraft = baseSpellInfo.skillId == 333 -- Enchanting

    local ok, count, info = false, 0, ""
    if isCraft then
        ok, count, info = self:_dumpRecipesForCraft(baseSpellInfo)
    else
        ok, count, info = self:_dumpRecipesForTradeSkill(baseSpellInfo)
    end
        
    -- Close recipes window
    CastSpellByName(baseSpellInfo.spellName, "player")
    
    return ok, count, info
end    


function Dumper:dumpRecipes()
	if not self:isInited() then
		return false, "Dumper not inited yet!"
	end

    if not self._db.skills then
        return false, "Dump skills first!"
    end

    self._db.recipes = {}

    local profCount, recCount = 0, 0
    for charSkillId, charSkillInfo in pairs(self._db.skills) do    -- go through character skills
        for i, baseSpellInfo in pairs(BaseProfessionSpells) do     -- go through all ingame professions for found name
            if charSkillId == baseSpellInfo.skillId then
                local ok, count, info = self:_dumpRecipesForSkill(baseSpellInfo)
                if not ok then 
                    return ok, info
                end
                recCount = recCount + count
                profCount = profCount + 1
            end
        end
    end

    return true, "Saved "..recCount.." recipes for "..profCount.." professions"
end
