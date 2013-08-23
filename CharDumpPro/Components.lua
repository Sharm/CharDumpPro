-- Author: for.sharm@gmail.com

-- =============
-- ModalDialog
-- =============
-- Options:
--   OnOkay   | function
--   OnCancel | function
--   width    | number
--   height   | number
--   isOneBtn | boolean  | Only `Okay` btn will be visible, OnCancel ignored

function ModalDialog_Constructor(self)

	function self:ShowOnParent(parent)
		self:SetParent(parent)
		self:Show()
	end

    function self:SetOptions(options)
        self._options = options

        options.isOneBtn = options.isOneBtn or false
        if not options.isOneBtn then
            _G[self:GetName().."Okay"]:SetPoint("TOPLEFT", 22, -132)
            self.btnCancel = CreateFrame("Button", self:GetName().."Cancel", self, "UIPanelButtonTemplate")
            self.btnCancel:SetWidth(75)
            self.btnCancel:SetHeight(23)
            self.btnCancel:SetPoint("BOTTOMLEFT", 103, 10)
            self.btnCancel:SetText("Cancel")
            self.btnCancel:Enable()
            self.btnCancel:SetScript("OnClick", function() ModalDialogBtn_OnClick(self.btnCancel) end)
        end
        
        _G[self:GetName().."Okay"].callback = options.OnOkay
        if _G[self:GetName().."Cancel"] then
            _G[self:GetName().."Cancel"].callback = options.OnCancel
        end

        self:SetWidth(options.width or self:GetWidth())
        self:SetHeight(options.height or self:GetHeight())

        if self.handleOptions then -- for allow handle custom otions in subclass objects
            self:handleOptions(options)
        end
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

    -- Create buttons
    self.btnOkay = CreateFrame("Button", self:GetName().."Okay", self, "UIPanelButtonTemplate")
    self.btnOkay:SetWidth(75)
    self.btnOkay:SetHeight(23)
    self.btnOkay:SetPoint("BOTTOMLEFT", 60, 10)
    self.btnOkay:SetText("Okay")
    self.btnOkay:Enable()
    self.btnOkay:SetScript("OnClick", function() ModalDialogBtn_OnClick(self.btnOkay) end)
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

function ModalDialogBtn_OnClick(self)
    if self.callback then
        self:GetParent():Hide()
        self:callback()
    else
        self:GetParent():Hide()
    end
end

-- =============
-- ModalDialogText
-- =============

function ModalDialogText_Constructor(self)
    ModalDialog_Constructor(self)
    function self:handleOptions(options)

        _G[self:GetName().."Text"]:SetText(options.Text)
    end
end

-- =============
-- Error FontString
-- =============

function ErrorFontString_init(self)

    function self:_setText(text)
        self:SetText(text)
    end

    function self:SetErrorText(text)
        self:SetTextColor(1,0,0,1)
        self:_setText(text)
        Addon:Print("ERROR: "..text)
    end

    function self:SetNormalText(text)
        self:SetTextColor(1,0.82,0,1)
        self:_setText(text)
    end

    function self:proceeding()
        self:SetNormalText("Proceeding...")
    end
end
