if GetLocale() == "zhCN" then
-- localization.cn.lua (Chinese)
-- Date: 2007-10-6
-- Translator: Isler
BINDING_HEADER_BANKITEMS			= "离线银行"
BINDING_NAME_TOGGLEBANKITEMS		= "打开离线银行"
BINDING_NAME_TOGGLEBANKITEMSALL		= "打开离线银行及所有包裹"
BINDING_NAME_TOGGLEBANKITEMSBANK	= "打开离线银行及银行包裹"
BINDING_NAME_TOGGLEBANKITEMSGUILDBANK	= "打开离线公会银行"

BANKITEMS_VERSIONTEXT	= "BankItems v24002"
BANKITEMS_HELPTEXT1 	= "输入 /bi 或 /bankitems 打开离线银行"
BANKITEMS_HELPTEXT2 	= "-- /bi all : 打开离线银行及所有包裹"
BANKITEMS_HELPTEXT3 	= "-- /bi allbank : 打开离线银行及所有银行包裹"
BANKITEMS_HELPTEXT4 	= "-- /bi clear : 清除所选择的人物的信息"
BANKITEMS_HELPTEXT5 	= "-- /bi clearall : 清除所有人物的信息"
BANKITEMS_HELPTEXT6 	= "-- /bi showbutton : 显示小地图按钮"
BANKITEMS_HELPTEXT7 	= "-- /bi hidebutton : 隐藏小地图按钮"
BANKITEMS_HELPTEXT8 	= "-- /bi search itemname : 搜索物品"
BANKITEMS_HELPTEXT9 	= "-- /bis itemname : 搜索物品"
BANKITEMS_HELPTEXT10 	= "-- /bigb: 打开离线公会银行"
BANKITEMS_HELPTEXT11 	= "-- /bigb clear : 清除所选择的公会银行信息"

BANKITEMS_MINIMAPBUTTON_TOOLTIP		= "离线银行"
BANKITEMS_MINIMAPBUTTON_TOOLTIP2	= "左键点击打开离线银行."
BANKITEMS_MINIMAPBUTTON_TOOLTIP3	= "右键点击并拖动来移动按钮."

BANKITEMS_OPTION_TEXT			= "设定..."
BANKITEMS_OPTIONS_TEXT			= "离线银行设定"
BANKITEMS_LOCK_MAIN_WINDOW_TEXT	= "锁定主窗口以防止拖动"
BANKITEMS_MINIMAP_BUTTON_TEXT	= "显示小地图按钮"
BANKITEMS_WINDOW_STYLE_TEXT		= "以暴雪的窗口方式打开离线银行"
BANKITEMS_BAGPARENT_TEXT		= "以暴雪的包裹方式打开离线银行的包裹"
BANKITEMS_TOOLTIP_INFO_TEXT		= "在物品上显示额外的鼠标提示信息"
BANKITEMS_GTOOLTIP_TEXT			= "包含以下公会银行:"
BANKITEMS_GTOOLTIP2_TEXT		= "已选择 %d 个公会银行"
BANKITEMS_IGNORESOULBOUND_TEXT 	= "忽略不可堆叠的灵魂绑定物品"
BANKITEMS_BEHAVIOR_TEXT			= [[在输入命令 "/bi":]]
BANKITEMS_BEHAVIOR2_TEXT		= "打开离线银行的同时..."
BANKITEMS_BUTTONRADIUS_TEXT		= "小地图按钮半径"
BANKITEMS_BUTTONPOS_TEXT		= "小地图按钮位置"
BANKITEMS_TRANSPARENCY_TEXT		= "透明度"
BANKITEMS_SCALING_TEXT			= "缩放"
BANKITEMS_RESET_TEXT			= "重置"
BANKITEMS_SEARCH_TEXT			= "搜索"
BANKITEMS_SEARCH_FILTER_TEXT	= "搜索这些包裹..."

BANKITEMS_TOTAL_TEXT			= " (总计)"
BANKITEMS_OF_TEXT				= " 在 "
BANKITEMS_CONTENTS_OF_TEXT		= "搜索结果: "
BANKITEMS_CAUTION_TEXT			= "注意: 一些装备未在报告中解析并发布因为它们没有在本地缓存中被发现.最近的一次游戏更新清空了本地缓存.你可以登陆该角色并浏览银行物品来解决这个问题或者把鼠标在每个包裹的每件物品上悬停来向服务器查询物品链接(这可能导致你掉线).\n"
BANKITEMS_BANK_ITEM_PREFIX_TEXT	= "银行物品 %d: "
BANKITEMS_BAG_ITEM_PREFIX_TEXT	= "包裹 %d 物品 %d: "
BANKITEMS_MONEY_PREFIX_TEXT		= "金钱: "
BANKITEMS_MONEY_FORMAT_TEXT		= "%d金 %d银 %d铜"
BANKITEMS_SEARCH_COMPLETE_TEXT	= [[搜索 "%s" 完成.]]

BANKITEMS_SEARCH_RESULLT_BANKITEM_TEXT	= "     银行物品 "
BANKITEMS_SEARCH_RESULLT_EQUIPPED_TEXT 	= "     装备的: "
BANKITEMS_SEARCH_RESULLT_MAILBOX_TEXT 	= "     邮件内: "
BANKITEMS_SEARCH_RESULLT_BAG_TEXT 		= "     包裹 "
BANKITEMS_SEARCH_RESULLT_TAB_TEXT		= "     标签 "
BANKITEMS_SEARCH_RESULLT_ITEM_TEXT		= " 物品 "

BANKITEMS_USERDROPDOWN_TOOLTIP_TEXT	= "你正在浏览该人物的银行物品."
BANKITEMS_ALLREALMS_TOOLTIP_TEXT	= "点击这里选择所有保存的人物的银行信息（所有服务器）."
BANKITEMS_ALLREALMS_TEXT			= "显示所有服务器"
BANKITEMS_EXPORTBUTTON_TEXT			= "输出离线银行..."
BANKITEMS_SEARCHBUTTON_TEXT			= "搜索离线银行..."
BANKITEMS_EQUIPPED_ITEMS_TEXT		= "装备的物品"
BANKITEMS_MAILBOX_ITEMS_TEXT		= "邮件内的物品"
BANKITEMS_MAILBOX_MONEY_TEXT		= "金钱 (总计)"

BANKITEMS_BEHAVIORLIST = {
	"打开银行包裹",
	"打开随身包裹",
	"打开装备包裹",
	"打开邮件包裹",
}
BANKITEMS_BEHAVIORLIST2 = {
	"搜索银行包裹",
	"搜索随身包裹",
	"搜索装备包裹",
	"搜索邮件包裹",
	"搜索公会银行包裹",
}

BANKITEMS_BAGPARENT_CAUTION1_TEXT	= "注意 - 使用这个选项可能会污染宠物动作条"
BANKITEMS_BAGPARENT_CAUTION2_TEXT	= "并导致它在战斗中不显示.当你遇到该问题时"
BANKITEMS_BAGPARENT_CAUTION3_TEXT	= "可以关掉这个选项,并重载界面."
BANKITEMS_BAGPARENT_CAUTION11_TEXT	= "建议 - 当你使用这个选项，且缩放不是100%"
BANKITEMS_BAGPARENT_CAUTION12_TEXT	= "的时候，可能会出现不兼容的情况."

BANKITEMS_ALL_DELETED_TEXT			= "所有人物的数据已经清除."
BANKITEMS_DATA_NOT_FOUND_TEXT		= "没有发现装备档案. 请重新登陆该人物或重载一次界面来生成数据档案."
BANKITEMS_MAILDATA_NOT_FOUND_TEXT	= "没有发现邮件物品档案. 请用该人物浏览一次邮件来生成数据档案."
BANKITEMS_BAG_NOT_INIT_TEXT			= "银行包裹是空的，且没有初始化."
BANKITEMS_NO_DATA_TEXT				= "没有数据： "

BANKITEMS_SHOW_BAG_PREFIX_TEXT		= "显示包裹前缀"
BANKITEMS_GROUP_DATA_TEXT			= "分组相似物品"
BANKITEMS_ALL_REALMS_TEXT			= "所有服务器"

BANKITEMS_HAS_TEXT		= " 拥有 "

BANKITEMS_BANK_TEXT		= "银行"
BANKITEMS_BAGS_TEXT		= "包裹"
BANKITEMS_EQUIPPED_TEXT	= "装备"
BANKITEMS_MAIL_TEXT		= "邮件"
BANKITEMS_GBANK_TEXT	= "公会银行"
BANKITEMS_GBANKS_TEXT	= "公会银行"
BANKITEMS_TOTAL_PREFIX_TEXT	= "总计: "

BANKITEMS_NOT_SEEN_BEFORE_TEXT	= "(从未查看过)"
BANKITEMS_NO_BANK_TABS_TEXT		= "没有公会银行标签"
BANKITEMS_NO_GUILBANK_DATA_TEXT	= "没有公会银行数据"
BANKITEMS_NOT_SEEN_BEFORE_TEXT2		= [[你以前从未看过 "%s" 的内容]]
BANKITEMS_NO_BANK_TABS_TEXT2		= "<%s> 的公会银行还没有购买任何标签."
BANKITEMS_NO_GUILBANK_DATA_TEXT2	= "没有任何可供显示的公会银行数据."

BANKITEMS_FeatureFrame_NAME_TEXT 	= "离线银行"
BANKITEMS_FeatureFrame_TOOLTIP_TEXT 	= "让你可以随时浏览本ID所有服务器所有人物的装备以及背包、邮件和银行中的物品"

BANKITEMS_FeatureFrame_GuildBankNAME_TEXT 	= "公会银行"
BANKITEMS_FeatureFrame_GuildBankTOOLTIP_TEXT = "让你可以随时浏览本角色所在公会的公会银行中的物品"

end
