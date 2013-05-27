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
	end

    -- Constructor
    self:Disable()
end

function frameRestore_Init()
    textRestoreStatus:SetText("Proceeding...")

    btnRestoreMainInfo:init()

    UIDropDownMenu_Initialize(boxChooseCharacter, boxChooseCharacter_dropDown_init)
    boxChooseCharacterText:SetText("Choose restore record...")
    UIDropDownMenu_SetWidth(140, boxChooseCharacter)

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
        textRestoreStatus:SetText("Ready. Please choose restore record.")
    else
        local info = {
            text = "EMPTY",
            func = nil
        }
        UIDropDownMenu_AddButton(info);
        -- TODO: Red color
        textRestoreStatus:SetText("There is no valid restore records!")
    end
end

function btnRestore_getInfo(self)
    self.textObj:SetText("Proceeding...")
    local ok, info = restorer[self.infoFunction](restorer)
    if ok then
        self:Enable()
        self.labelObj:SetTextColor(1,1,1,1)
    else
        -- TODO: Add red color to textObj
        self:Disable()
        self.labelObj:SetTextColor(0.753,0.753,0.753,1)
    end
    self.textObj:SetText("Ready for restore! ("..info..")")
    
    -- Save info for future use
    self._info = info
end

function boxChooseCharacter_OnChoose(arg1, arg2)
    UIDropDownMenu_SetSelectedID(boxChooseCharacter, this:GetID()) 
    restorer:openRecord(this:GetText())

    btnRestore_getInfo(btnRestoreMainInfo)

end

function btnRestore_OnClick(self)
    
end

function frameRestore_OnShow()
   
end
