
local Addon_PickUp = Addon:NewModule("PickUp", "AceEvent-3.0", "AceHook-3.0")

local sheduler = Sheduler:create(0)

local btnDefaultText = "Chardump: Pickup ALL"
local button
local invFull

function Addon_PickUp:OnEnable()
	if not button then
        -- Create mailbox button
	    button = CreateFrame("Button", "PickUpAllBtn", InboxFrame, "UIPanelButtonTemplate")
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
    sheduler:enable()
    self:RegisterEvent("MAIL_CLOSED", "Reset")
    self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
    self:RegisterEvent("MAIL_CLOSED", function(event) sheduler:disable() end)
    self:RegisterEvent("PLAYER_LEAVING_WORLD", function(event) sheduler:disable() end)
end

function Addon_PickUp:MAIL_INBOX_UPDATE()
    --Addon:Print("MAIL_INBOX_UPDATE")
    sheduler:continue("Delete")
    sheduler:continue("TakeItem")
end

function Addon_PickUp:UI_ERROR_MESSAGE(event, error_message)
    if error_message == ERR_INV_FULL then
        --Addon:Print("ERR_INV_FULL")
        invFull = true
        sheduler:continue("TakeItem")
    elseif error_message == ERR_ITEM_MAX_COUNT then
        --Addon:Print("ERR_ITEM_MAX_COUNT")
        sheduler:continue("TakeItem")
    end
end

function Addon_PickUp:EQUIP_BIND_CONFIRM(event, slot)
    --Addon:Print("EQUIP_BIND_CONFIRM "..slot)
    EquipPendingItem(slot)
end

-- ============
-- Pick up
-- ============

function Addon_PickUp:_pickUpOneItem(mailIndex, attachIndex, isNeedWait)
    sheduler:shedule(function()
    
        if invFull then
            return
        end

        --Addon:Print("Mail: "..mailIndex.." Attach: "..attachIndex)

        sheduler:stop("TakeItem")
        TakeInboxItem(mailIndex, attachIndex)

        if isNeedWait then
            sheduler:stop("WaitForBagUpdate", 0.4)
        end

    end, self, mailIndex, attachIndex)
end

function Addon_PickUp:_equip(itemName)
    sheduler:shedule(function()
        if itemName then
            EquipItemByName(itemName)
            --Addon:Print("Equip "..itemName)
        end
    end, self, itemName)
end

function Addon_PickUp:_pickUpOneMail(mailIndex, withSubject)
	local msgSubject, _, msgCOD, _, itemCount, _, _, _, _, _ = select(4, GetInboxHeaderInfo(mailIndex))
	if (msgCOD and msgCOD > 0) then -- Skip mail if it contains a CoD
		return
	end

    --Addon:Print("_pickUpOneMail "..tostring(withSubject))
    
    if not withSubject or withSubject == msgSubject then
        itemCount = itemCount or 0

        for attachIndex = itemCount, 1, -1 do
            local itemName = GetInboxItem(mailIndex, attachIndex)

            if msgSubject == "Bags" then 
                self:_pickUpOneItem(mailIndex, attachIndex, true)
                self:_equip(itemName)
            elseif msgSubject == "Equipped" then
                self:_pickUpOneItem(mailIndex, attachIndex, true)
                self:_equip(itemName)
            else
                self:_pickUpOneItem(mailIndex, attachIndex)
            end
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
    self:RegisterEvent("EQUIP_BIND_CONFIRM")
    self:RegisterEvent("AUTOEQUIP_BIND_CONFIRM", function(event, slot) self:EQUIP_BIND_CONFIRM(event, slot) end)

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
    --Addon:Print("Reset")
	self:UnregisterEvent("MAIL_INBOX_UPDATE")
	self:UnregisterEvent("UI_ERROR_MESSAGE")
    self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
    self:UnregisterEvent("EQUIP_BIND_CONFIRM")
    self:UnregisterEvent("AUTOEQUIP_BIND_CONFIRM")
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