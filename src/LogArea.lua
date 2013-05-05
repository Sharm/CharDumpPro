-- Author: for.sneg@gmail.com
-- Bref: Component to use insted of standart DEFAULT_CHAT_FRAME:AddMessage

Log = {
	mainFrame = nil,
	scrollFrame = nil,
	innerFrame = nil,
	lastString = nil
}

local FrameBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

-- parent: Log window will be on bottom of this widget by default
function Log:init(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("BOTTOMLEFT", 15, 15)
	frame:SetPoint("BOTTOMRIGHT", -40, 15)
	frame:SetHeight(150)
	frame:SetBackdrop(FrameBackdrop)
	self.mainFrame = frame

	local frame = CreateFrame("ScrollFrame", "scrollFrame", self.mainFrame, "UIPanelScrollFrameTemplate")
	frame:SetPoint("TOPLEFT", 0, -15)
	frame:SetPoint("BOTTOMRIGHT", 0, 15)
	frame:HookScript("OnScrollRangeChanged", function() self:OnScrollRangeChanged() end )
	self.scrollFrame = frame

	local frame = CreateFrame("Frame", nil, self.scrollFrame)
	frame:SetWidth(self.mainFrame:GetWidth())
	self.innerFrame = frame

	self.scrollFrame:SetScrollChild(self.innerFrame)
end

-- add info text
function Log:msg(text)
	self:_outputString(text, "GameFontNormal")
end

-- add error text
function Log:error(text)
	self:_outputString(text, "GameFontRed")
end

function Log:_outputString(text, type)
	local string = self.innerFrame:CreateFontString(nil, "ARTWORK", type)
	if self.lastString == nil then
		string:SetPoint("TOP", 0, 0)
	else
		string:SetPoint("TOP", self.lastString, "BOTTOM", 0, 0)
	end
	string:SetPoint("LEFT", 13, 0)
	string:SetText(text)
	self.lastString = string

	self.innerFrame:SetHeight(self.innerFrame:GetHeight() + string:GetHeight())

	return string
end

function Log:OnScrollRangeChanged()
	self.scrollFrame:SetVerticalScroll(self.scrollFrame:GetVerticalScrollRange())
end
