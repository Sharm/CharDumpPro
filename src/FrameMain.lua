-- Author: for.sneg@gmail.com

--
-- Components initialize and definitions
--
function HighlightTab_Initialize(self)

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
		else
			self:SetNormalTexture(nil)
		end
	end
	
	-- Constructor
	_G[self:GetName().."RightDisabled"]:Hide()
	_G[self:GetName().."LeftDisabled"]:Hide()
	_G[self:GetName().."MiddleDisabled"]:Hide()
	_G[self:GetName().."Right"]:Show()
	_G[self:GetName().."Left"]:Show()
	_G[self:GetName().."Middle"]:Show()
	
end


--
-- Main frame loaded
--
function frameMain_OnLoad()
	frameMain:RegisterForDrag("LeftButton")

	-- Create log scrollframe
	Log:init(frameMain)

	UIDropDownMenu_Initialize(test, testInit)
end


--
-- Load and prepare components
--
function frameMain_OnShow()
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


function btnDump_OnClick()

	Log:msg("123123123 " .. Log.scrollFrame:GetVerticalScrollRange() .. " - " .. Log.scrollFrame:GetVerticalScroll())
	
	
	-- private:CreateCharDump();
	-- private:SaveCharData(private.Encode(private.GetCharDump()))
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
