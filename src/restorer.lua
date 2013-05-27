-- Author: for.sneg@gmail.com

Restorer = { 
	_db = nil, -- reference to save table for current char
}

function Restorer:openRecord(name)
	self._db = Addon.db.global[name]
end

-- Return nil if db empty
function Restorer:getRestoreRecordsNames()
    local records = nil

	for k,v in pairs(Addon.db.global) do
        local _, build, _, _ = GetBuildInfo()
        if v.mainInfo.charDumpVersion == VERSION and v.mainInfo.clientbuild == build then
            records = records or {}
            table.insert(records, k)
        end
    end

    if records then
        table.sort(records)
    end

    return records
end

-- =================
-- Main info
-- =================

function Restorer:getMainInfoInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    if not self._db.mainInfo then
        return false, "Empty!"
    end
    return true, tostring(self._db.mainInfo.class).." "..tostring(self._db.mainInfo.name).." "..tostring(self._db.mainInfo.level).."lvl"
end