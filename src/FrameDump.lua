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

	-- Create table for store dump otions
	self.dumpOptions = {}
end

function frameDump_Init()
	-- link dump rows
	btnDumpMainInfo:init()
	btnDumpInventory:init()
	btnDumpReputation:init()
    btnDumpSkills:init()
    btnDumpSpecs:init()
    btnDumpRecipes:init()

	dumper:init()

	-- Addon:RegisterEvent("PLAYER_ENTERING_WORLD", function() frameDump_PLAYER_ENTERING_WORLD() end)
	-- frameDump:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function frameDump_PLAYER_ENTERING_WORLD()
	
end

function btnDump_OnClick(self)
	self.checkObj:Disable()
	self.textObj:SetText("Proceeding...")

	local success, info = dumper[self.dumpFunction](dumper, self.dumpOptions)
	if success then
		self.checkObj:Enable()
		self.textObj:SetText("Success! ("..info..")")
	else
		-- TODO: set red color
		self.textObj:SetText("Failed! ("..info..")")
	end
end

function btnDumpInventory_OnClick()
	btnDumpInventory:showOptions()
end

function btnOkayInventory_OnClick(self)
	btnDumpInventory.dumpOptions.isOneBag = optionInventoryOneBag:GetChecked()

	btnDump_OnClick(btnDumpInventory)
	btnCancelDialog_OnClick(self)
end

function btnCancelDialog_OnClick(self)
	self:GetParent():Hide()
end

function frameDump_OnShow()
	btnDumpMainInfo:Click()
	btnDumpReputation:Click()
    btnDumpSkills:Click()
    btnDumpSpecs:Click()
end
