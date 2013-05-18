-- Author: for.sneg@gmail.com

local dumper = Dumper

function btnDump_Constructor(self)
	function self:init()
		self.type = string.gsub(self:GetName(),"btnDump","",1)
		Addon:Print("Type: "..self.type)
		self.checkObj = _G["checkDump"..self.type]
		self.textObj = _G["textDump"..self.type]
		self.dumpFunction = "dump"..self.type
	end
end

function frameDump_Init()
	-- link dump rows
	btnDumpMainInfo:init()
	btnDumpInventory:init()

	dumper:init()

	Addon:RegisterEvent("PLAYER_ENTERING_WORLD", function() frameDump_PLAYER_ENTERING_WORLD() end)
end

function frameDump_PLAYER_ENTERING_WORLD()
	btnDumpMainInfo:Click()
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

function frameDump_PLAYER_ENTERING_WORLD()
	btnDumpMainInfo:Click()
end
