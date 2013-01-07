-- Author      : Sneg
-- Create Date : 1/7/2013 12:42:40 AM

function btnStart_OnClick()
	if frameMain:IsShown() then
		frameMain:Hide();
	else
		frameMain:Show();
	end
end


function btnDump_OnClick()
	DEFAULT_CHAT_FRAME:AddMessage("Start dump");
	private:CreateCharDump();
	private:SaveCharData(private.Encode(private.GetCharDump()))
end
