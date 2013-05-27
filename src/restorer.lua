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