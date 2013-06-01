-- Author: for.sneg@gmail.com

local restorer = Restorer

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
    table.insert(restoreBtns, self)
end

function frameRestore_Init()
    ErrorFontString_init(textRestoreStatus)

    textRestoreStatus:proceeding()

    btnRestoreMainInfo:init()
    btnRestoreInventory:init()
end

local firstShow = true
function frameRestore_OnShow()
    if firstShow then
        firstShow = false
        UIDropDownMenu_Initialize(boxChooseCharacter, boxChooseCharacter_dropDown_init)
        UIDropDownMenu_SetWidth(140, boxChooseCharacter)
    end
    _G["DropDownList1Button1"]:Click()
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
end

function boxChooseCharacter_OnChoose(arg1, arg2)
    UIDropDownMenu_SetSelectedID(boxChooseCharacter, this:GetID()) 
    restorer:openRecord(this:GetText())

    -- Get info from restorer and validate
    for k,v in ipairs(restoreBtns) do
        btnRestore_getInfo(v)
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
end

function btnRestore_OnError(self, info)
    local inf = info or self._info
    self.textObj:SetErrorText("Error occures while execute! ("..inf..")")
    self:Enable()
end

function btnRestoreMainInfo_handleWarnings(self)
    -- Warning in some class/race
    if not self._warnings.class.accepted then
        ModalDialogText:SetOptions({
            OnOkay = function() 
                ModalDialogText:Hide()
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
                ModalDialogText:Hide()
                self._warnings.kills.accepted = true
                self._warnings.kills.isRestoreKills = true
                self:Click()                  
            end,
            OnCancel = function()
                ModalDialogText:Hide()
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
