
local Addon_PickUp = Addon:NewModule("PickUp", "AceEvent-3.0", "AceHook-3.0")

local sheduler = Sheduler:create(0)

local btnDefaultText = "Chardump: Pickup ALL"
local button
local invFull

function Addon_PickUp:OnEnable()
	if not button then
        -- Create mailbox button
	    button = CreateFrame("Button", "PostalOpenAllButton", InboxFrame, "UIPanelButtonTemplate")
	    button:SetWidth(150)
	    button:SetHeight(25)
	    button:SetPoint("CENTER", InboxFrame, "TOP", 0, -55)
	    button:SetText(btnDefaultText)
        button:Enable()
        button:SetScript("OnClick", function() Addon_PickUp:PickUpAll() end)
	end

	self:RegisterEvent("MAIL_SHOW")
	-- For enabling after a disable
	button:Show()
end

function Addon_PickUp:OnDisable()
	self:Reset()
	button:Hide()
end

-- ============
-- Events
-- ============

function Addon_PickUp:MAIL_SHOW()
	self:RegisterEvent("MAIL_CLOSED", "Reset")
	self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
end

function Addon_PickUp:MAIL_INBOX_UPDATE()
    sheduler:continue("Delete")
    sheduler:continue("TakeItem")
end

function Addon_PickUp:UI_ERROR_MESSAGE(event, error_message)
    if error_message == ERR_INV_FULL then
        sheduler:continue("TakeItem")
    elseif error_message == ERR_ITEM_MAX_COUNT then
        sheduler:continue("TakeItem")
    end
end

-- ============
-- Pick up
-- ============

function Addon_PickUp:_pickUpOneItem(mailIndex, attachIndex)
    sheduler:shedule(function()
    
        if invFull then
            return
        end

        sheduler:stop("TakeItem")
        TakeInboxItem(mailIndex, attachIndex)

    end, self, mailIndex, attachIndex)
end


function Addon_PickUp:_equipBag(mailIndex, attachIndex)
end

function Addon_PickUp:_pickUpOneMail(mailIndex, withSubject)
	msgSubject, _, msgCOD, _, itemCount, _, _, _, _, _ = select(4, GetInboxHeaderInfo(mailIndex))
	if (msgCOD and msgCOD > 0) then -- Skip mail if it contains a CoD
		return
	end

    if not withSubject or withSubject == msgSubject then
        itemCount = itemCount or 0

        for attachIndex = itemCount, 1, -1 do
            self:_pickUpOneItem(mailIndex, attachIndex)
            
            --if withSubject and msgSubject == "Bags" then
            --    self:_equipBag(mailIndex, attachIndex)
            --end
        
        end
    end
end

 function Addon_PickUp:_deleteOneMail(mailIndex)
    sheduler:shedule(function()
        sheduler:stop("Delete")
        DeleteInboxItem(mailIndex)
    end, self, mailIndex)
 end

function Addon_PickUp:_deleteEmptyMails()
    for mailIndex = GetInboxNumItems(), 1, -1 do
        if not select(8, GetInboxHeaderInfo(mailIndex)) then
            self:_deleteOneMail(mailIndex)
        end
    end
end

function Addon_PickUp:PickUpAll()
	self:DisableInbox(1)
	button:SetText("In Progress")
    button:Disable()

	self:RegisterEvent("UI_ERROR_MESSAGE")
    self:RegisterEvent("MAIL_INBOX_UPDATE")

    for mailIndex = GetInboxNumItems(), 1, -1 do
        self:_pickUpOneMail(mailIndex, "Bags")
    end
    
    sheduler:shedule(function()
        for mailIndex = GetInboxNumItems(), 1, -1 do
            self:_pickUpOneMail(mailIndex)
        end

        sheduler:shedule(function()
            self:_deleteEmptyMails()
            sheduler:shedule(self.Reset, self, event)
        end, self)
    end, self)
end

function Addon_PickUp:Reset(event)
	self:UnregisterEvent("MAIL_INBOX_UPDATE")
	self:UnregisterEvent("UI_ERROR_MESSAGE")
	button:SetText(btnDefaultText)
    button:Enable()
	self:DisableInbox()
	InboxFrame_Update()
	if event == "MAIL_CLOSED" or event == "PLAYER_LEAVING_WORLD" then
		self:UnregisterEvent("MAIL_CLOSED")
		self:UnregisterEvent("PLAYER_LEAVING_WORLD")
	end
    invFull = false
end

function Addon_PickUp:DisableInbox(disable)
	if disable then
		if not self:IsHooked("InboxFrame_OnClick") then
			self:RawHook("InboxFrame_OnClick", function() end, true)
			for i = 1, 7 do
				_G["MailItem" .. i .. "ButtonIcon"]:SetDesaturated(1)
			end
		end
	else
		if self:IsHooked("InboxFrame_OnClick") then
			self:Unhook("InboxFrame_OnClick")
			for i = 1, 7 do
				_G["MailItem" .. i .. "ButtonIcon"]:SetDesaturated(nil)
			end
		end
	end
end