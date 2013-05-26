-- Author: for.sneg@gmail.com

local restorer = Restorer

function frameRestore_Init()

    UIDropDownMenu_Initialize(boxChooseCharacter, boxChooseCharacter_dropDown_init)
    UIDropDownMenu_SetSelectedID(boxChooseCharacter, 1)
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
    else
        local info = {
            text = "EMPTY",
            func = nil
        }
        UIDropDownMenu_AddButton(info);
    end
end

function boxChooseCharacter_OnChoose(arg1, arg2)
    UIDropDownMenu_SetSelectedID(boxChooseCharacter, this:GetID()) 

end