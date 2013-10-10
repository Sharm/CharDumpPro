-- Author: for.sharm@gmail.com

Addon:RegisterChatCommand("cd", function()
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end)

function Addon:OnInitialize()
    self.isWotlk = select(4, GetBuildInfo()) > 20400 and select(4, GetBuildInfo()) < 40000

    self.db = LibStub("AceDB-3.0"):New("CharDumpDB")
    self.db.global.options = self.db.global.options or {}

    frameMain_Init()
	
    self:Print("Ready");
end

function Addon:OnEnable()
    -- Called when the addon is enabled
end

function Addon:OnDisable()
    -- Called when the addon is disabled
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

function table.copy(t)
    if t == nil then return nil end
    local t2 = {}
    for k,v in pairs(t) do
        if type(v) == 'table' then
            t2[k] = table.copy(v)
        else
            t2[k] = v
        end
    end
    return t2
end