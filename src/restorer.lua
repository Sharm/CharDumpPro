-- Author: for.sneg@gmail.com

Restorer = { 
	_db = nil, -- reference to save table for current char
}

function Restorer:init()
end

-- Return nil if db empty
function Restorer:getRestoreRecordsNames()
    local records = nil

	for k,v in pairs(Addon.db.global) do
        records = records or {}
        table.insert(records, k)
    end

    table.sort(records)

    return records
end