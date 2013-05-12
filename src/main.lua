
VERSION = "v1.1"
ADDONNAME = "CharDump-PRO "..VERSION

Addon = LibStub("AceAddon-3.0"):NewAddon(ADDONNAME, "AceConsole-3.0")

Addon:RegisterChatCommand("cd", "slash")

function Addon:slash(input)
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end

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

function table.join(t1, t2)
	for k,v in ipairs(t2) do table.insert(t1, v) end return t1
end