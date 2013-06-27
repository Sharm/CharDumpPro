
local Addon_TrainerLearn = Addon:NewModule("TrainerLearn", "AceEvent-3.0")

local sheduler = Sheduler:create(0)

local btnDefaultText = "Chardump: Learn ALL"
local button
local isError = false
local cmdProcessor = nil

function Addon_TrainerLearn:OnEnable()
    cmdProcessor = CommProc:create(Addon_TrainerLearn, Addon_TrainerLearn.CMD_ERROR, Addon_TrainerLearn.CMD_EXECUTED)
    self:RegisterEvent("TRAINER_SHOW")
    self:RegisterEvent("TRAINER_CLOSED")
	
end

function Addon_TrainerLearn:OnDisable()
    cmdProcessor = nil
    self:UnregisterEvent("TRAINER_SHOW")
    self:UnregisterEvent("TRAINER_CLOSED")
end

-- ============
-- Events
-- ============

function Addon_TrainerLearn:TRAINER_SHOW()
    if not button then
	    button = CreateFrame("Button", "LearnAllBtn", ClassTrainerFrame, "UIPanelButtonTemplate")
	    button:SetWidth(150)
	    button:SetHeight(25)
	    button:SetPoint("CENTER", ClassTrainerFrame, "TOP", 0, -50)
	    button:SetText(btnDefaultText)
        button:Enable()
        button:SetScript("OnClick", function() Addon_TrainerLearn:LearnAll() end)
	end

    button:Show()
    sheduler:enable()
end

function Addon_TrainerLearn:TRAINER_CLOSED()
    button:Hide()
    sheduler:disable()
end

function Addon_TrainerLearn:CMD_ERROR(text)
    Addon:Print("ERROR: "..text)
    isError = true
end

function Addon_TrainerLearn:CMD_EXECUTED(text)
    Addon:Print("Execute command: "..text)
end


function Addon_TrainerLearn:LearnAll()

    SetTrainerServiceTypeFilter("available", 1) 
    SetTrainerServiceTypeFilter("unavailable", 1)

    isError = false
    
    -- Expand all first. Otherwise we get wrong GetNumTrainerServices()()
	for i=GetNumTrainerServices(),1,-1 do 
		local _, isHeader, isExpanded = GetSkillLineInfo(i) 
        local _, _, serviceType, _, _, isExpanded = GetTrainerServiceInfo(i)
		if serviceType == "header" and not isExpanded then
            ExpandTrainerSkillLine(i)
		end
	end

    for i=GetNumTrainerServices(),1,-1 do 
        serviceName, _, serviceType, _, _, _ = GetTrainerServiceInfo(i)
        if serviceType ~= "header" and not isError then
            cmdProcessor:SendChatMessage(".learn 123")
            self._sheduler:stop("Wait", 0.1)
        end
           
    end


end