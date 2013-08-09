﻿-- Author: for.sharm@gmail.com

local restorer = Restorer
local cmdProc = CommProc:create(0.05)

local restoreBtns = {}

function btnRestore_Constructor(self)
	function self:init()
        self.type = string.gsub(self:GetName(),"btnRestore","",1)
        self.checkObj = _G["checkRestore"..self.type]
        self.textObj = _G["textRestore"..self.type]
        self.labelObj = _G["labelRestore"..self.type]
        self.restoreFunction = "restore"..self.type
        self.infoFunction = "get"..self.type.."Info"
        ErrorFontString_init(self.textObj)
	end

    -- Constructor
    self:Disable()
    self.restored = false
    table.insert(restoreBtns, self)
end

function frameRestore_Init()
    ErrorFontString_init(textRestoreStatus)
    ErrorFontString_init(textRestoreTools)

    textRestoreStatus:proceeding()

    checkPickUpMail:SetChecked(Addon.db.global.options.checkPickUpMail or false)
    checkPickUpMail_OnClick()

    btnRestoreMainInfo:init()
    btnRestoreInventory:init()
    btnRestoreReputations:init()
    btnRestoreSkills:init()
    btnRestoreRecipes:init()
    btnRestoreSpells:init()
    btnRestoreSpecs:init()
end

local firstShow = true
function frameRestore_OnShow()
    UIDropDownMenu_Initialize(boxChooseCharacter, boxChooseCharacter_dropDown_init)
    UIDropDownMenu_SetWidth(140, boxChooseCharacter)
    if firstShow or not UIDropDownMenu_GetSelectedID(boxChooseCharacter) then
        firstShow = false
        boxChooseCharacter.notResetRestoredBtns = true
        _G["DropDownList1Button1"]:Click()
    else
        boxChooseCharacter.notResetRestoredBtns = true
        _G["DropDownList1Button"..UIDropDownMenu_GetSelectedID(boxChooseCharacter)]:Click()
    end
end

function boxChooseCharacter_dropDown_init()
    local records = Restorer:getRestoreRecordsNames()

    if records then
        for k,v in ipairs(records) do 
            local info = {
                text = v,
                func = boxChooseCharacter_OnChoose
            }
            UIDropDownMenu_AddButton(info);
        end
        textRestoreStatus:SetNormalText("Ready. Please choose restore record.")
    else
        local info = {
            text = "EMPTY",
            func = nil
        }
        UIDropDownMenu_AddButton(info);
        textRestoreStatus:SetErrorText("There is no valid restore records!")
    end
end

function btnRestore_getInfo(self)
    self:Disable()
    self.checkObj:Disable()
    self.textObj:proceeding()

    local ok, info, warnings = restorer[self.infoFunction](restorer)
    if ok then
        self:Enable()
        self.labelObj:SetTextColor(1,1,1,1)
        self.textObj:SetNormalText("Ready for restore! ("..info..")")
    else
        self:Disable()
        self.labelObj:SetTextColor(0.753,0.753,0.753,1)
        self.textObj:SetErrorText("Error occures while validate dump record! ("..info..")")
    end
    
    -- Save for future use
    self._info = info
    self._warnings = warnings
    self._warnings_bak = table.copy(warnings)

end

function boxChooseCharacter_OnChoose(arg1, arg2)
    if not boxChooseCharacter.notResetRestoredBtns then
        for k,v in ipairs(restoreBtns) do
            v.restored = false
        end
    else
        boxChooseCharacter.notResetRestoredBtns = false
    end

    UIDropDownMenu_SetSelectedID(boxChooseCharacter, this:GetID()) 
    restorer:openRecord(this:GetText())

    -- Get info from restorer and validate
    for k,v in ipairs(restoreBtns) do
        if not v.restored then
            btnRestore_getInfo(v)
        end
    end
end

function btnRestore_OnClick(self)
    -- Handle warnings
    if _G[self:GetName().."_handleWarnings"] and not _G[self:GetName().."_handleWarnings"](self) then
        return
    end

    self.textObj:proceeding()
    self:Disable()

    -- Asynchronus call, wait for callback
    restorer[self.restoreFunction](restorer, self._warnings, self, btnRestore_OnSuccess, btnRestore_OnError)
end

function btnRestore_OnSuccess(self, info)
    local inf = info or self._info
    self.textObj:SetNormalText("Success! ("..inf..")")
    self.checkObj:Enable()
    self.restored = true
end

function btnRestore_OnError(self, info)
    local inf = info or self._info
    self.textObj:SetErrorText("Error occures while execute! ("..inf..")")
    self:Enable()

    -- Reset all warnings/options to defaults
    self._warnings = table.copy(self._warnings_bak)
end

function checkPickUpMail_OnClick()
    if checkPickUpMail:GetChecked() then
        Addon:EnableModule("PickUp")
    else
        Addon:DisableModule("PickUp")
    end
    Addon.db.global.options.checkPickUpMail = checkPickUpMail:GetChecked()
end

function btnToolLearnClassSpells_OnClick()
    textRestoreTools:SetNormalText("Proceeding...")

    local toLearn = {}
    local _, class = UnitClass("player")
    local faction, _ = UnitFactionGroup("player")

    for _,v in pairs(DB.ClassSpells) do
        if Classes[v.class] == class and v.is_trainer == 1 and ((faction == "Alliance" and v.faction_A == 1) or (faction == "Horde" and v.faction_H == 1)) then
            table.insert(toLearn, v.spellId)
        end
    end

    cmdProc:registerOutput(_G, function(_G, text) 
        textRestoreTools:SetErrorText(text)
    end)

    for _,v in pairs(toLearn) do 
        cmdProc:SendChatMessage(".learn "..v)
    end

    cmdProc:sheduleSuccessFunction(_G, function()
        textRestoreTools:SetNormalText("Trained "..#toLearn.." class spells")
    end)

end

-- =============
-- Handle WARNINGS
-- =============

function btnRestoreMainInfo_handleWarnings(self)
    -- Warning in some class/race
    if not self._warnings.class.accepted then
        ModalDialogText:SetOptions({
            OnOkay = function() 
                self._warnings.class.accepted = true
                self:Click()                  
            end,
            Text = "WARNING\n\nYour current character class/race mismatch dump character class/race!\n\nDo you want to continue?"
        })
        ModalDialogText:ShowOnParent(frameRestore)
        return false
    end

    -- Option to restore kills
    if not self._warnings.kills.accepted then
        ModalDialogText:SetOptions({
            OnOkay = function() 
                self._warnings.kills.accepted = true
                self._warnings.kills.isRestoreKills = true
                self:Click()                  
            end,
            OnCancel = function()
                self._warnings.kills.accepted = true
                self:Click()  
            end,
            Text = "OPTION\n\nDo you want to restore honorable kills?"
        })
        ModalDialogText:ShowOnParent(frameRestore)
        return false
    end

    return true
end

function btnRestoreInventory_handleWarnings(self)
	local msg = ""
	if not BankFrame:IsShown() then
		msg = "Open bank window.\n"
	end
	local NumFreeSlots = GetContainerNumFreeSlots(0)
	if NumFreeSlots < 8 then
		msg = msg.."Leave at least 8 empty slots in your backpack.\n"
	end
	if GetInventoryItemLink("player", 20) then
		msg = msg.."Remove first bag (the rightmost one) from its slot.\n"
	end
	if msg ~= "" then
		message(msg)
		return false
	end
    -- Option for restore just one main bag
    --[[if not self._warnings.onebag.accepted then
        ModalDialogRestoreInventory:SetOptions({
            OnOkay = function() 
                self._warnings.onebag.accepted = true
                self._warnings.onebag.isRestoreOneBagOnly = optionRestoreInventoryOneBag:GetChecked()
                self:Click()                  
            end
        })
        ModalDialogRestoreInventory:ShowOnParent(frameRestore)
        return false
    end]]

    return true
end
