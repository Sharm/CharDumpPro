-- Author: for.sneg@gmail.com

local dumper = Dumper

function btnDump_Constructor(self)
	function self:init()
		self.type = string.gsub(self:GetName(),"btnDump","",1)
		self.checkObj = _G["checkDump"..self.type]
		self.textObj = _G["textDump"..self.type]
		self.dumpFunction = "dump"..self.type
	end

	function self:showOptions()
		_G["frame"..self.type.."Options"]:ShowOnParent(frameDump)
	end
end

function frameDump_Init()
    ErrorFontString_init(textTools)

	-- link dump rows
	btnDumpMainInfo:init()
	btnDumpInventory:init()
	btnDumpReputation:init()
    btnDumpSkills:init()
    btnDumpSpecs:init()
    btnDumpRecipes:init()
end

function frameDump_PLAYER_ENTERING_WORLD()
	
end

function btnDump_OnClick(self)
	self.checkObj:Disable()
	self.textObj:SetText("Proceeding...")

	local success, info = dumper[self.dumpFunction](dumper)
	if success then
		self.checkObj:Enable()
		self.textObj:SetText("Success! ("..info..")")
	else
		-- TODO: set red color
		self.textObj:SetText("Failed! ("..info..")")
	end
end

function btnDumpAll_OnClick()
    btnDumpMainInfo:Click()
    btnDumpInventory:Click()
    btnDumpReputation:Click()
    btnDumpSkills:Click()
    btnDumpSpecs:Click()
    btnDumpRecipes:Click()
end

function btnToolDeleteInventory_OnClick()
    local delcount = 0
    
    -- Delete items inside bags
    for bagNum = 0, 4 do
        local size = GetContainerNumSlots(bagNum)
        local bagLink = nil
        
        if bagNum ~= 0 then
            local bagNum_ID = ContainerIDToInventoryID(bagNum)
		    bagLink = GetInventoryItemLink("player", bagNum_ID)
        end

		if bagNum == 0 or bagLink then -- if bag exists (0 for backpack)
			for bagItem = 1, size do
				local itemLink = GetContainerItemLink(bagNum, bagItem)
				if itemLink then
					local _, count = GetContainerItemInfo(bagNum, bagItem)
					PickupContainerItem(bagNum, bagItem)
					DeleteCursorItem()
					delcount = delcount + (count or 1)
				end
			end
		end
        
        -- Delete bag
        if bagLink then
            PickupBagFromSlot(ContainerIDToInventoryID(bagNum))
            DeleteCursorItem()
            delcount = delcount + 1
        end
	end

    -- Delete equipped
	for invNum = 0, 19 do
		itemLink = GetInventoryItemLink("player", invNum)
		if itemLink then
			local count = GetInventoryItemCount("player", invNum)
			PickupInventoryItem(invNum)
			DeleteCursorItem()
			delcount = delcount + 1
        end    
	end
    
    textTools:SetNormalText("Deleted "..delcount.." items")
end
