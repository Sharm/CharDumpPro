-- BankItems ruRU localization file by StingerSoft (Eritnull aka Шептун)
if GetLocale() == "ruRU" then
BINDING_HEADER_BANKITEMS		= "Клавиши BankItems"
BINDING_NAME_TOGGLEBANKITEMS		= "Открыть/Закрыть BankItems"
BINDING_NAME_TOGGLEBANKITEMSALL		= "Открыть/Закрыть BankItems и все Сумки"
BINDING_NAME_TOGGLEBANKITEMSBANK	= "Открыть/Закрыть BankItems и все сумка банка"
BINDING_NAME_TOGGLEBANKITEMSGUILDBANK	= "Открыть/Закрыть BankItems Гильд Банк"

BANKITEMS_VERSIONTEXT	= "BankItems v24002"
BANKITEMS_HELPTEXT1 	= "Для открытия BankItems введите: /bi или /bankitems"
BANKITEMS_HELPTEXT2 	= "-- /bi all : открыть BankItems и все сумки"
BANKITEMS_HELPTEXT3 	= "-- /bi allbank : открыть BankItems и все сумки банка"
BANKITEMS_HELPTEXT4 	= "-- /bi clear : очистить информацию о выбранных игроках"
BANKITEMS_HELPTEXT5 	= "-- /bi clearall : очистить информацию о всех игроках"
BANKITEMS_HELPTEXT6 	= "-- /bi showbutton : показать кнопку у мини-карты"
BANKITEMS_HELPTEXT7 	= "-- /bi hidebutton : скрыть кнопку у мини-карты"
BANKITEMS_HELPTEXT8 	= "-- /bi search itemname : поиск предмета"
BANKITEMS_HELPTEXT9 	= "-- /bis itemname : поиск предмета"
BANKITEMS_HELPTEXT10 	= "-- /bigb : открыть BankItems гильд банк"
BANKITEMS_HELPTEXT11 	= "-- /bigb clear : очистить информацию о выбранной гильдии"

BANKITEMS_MINIMAPBUTTON_TOOLTIP		= "BankItems"
BANKITEMS_MINIMAPBUTTON_TOOLTIP2	= "ЛКМ: открывает/закрывает окно BankItems."
BANKITEMS_MINIMAPBUTTON_TOOLTIP3	= "УДЕРЖИВАЯ ПКМ: дает возможность изменять позицию кнопки."

BANKITEMS_OPTION_TEXT		= "Настройки..."
BANKITEMS_OPTIONS_TEXT		= "Настройки BankItems"
BANKITEMS_LOCK_MAIN_WINDOW_TEXT	= "Зафиксировать главное окно от перемещения"
BANKITEMS_MINIMAP_BUTTON_TEXT	= "Показать кнопку у мини-карты"
BANKITEMS_WINDOW_STYLE_TEXT	= "Возмож-ть открытия окна BankItems рядом с окном банка"
BANKITEMS_BAGPARENT_TEXT	= "Открывать сумки BankItems рядом с сумками персонажа"
BANKITEMS_TOOLTIP_INFO_TEXT	= "Показ. добавочную информацию о предмете в тултипе"
BANKITEMS_GTOOLTIP_TEXT		= "Включая следующие Гильд Банки:"
BANKITEMS_GTOOLTIP2_TEXT	= "%d выбрано Гильд Банк(а)"
BANKITEMS_IGNORESOULBOUND_TEXT = "Игнорировать именные не стыкующиеся предметы"
BANKITEMS_BEHAVIOR_TEXT		= [[По команде "/bi":]]
BANKITEMS_BEHAVIOR2_TEXT	= "Открыть BankItems и..."
BANKITEMS_BUTTONRADIUS_TEXT	= "Радиус кнопки у мини-карты"
BANKITEMS_BUTTONPOS_TEXT	= "Позиция кнопки у мини-карты"
BANKITEMS_TRANSPARENCY_TEXT	= "Прозрачность"
BANKITEMS_SCALING_TEXT		= "Масштаб"
BANKITEMS_RESET_TEXT		= "Сброс"
BANKITEMS_SEARCH_TEXT		= "Поиск"
BANKITEMS_SEARCH_FILTER_TEXT	= "Поиск в сумках..."

BANKITEMS_TOTAL_TEXT		= " (всего)"
BANKITEMS_OF_TEXT		= " из "
BANKITEMS_CONTENTS_OF_TEXT	= "Содержимое "
BANKITEMS_CAUTION_TEXT		= "CAUTION: Some items were not parsed/displayed in this report because they do not exist in your WoW local cache yet. A recent WoW patch or launcher update caused the local cache to be cleared. Log on this character and visit the bank to correct this OR hover your mouse on every item in every bag to query the server for each itemlink (this may disconnect you).\n"
BANKITEMS_BANK_ITEM_PREFIX_TEXT	= "Предмет в банке %d: "
BANKITEMS_BAG_ITEM_PREFIX_TEXT	= "Сумка %d Предмет %d: "
BANKITEMS_MONEY_PREFIX_TEXT	= "Денег: "
BANKITEMS_MONEY_FORMAT_TEXT	= "%dз %dс %dм"
BANKITEMS_SEARCH_COMPLETE_TEXT	= [[Поиск "%s" закончен.]]

BANKITEMS_SEARCH_RESULLT_BANKITEM_TEXT	= "     Предмет в Банке "
BANKITEMS_SEARCH_RESULLT_EQUIPPED_TEXT	= "     На персонаже: "
BANKITEMS_SEARCH_RESULLT_MAILBOX_TEXT	= "     На Почте: "
BANKITEMS_SEARCH_RESULLT_BAG_TEXT	= "     Сумка "
BANKITEMS_SEARCH_RESULLT_TAB_TEXT	= "     Раздел "
BANKITEMS_SEARCH_RESULLT_ITEM_TEXT	= " Предмет "

BANKITEMS_USERDROPDOWN_TOOLTIP_TEXT	= "Вы просматриваете содержимое банков данных игроков."
BANKITEMS_ALLREALMS_TOOLTIP_TEXT	= "Просмотр всех сохранённых персонажей, независимо от миров."
BANKITEMS_ALLREALMS_TEXT		= "Все Миры"
BANKITEMS_EXPORTBUTTON_TEXT		= "Экспорт..."
BANKITEMS_SEARCHBUTTON_TEXT		= "Поиск..."
BANKITEMS_EQUIPPED_ITEMS_TEXT		= "Предметы на персонаже"
BANKITEMS_MAILBOX_ITEMS_TEXT		= "Предметы на почте"
BANKITEMS_MAILBOX_MONEY_TEXT		= "Деньги (общий)"

BANKITEMS_BEHAVIORLIST = {
	"Сумки банка",
	"Сумки инвентаря",
	"Окно предметов На персонаже",
	"Окно предметов на Почте",
}
BANKITEMS_BEHAVIORLIST2 = {
	"Поиск в банке и сумках банка",
	"Поиск в сумках инвентаря",
	"Поиск в вещах на персонаже",
	"Поиск в почте",
	"Поиск в гильд банках",
}

BANKITEMS_BAGPARENT_CAUTION1_TEXT	= "Осторожно - Используя данную опцию можно испортить панель питомца и"
BANKITEMS_BAGPARENT_CAUTION2_TEXT	= "не допустить её отображение в бою. Столкнувшись с данной проблемой мы вам"
BANKITEMS_BAGPARENT_CAUTION3_TEXT	= "рекомендуем отключить данную опцию и перезагрузить ПИ."
BANKITEMS_BAGPARENT_CAUTION11_TEXT	= "Заметка - Открытие Blizzard окна банка не рекомендуется если ваш"
BANKITEMS_BAGPARENT_CAUTION12_TEXT	= "масштаб не установлен 100%, при использовании данной опции."

BANKITEMS_ALL_DELETED_TEXT		= "Данные о всех персонажах были очищены."
BANKITEMS_DATA_NOT_FOUND_TEXT		= "Донные о предметах на персонаже не найдены/записаны. Пожалуйста зайдите за данного персонажа для записи данных."
BANKITEMS_MAILDATA_NOT_FOUND_TEXT	= "Донные о предметах в почте не найдены/записаны. Пожалуйста посетите почту для записи данных."
BANKITEMS_BAG_NOT_INIT_TEXT		= "Сумки банка пустые,и не инициализированы."
BANKITEMS_NO_DATA_TEXT			= "Нету данных для "

BANKITEMS_SHOW_BAG_PREFIX_TEXT		= "Показать префикс сумки"
BANKITEMS_GROUP_DATA_TEXT		= "Подобные предметы"
BANKITEMS_ALL_REALMS_TEXT		= "Все Миры"

BANKITEMS_HAS_TEXT		= " имеет "

BANKITEMS_BANK_TEXT	= "В Банке"
BANKITEMS_BAGS_TEXT	= "В Сумках"
BANKITEMS_EQUIPPED_TEXT	= "На персонаже"
BANKITEMS_MAIL_TEXT	= "Почта"
BANKITEMS_GBANK_TEXT	= "Гильд Банк"
BANKITEMS_GBANKS_TEXT	= "Гильд Банки"
BANKITEMS_TOTAL_PREFIX_TEXT	= "Всего: "

BANKITEMS_NOT_SEEN_BEFORE_TEXT	= "(Не Виданный Раньше)"
BANKITEMS_NO_BANK_TABS_TEXT	= "Нет разделов Гильд Банка"
BANKITEMS_NO_GUILBANK_DATA_TEXT	= "Нет данный о Гильд Банке"
BANKITEMS_NOT_SEEN_BEFORE_TEXT2		= [[Вы раньше не встречали "%s"]]
BANKITEMS_NO_BANK_TABS_TEXT2		= "<%s> не приобрел не одного раздела в гильд банке."
BANKITEMS_NO_GUILBANK_DATA_TEXT2	= "У вас нету никаких данных для отображения гильд банка."

BANKITEMS_FeatureFrame_NAME_TEXT = "Автономный Банк"
BANKITEMS_FeatureFrame_TOOLTIP_TEXT = "Просмотр содержимого банка/инвентаря/почты в любое время!"

BANKITEMS_FeatureFrame_GuildBankNAME_TEXT = "Гильд Банк"
BANKITEMS_FeatureFrame_GuildBankTOOLTIP_TEXT = "Просмотр содержимого Гильд Банка в любое время!"
end
