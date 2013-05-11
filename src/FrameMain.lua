-- Author: for.sneg@gmail.com

function btnStart_OnClick()
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end


function btnDump_OnClick()

	Log:msg("123123123 " .. Log.scrollFrame:GetVerticalScrollRange() .. " - " .. Log.scrollFrame:GetVerticalScroll())
	
	
	-- private:CreateCharDump();
	-- private:SaveCharData(private.Encode(private.GetCharDump()))
end

function btnClose_OnClick()
	frameMain:Hide();
end

function logScroll_OnVerticalScroll()
	
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

function frameMain_OnLoad()
	frameMain:RegisterForDrag("LeftButton")
	Log:init(frameMain)

	UIDropDownMenu_Initialize(test, testInit);
end

function tabDump_OnClick()
	tabDump:setActive(not tabDump:isActive())
end

function frameMain_OnShow()
	tabDump:setActive(false);
end

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

end
