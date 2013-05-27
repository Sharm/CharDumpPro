-- Author: for.sneg@gmail.com

local restorer = Restorer

function frameRestore_Init()
    textRestoreStatus:SetText("Proceeding...")


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

function boxChooseCharacter_OnChoose(arg1, arg2)
    UIDropDownMenu_SetSelectedID(boxChooseCharacter, this:GetID()) 
    restorer:openRecord(this:GetText())

end
function btnRestore_OnClick(self)
    
end

function frameRestore_OnShow()
   
end
