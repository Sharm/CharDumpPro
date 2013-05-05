-- Author: for.sneg@gmail.com

function btnStart_OnClick()
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end


function btnDump_OnClick()

	Log:msg("123123123 " .. Log.scrollFrame:GetVerticalScrollRange() .. " - " .. Log.scrollFrame:GetVerticalScroll())
	
	
	-- private:CreateCharDump();
	-- private:SaveCharData(private.Encode(private.GetCharDump()))
end

function btnClose_OnClick()
	frameMain:Hide();
end

function logScroll_OnVerticalScroll()
	
end

function frameMain_OnLoad()
	frameMain:RegisterForDrag("LeftButton");
	Log:init(frameMain)
	
	-- CreateFrame("LogArea", nil, FrameTest);
	

	-- DEFAULT_CHAT_FRAME:AddMessage(logText:GetHeight());
end
