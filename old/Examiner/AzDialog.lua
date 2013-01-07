-- Set AzDialog Revision. Don't load again if newer or same revision is already loaded
if (AZDIALOG_REV and AZDIALOG_REV >= 1) then
	return;
end
AZDIALOG_REV = 1;

--------------------------------------------------------------------------------------------------------
--                                         Create the Dialog                                          --
--------------------------------------------------------------------------------------------------------

-- AzDialog
CreateFrame("Frame","AzDialog",UIParent);
AzDialog:SetWidth(310);
AzDialog:SetHeight(88);
AzDialog:SetBackdrop({ bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8,edgeSize = 12, insets = { left = 2, right = 2, top = 2, bottom = 2 } });
AzDialog:SetBackdropColor(0.1,0.22,0.35,1.0);
AzDialog:SetBackdropBorderColor(0.1,0.1,0.1,1.0);
AzDialog:SetMovable(1);
AzDialog:EnableMouse(1);
AzDialog:SetToplevel(1);
AzDialog:SetScript("OnMouseDown",function() this:StartMoving(); end);
AzDialog:SetScript("OnMouseUp",function() this:StopMovingOrSizing(); end);

-- Header
AzDialog:CreateFontString("AzDialogHeader","ARTWORK","GameFontHighlight");

-- Edit
CreateFrame("EditBox","AzDialogEdit",AzDialog,"InputBoxTemplate");
AzDialogEdit:SetHeight(21);
AzDialogEdit:SetPoint("TOPLEFT",16,-30);
AzDialogEdit:SetPoint("TOPRIGHT",-12,-30);
AzDialogEdit:SetScript("OnEnterPressed",function() this:GetParent():OK(); end);
AzDialogEdit:SetScript("OnEscapePressed",function() this:GetParent():Cancel(); end);

-- Cancel
CreateFrame("Button","AzDialogCancel",AzDialog,"UIPanelButtonTemplate");
AzDialogCancel:SetWidth(75);
AzDialogCancel:SetHeight(21);
AzDialogCancel:SetScript("OnClick",function() this:GetParent():Cancel(); end);
AzDialogCancel:SetText("Cancel");

-- OK
CreateFrame("Button","AzDialogOK",AzDialog,"UIPanelButtonTemplate");
AzDialogOK:SetWidth(75);
AzDialogOK:SetHeight(21);
AzDialogOK:SetPoint("RIGHT",AzDialogCancel,"LEFT",-8,0);
AzDialogOK:SetScript("OnClick",function() this:GetParent():OK(); end);
AzDialogOK:SetText("OK");

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- Close this frame with escape
tinsert(UISpecialFrames,"AzDialog");

-- local callback variables
local callBackText, callBackOK, callBackCancel;

-- Show Dialog
function AzDialog:New(header,text,funcOK,funcCancel)
	-- Store call back values
	callBackText = text;
	callBackOK = funcOK;
	callBackCancel = funcCancel;
	-- Set Type
	AzDialogHeader:SetText(header or "Enter text here...");
	if (text) then
		AzDialog:SetHeight(88);
		AzDialogHeader:ClearAllPoints();
		AzDialogHeader:SetPoint("TOPLEFT",10,-10);
		AzDialogEdit:SetText(callBackText);
		AzDialogEdit:Show();
		AzDialogCancel:ClearAllPoints();
		AzDialogCancel:SetPoint("BOTTOMRIGHT",-10,10);
	else
		AzDialog:SetHeight(66);
		AzDialogHeader:ClearAllPoints();
		AzDialogHeader:SetPoint("TOP",0,-10);
		AzDialogEdit:Hide();
		AzDialogCancel:ClearAllPoints();
		AzDialogCancel:SetPoint("BOTTOM",42,10);
	end
	-- Center Dialog & Show
	AzDialog:ClearAllPoints();
	AzDialog:SetPoint("CENTER",0,110);
	AzDialog:Show();
end

-- Dialog Closed Using "OK"
function AzDialog:OK()
	if (callBackOK) then
		callBackOK(callBackText and AzDialogEdit:GetText());
	end
	self:Hide();
end

-- Dialog Closed Using "Cancel"
function AzDialog:Cancel()
	if (callBackCancel) then
		callBackCancel(callBackText);
	end
	self:Hide();
end