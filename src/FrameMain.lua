-- Author: for.sneg@gmail.com

--
-- Components initialize and definitions
--
function HighlightTab_Constructor(self)

	function self:isActive()
		return self._isActive
	end
	
	function self:setActive(isActive)
		self._isActive = isActive
		if (isActive) then
			local texture = self:CreateTexture()
			texture:SetWidth(90)
			texture:SetHeight(13)
			texture:SetBlendMode("ADD")
			texture:SetPoint("TOPLEFT", 15, -8)
			texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			self:SetNormalTexture(texture)
			
			_G["frame"..self._tabType]:Show()
			
		else
			self:SetNormalTexture(nil)
			_G["frame"..self._tabType]:Hide()
		end
	end
	
	-- Constructor
	_G[self:GetName().."RightDisabled"]:Hide()
	_G[self:GetName().."LeftDisabled"]:Hide()
	_G[self:GetName().."MiddleDisabled"]:Hide()
	_G[self:GetName().."Right"]:Show()
	_G[self:GetName().."Left"]:Show()
	_G[self:GetName().."Middle"]:Show()
	
	if self == tabDump then
		self._tabType = "Dump"
	elseif self == tabRestore then
		self._tabType = "Restore"
	end
	
end


--
-- Initialize
--
function frameMain_Init()
	frameMain:RegisterForDrag("LeftButton")

	-- Create log scrollframe
	Log:init(frameMain)
	
	-- Create dump and restore frames
	local frame = CreateFrame("Frame", "frameDump", frameMain, "frameDump")
	frame:SetPoint("TOPLEFT",14,-46)
	frame:Hide()
	
	local frame = CreateFrame("Frame", "frameRestore", frameMain, "frameRestore")
	frame:SetPoint("TOPLEFT",14,-46)
	frame:Hide()

	UIDropDownMenu_Initialize(test, testInit)

	headerText:SetText(ADDONNAME)
	
	tabDump:setActive(true)
	tabRestore:setActive(false)
end


--
-- Events on frame
--
function tab_OnClick(self, otherTab)
	self:setActive(true)
	otherTab:setActive(not self:isActive())
end

function btnClose_OnClick()
	frameMain:Hide();
end




function testInit()
	info = {
		text = '12312313123';
		func = nil;
	};
	UIDropDownMenu_AddButton(info);
	UIDropDownMenu_AddButton(info);
	UIDropDownMenu_AddButton(info);
	UIDropDownMenu_AddButton(info);
end


