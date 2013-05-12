-- Author: for.sneg@gmail.com

Dumper = { 
	_db = nil, -- reference to save table for current char
}

function Dumper:init()
	-- Init save table
	local realmName = GetRealmName()
	local name = UnitName("player")
	Addon.db.global[realmName.." - "..name] = {
		mainInfo = {
			realmName = realmName,
			name = name
		}
	}
	self._db = Addon.db.global[realmName.." - "..name]
	return self;
end

function Dumper:dumpMainInfo()
	local version, build, date, tocversion = GetBuildInfo();

	local mainInfo = {
		charDumpVersion = VERSION,
		realmlist = GetCVar("realmList"),
		clientbuild = build,
		guid = UnitGUID("player"),
		_, class = UnitClass("player"),
		level=UnitLevel("player"),
		_,race = UnitRace("player"),
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
	Log:msg("dumpMainInfo() success! "..self._db.mainInfo.name)
end

function Dumper:dumpInventory()
	
end