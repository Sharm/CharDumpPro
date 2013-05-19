-- Author: for.sneg@gmail.com

Addon:RegisterChatCommand("cd", function()
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end)

function Addon:OnInitialize()
	
	self.db = LibStub("AceDB-3.0"):New("CharDumpDB")

	frameMain_Init()
	frameDump_Init()
	
	self:Print("Ready");
end

function Addon:OnEnable()
    -- Called when the addon is enabled
end

function Addon:OnDisable()
    -- Called when the addon is disabled
end

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function table.join(t1, t2)
	for k,v in pairs(t2) do t1[k] = v end return t1
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end