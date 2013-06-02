
local Addon_PickUp = Addon:NewModule("PickUp", "AceEvent-3.0", "AceHook-3.0")

local btnDefaultText = "Chardump: Pickup ALL"
local mailIndex, attachIndex
local lastmailIndex, lastattachIndex, lastmailmoneyIndex
local lastItem
local button
local skipFlag = false
local invFull

local updateFrame = CreateFrame("Frame")
updateFrame:Hide()
updateFrame:SetScript("OnShow", function(self)
	self.time = 0
end)
updateFrame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time - elapsed
	if self.time <= 0 then
		self:Hide()
		Addon_PickUp:ProcessNext()
	end
end)

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

function Addon_PickUp:MAIL_SHOW()
	self:RegisterEvent("MAIL_CLOSED", "Reset")
	self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
end

function Addon_PickUp:PickUpAll()
	mailIndex = GetInboxNumItems() or 0
	attachIndex = ATTACHMENTS_MAX_RECEIVE
	invFull = nil
	skipFlag = false
	lastmailIndex = nil
	lastattachIndex = nil
	lastmailmoneyIndex = nil
	lastItem = nil
	if mailIndex == 0 then
		return
	end

	self:DisableInbox(1)
	button:SetText("In Progress")
    button:Disable()

	self:RegisterEvent("UI_ERROR_MESSAGE")
	self:ProcessNext()
end

function Addon_PickUp:ProcessNext()
	local _, msgSubject, msgMoney, msgCOD, msgItem, msgText, isGM
	if mailIndex > 0 then
		msgSubject, msgMoney, msgCOD, _, msgItem, _, _, msgText, _, isGM = select(4, GetInboxHeaderInfo(mailIndex))
		if (msgCOD and msgCOD > 0) then
			-- Skip mail if it contains a CoD or if its from a GM
			skipFlag = true
			mailIndex = mailIndex - 1
			attachIndex = ATTACHMENTS_MAX_RECEIVE
			lastItem = nil
			return self:ProcessNext() -- tail call
		end

		while not GetInboxItemLink(mailIndex, attachIndex) and attachIndex > 0 do
			-- Find first attachment index backwards
			attachIndex = attachIndex - 1
		end
		if attachIndex > 0 and not invFull then
			-- If there's attachments, take the item
			--Addon:Print("Getting Item from Message "..mailIndex..", "..attachIndex)
			if lastmailIndex ~= mailIndex or lastattachIndex ~= attachIndex then -- don't attempt to take more than once or it generates the "database error"
				--Addon:Print("Actually getting it")
				lastItem = GetInboxNumItems()
				TakeInboxItem(mailIndex, attachIndex)
				lastmailIndex = mailIndex
				lastattachIndex = attachIndex
			else
				if lastItem ~= GetInboxNumItems() then
					mailIndex = mailIndex - 1
					attachIndex = ATTACHMENTS_MAX_RECEIVE
					lastItem = nil
					return self:ProcessNext() -- tail call
				end
			end
			--attachIndex = attachIndex - 1
			updateFrame:Show()
		else
			if lastItem and lastItem ~= GetInboxNumItems() then
				-- the last attachment or gold taken auto deleted the mail so move on to the next mail
				mailIndex = mailIndex - 1
				attachIndex = ATTACHMENTS_MAX_RECEIVE
				lastItem = nil
				return self:ProcessNext() -- tail call
			end
			mailIndex = mailIndex - 1
			attachIndex = ATTACHMENTS_MAX_RECEIVE
			lastItem = nil
			return self:ProcessNext() -- tail call
		end
	else
		if skipFlag then Addon:Print("Some Messages May Have Been Skipped.") end
		self:Reset()
	end
end

function Addon_PickUp:Reset(event)
	updateFrame:Hide()
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
end

function Addon_PickUp:MAIL_INBOX_UPDATE()
	--Addon:Print("update")
	self:UnregisterEvent("MAIL_INBOX_UPDATE")
	updateFrame:Show()
end

function Addon_PickUp:UI_ERROR_MESSAGE(event, error_message)
	if error_message == ERR_INV_FULL then
		invFull = true
	elseif error_message == ERR_ITEM_MAX_COUNT then
		attachIndex = attachIndex - 1
	end
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