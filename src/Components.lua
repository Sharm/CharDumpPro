-- Author: for.sneg@gmail.com

-- =============
-- ModalDialog
-- =============

function ModalDialog_Constructor(self)

	function self:ShowOnParent(parent)
		self:SetParent(parent)
		self:Show()
	end

	-- Create overlay frame
	self.overlay = CreateFrame("Frame")
	
	-- Disable interactive of parent frame
	self.overlay:EnableMouse(true)
	Addon:RawHookScript(self.overlay, "OnMouseDown", function() end)

	-- Create overlay texture
	self.texture = self.overlay:CreateTexture(nil, "Background")
	self.texture:SetBlendMode("Blend")
	self.texture:SetAllPoints(true);
	self.texture:SetTexture(0,0,0,0.6)
end

function ModalDialog_OnShow(self)
	if self:GetParent() == nil then
		Addon:Print("ModalDialog ERROR: Please set parent first!")
		return
	end

	-- Positioning overlay frame on parent
	self.overlay:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT");
	self.overlay:SetPoint("BOTTOMRIGHT", self:GetParent(), "BOTTOMRIGHT");
	self.overlay:SetFrameLevel(self:GetParent():GetFrameLevel() + 3);

	-- Positioning dialog
	self:SetFrameLevel(self.overlay:GetFrameLevel() + 1);
	self:ClearAllPoints();
	self:SetPoint("CENTER", 0, 0)

	-- Show overlay on parent
	self.overlay:Show()
end

function ModalDialog_OnHide(self)
	self.overlay:Hide()
end

-- =============
-- Error FontString
-- =============

function ErrorFontString_init(self)
    function self:SetErrorText(text)
        self:SetTextColor(1,0,0,1)
        self:SetText(text)
    end

    function self:SetNormalText(text)
        self:SetTextColor(1,0.82,0,1)
        self:SetText(text)
    end

    function self:proceeding()
        self:SetNormalText("Proceeding...")
    end
end