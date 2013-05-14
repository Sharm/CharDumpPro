-- Author: for.sneg@gmail.com

local dumper = Dumper

function frameDump_Init()
	-- link dump rows
	btnDumpMainInfo.checkObj = checkDumpMainInfo
	btnDumpMainInfo.textObj = textDumpMainInfo
	btnDumpMainInfo.dumpFunction = "dumpMainInfo"

	dumper:init()
end

function btnDumpInventory_OnClick()
	
end

function btnDumpMainInfo_OnClick()

		
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
		textObj:SetText("Failed! ("..info..")")
	end
end
