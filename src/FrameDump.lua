-- Author: for.sneg@gmail.com

local dumper = Dumper

function frameDump_Init()
	dumper:init()
	checkDumpMainInfo:Disable()
end

function btnDumpInventory_OnClick()
	
end

function btnDumpMainInfo_OnClick()
	dumper:dumpMainInfo()
	checkDumpMainInfo:Enable()
end
