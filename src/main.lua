

CharDump = LibStub("AceAddon-3.0"):NewAddon("CharDump", "AceConsole-3.0")

CharDump:RegisterChatCommand("cd", "slash")

function CharDump:slash(input)
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end

function CharDump:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
	self:Print("OnInitialize");
	self.db = LibStub("AceDB-3.0"):New("CharDumpDB")
end

function CharDump:OnEnable()
    -- Called when the addon is enabled
end

function CharDump:OnDisable()
    -- Called when the addon is disabled
end