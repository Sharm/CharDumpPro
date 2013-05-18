-- Author: for.sneg@gmail.com

-- MUST BE INCLUDED AFTER ALL DATASTORE FILES


--factions ={
--	[123] = {
--		id = 123
--		side = 1
--		name = "sdf"
--	}
--}

-- Initialize all datastore tables
local inited = {}
for k,v in pairs(DB) do
	
	local datatable = v
	local result = {}

	for rowString in string.gmatch(datatable.Data, "[^\r\n]+") do
		local row = {}
		local index = 0
		for field in string.gmatch(rowString, "[^\t]+") do
			index = index + 1
			local fieldName = datatable.Fields[index].name
			if datatable.Fields[index].type == "number" then
				field = tonumber(field)
			end
			row[fieldName] = field
		end
		if datatable.KeyField then
			result[row[datatable.KeyField]] = row
		else
			table.insert(result, row)
		end
	end

	DB[k] = result
end
