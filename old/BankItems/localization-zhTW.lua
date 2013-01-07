if GetLocale() == "zhTW" then
-- localization.tw.lua (Chinese)
-- Date: 2007-10-6
-- Translator: Isler
BINDING_HEADER_BANKITEMS			= "離線銀行"
BINDING_NAME_TOGGLEBANKITEMS		= "打開離線銀行"
BINDING_NAME_TOGGLEBANKITEMSALL		= "打開離線銀行及所有包裹"
BINDING_NAME_TOGGLEBANKITEMSBANK	= "打開離線銀行及銀行包裹"
BINDING_NAME_TOGGLEBANKITEMSGUILDBANK	= "打開離線公會銀行"

BANKITEMS_VERSIONTEXT	= "BankItems v24002"
BANKITEMS_HELPTEXT1 	= "輸入 /bi 或 /bankitems 打開離線銀行"
BANKITEMS_HELPTEXT2 	= "-- /bi all : 打開離線銀行及所有包裹"
BANKITEMS_HELPTEXT3 	= "-- /bi allbank : 打開離線銀行及所有銀行包裹"
BANKITEMS_HELPTEXT4 	= "-- /bi clear : 清除所選擇的人物的資訊"
BANKITEMS_HELPTEXT5 	= "-- /bi clearall : 清除所有人物的資訊"
BANKITEMS_HELPTEXT6 	= "-- /bi showbutton : 顯示小地圖按鈕"
BANKITEMS_HELPTEXT7 	= "-- /bi hidebutton : 隱藏小地圖按鈕"
BANKITEMS_HELPTEXT8 	= "-- /bi search itemname : 搜索物品"
BANKITEMS_HELPTEXT9 	= "-- /bis itemname : 搜索物品"
BANKITEMS_HELPTEXT10 	= "-- /bigb: 打開離線公會銀行"
BANKITEMS_HELPTEXT11 	= "-- /bigb clear : 清除所選擇的公會銀行資訊"

BANKITEMS_MINIMAPBUTTON_TOOLTIP		= "離線銀行"
BANKITEMS_MINIMAPBUTTON_TOOLTIP2	= "左鍵點擊打開離線銀行."
BANKITEMS_MINIMAPBUTTON_TOOLTIP3	= "右鍵點擊並拖動來移動按鈕."

BANKITEMS_OPTION_TEXT			= "設定..."
BANKITEMS_OPTIONS_TEXT			= "離線銀行設定"
BANKITEMS_LOCK_MAIN_WINDOW_TEXT	= "鎖定主窗口以防止拖動"
BANKITEMS_MINIMAP_BUTTON_TEXT	= "顯示小地圖按鈕"
BANKITEMS_WINDOW_STYLE_TEXT		= "以暴雪的視窗方式打開離線銀行"
BANKITEMS_BAGPARENT_TEXT		= "以暴雪的包裹方式打開離線銀行的包裹"
BANKITEMS_TOOLTIP_INFO_TEXT		= "在物品上顯示額外的滑鼠提示資訊"
BANKITEMS_GTOOLTIP_TEXT			= "包含以下公會銀行:"
BANKITEMS_GTOOLTIP2_TEXT		= "已選擇 %d 個公會銀行"
BANKITEMS_IGNORESOULBOUND_TEXT 	= "忽略不可堆疊的靈魂綁定物品"
BANKITEMS_BEHAVIOR_TEXT			= [[在輸入命令 "/bi":]]
BANKITEMS_BEHAVIOR2_TEXT		= "打開離線銀行的同時..."
BANKITEMS_BUTTONRADIUS_TEXT		= "小地圖按鈕半徑"
BANKITEMS_BUTTONPOS_TEXT		= "小地圖按鈕位置"
BANKITEMS_TRANSPARENCY_TEXT		= "透明度"
BANKITEMS_SCALING_TEXT			= "縮放"
BANKITEMS_RESET_TEXT			= "重置"
BANKITEMS_SEARCH_TEXT			= "搜索"
BANKITEMS_SEARCH_FILTER_TEXT	= "搜索這些包裹..."

BANKITEMS_TOTAL_TEXT			= " (總計)"
BANKITEMS_OF_TEXT				= " 在 "
BANKITEMS_CONTENTS_OF_TEXT		= "搜索結果: "
BANKITEMS_CAUTION_TEXT			= "注意: 一些裝備未在報告中解析並發佈因為它們沒有在本地緩存中被發現.最近的一次遊戲更新清空了本地緩存.你可以登陸該角色並流覽銀行物品來解決這個問題或者把滑鼠在每個包裹的每件物品上懸停來向伺服器查詢物品鏈結(這可能導致你掉線).\n"
BANKITEMS_BANK_ITEM_PREFIX_TEXT	= "銀行物品 %d: "
BANKITEMS_BAG_ITEM_PREFIX_TEXT	= "包裹 %d 物品 %d: "
BANKITEMS_MONEY_PREFIX_TEXT		= "金錢: "
BANKITEMS_MONEY_FORMAT_TEXT		= "%d金 %d銀 %d銅"
BANKITEMS_SEARCH_COMPLETE_TEXT	= [[搜索 "%s" 完成.]]

BANKITEMS_SEARCH_RESULLT_BANKITEM_TEXT	= "     銀行物品 "
BANKITEMS_SEARCH_RESULLT_EQUIPPED_TEXT 	= "     裝備的: "
BANKITEMS_SEARCH_RESULLT_MAILBOX_TEXT 	= "     郵件內: "
BANKITEMS_SEARCH_RESULLT_BAG_TEXT 		= "     包裹 "
BANKITEMS_SEARCH_RESULLT_TAB_TEXT		= "     標籤 "
BANKITEMS_SEARCH_RESULLT_ITEM_TEXT 		= " 物品 "

BANKITEMS_USERDROPDOWN_TOOLTIP_TEXT	= "你正在流覽該人物的銀行物品."
BANKITEMS_ALLREALMS_TOOLTIP_TEXT	= "點擊這裏選擇所有保存的人物的銀行資訊（所有伺服器）."
BANKITEMS_ALLREALMS_TEXT			= "顯示所有伺服器"
BANKITEMS_EXPORTBUTTON_TEXT			= "輸出離線銀行..."
BANKITEMS_SEARCHBUTTON_TEXT			= "搜索離線銀行..."
BANKITEMS_EQUIPPED_ITEMS_TEXT		= "裝備的物品"
BANKITEMS_MAILBOX_ITEMS_TEXT		= "郵件內的物品"
BANKITEMS_MAILBOX_MONEY_TEXT		= "金錢 (總計)"

BANKITEMS_BEHAVIORLIST = {
	"打開銀行包裹",
	"打開隨身包裹",
	"打開裝備包裹",
	"打開郵件包裹",
}
BANKITEMS_BEHAVIORLIST2 = {
	"搜索銀行包裹",
	"搜索隨身包裹",
	"搜索裝備包裹",
	"搜索郵件包裹",
	"搜索公會銀行包裹",
}

BANKITEMS_BAGPARENT_CAUTION1_TEXT	= "注意 - 使用這個選項可能會污染寵物動作條"
BANKITEMS_BAGPARENT_CAUTION2_TEXT	= "並導致它在戰鬥中不顯示.當你遇到該問題時"
BANKITEMS_BAGPARENT_CAUTION3_TEXT	= "可以關掉這個選項,並重載介面."
BANKITEMS_BAGPARENT_CAUTION11_TEXT	= "建議 - 當你使用這個選項，且縮放不是100%"
BANKITEMS_BAGPARENT_CAUTION12_TEXT	= "的時候，可能會出現不相容的情況."

BANKITEMS_ALL_DELETED_TEXT			= "所有人物的資料已經清除."
BANKITEMS_DATA_NOT_FOUND_TEXT		= "沒有發現裝備檔案. 請重新登陸該人物或重載一次介面來生成資料檔案."
BANKITEMS_MAILDATA_NOT_FOUND_TEXT	= "沒有發現郵件物品檔案. 請用該人物流覽一次郵件來生成資料檔案."
BANKITEMS_BAG_NOT_INIT_TEXT			= "銀行包裹是空的，且沒有初始化."
BANKITEMS_NO_DATA_TEXT				= "沒有資料： "

BANKITEMS_SHOW_BAG_PREFIX_TEXT		= "顯示包裹首碼"
BANKITEMS_GROUP_DATA_TEXT			= "分組相似物品"
BANKITEMS_ALL_REALMS_TEXT			= "所有伺服器"

BANKITEMS_HAS_TEXT		= " 擁有 "

BANKITEMS_BANK_TEXT		= "銀行"
BANKITEMS_BAGS_TEXT		= "包裹"
BANKITEMS_EQUIPPED_TEXT	= "裝備"
BANKITEMS_MAIL_TEXT		= "郵件"
BANKITEMS_GBANK_TEXT	= "公會銀行"
BANKITEMS_GBANKS_TEXT	= "公會銀行"
BANKITEMS_TOTAL_PREFIX_TEXT	= "總計: "

BANKITEMS_NOT_SEEN_BEFORE_TEXT	= "(從未查看過)"
BANKITEMS_NO_BANK_TABS_TEXT		= "沒有公會銀行標籤"
BANKITEMS_NO_GUILBANK_DATA_TEXT	= "沒有公會銀行資料"
BANKITEMS_NOT_SEEN_BEFORE_TEXT2		= [[你以前從未看過 "%s" 的內容]]
BANKITEMS_NO_BANK_TABS_TEXT2		= "<%s> 的公會銀行還沒有購買任何標籤."
BANKITEMS_NO_GUILBANK_DATA_TEXT2	= "沒有任何可供顯示的公會銀行資料."

BANKITEMS_FeatureFrame_NAME_TEXT 	= "離線銀行"
BANKITEMS_FeatureFrame_TOOLTIP_TEXT 	= "讓你可以隨時流覽本ID所有伺服器所有人物的裝備以及背包、郵件和銀行中的物品"

BANKITEMS_FeatureFrame_GuildBankNAME_TEXT 	= "公會銀行"
BANKITEMS_FeatureFrame_GuildBankTOOLTIP_TEXT = "讓你可以隨時流覽本角色所在公會的公會銀行中的物品"

end
