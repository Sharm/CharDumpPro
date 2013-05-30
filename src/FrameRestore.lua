-- Author: for.sneg@gmail.com

local restorer = Restorer

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
end

function frameRestore_Init()
    ErrorFontString_init(textRestoreStatus)

    textRestoreStatus:proceeding()

    btnRestoreMainInfo:init()
end

local firstShow = true
function frameRestore_OnShow()
    if firstShow then
        firstShow = false
        UIDropDownMenu_Initialize(boxChooseCharacter, boxChooseCharacter_dropDown_init)
        _G["DropDownList1Button1"]:Click()
        UIDropDownMenu_SetWidth(140, boxChooseCharacter)
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
    btnRestore_getInfo(btnRestoreMainInfo)

end

function btnRestore_OnClick(self)
    -- Handle warnings
    if self._warnings then
        -- Warning in some class
        if self._warnings.isClassMismatch then
            ModalDialogText:SetOptions({
                OnOkay = function() 
                    ModalDialogText:Hide()
                    self._warnings.isClassMismatch = nil
                    btnRestoreMainInfo:Click()                  
                end,
                Text = "WARNING! Your current character class mismatch dump character class!\n\nAre you want to continue?"
            })
            ModalDialogText:ShowOnParent(frameRestore)
            return
        end
        -- Warning in some race
        if self._warnings.isRaceMismatch then
            ModalDialogText:SetOptions({
                OnOkay = function() 
                    ModalDialogText:Hide()
                    self._warnings.isRaceMismatch = nil
                    btnRestoreMainInfo:Click()                  
                end,
                Text = "WARNING! Your current character race mismatch dump character race!\n\nAre you want to continue?"
            })
            ModalDialogText:ShowOnParent(frameRestore)
            return
        end
    end

    self.textObj:proceeding()

    -- Asynchronus call, wait for callback
    restorer[self.restoreFunction](restorer, self, btnRestore_OnSuccess, btnRestore_OnError)
end

function btnRestore_OnSuccess(self, info)
    local inf = info or self._info
    self.textObj:SetNormalText("Success! ("..inf..")")
end

function btnRestore_OnError(self, info)
    local inf = info or self._info
    self.textObj:SetErrorText("Error occures while execute! ("..inf..")")
end

function btnRestore_OnRestoreComplete(self)
end
