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
		realmName = self._db.mainInfo.realmName,
		name = self._db.mainInfo.name,
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

	self._db.mainInfo = mainInfo

	return true, self._db.mainInfo.class.." "..self._db.mainInfo.name .." "..self._db.mainInfo.level.."lvl"
end

function Dumper:dumpInventory()
	
end