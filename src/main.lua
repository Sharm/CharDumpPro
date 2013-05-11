

Addon = LibStub("AceAddon-3.0"):NewAddon("CharDump", "AceConsole-3.0")

Addon:RegisterChatCommand("cd", "slash")

function Addon:slash(input)
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end

function Addon:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
	self:Print("OnInitialize");
	self.db = LibStub("AceDB-3.0"):New("CharDumpDB")
end

function Addon:OnEnable()
    -- Called when the addon is enabled
end

function Addon:OnDisable()
    -- Called when the addon is disabled
end