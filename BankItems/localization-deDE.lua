-- BankItems deDE localization file, by kunda
if GetLocale() == "deDE" then
	BINDING_HEADER_BANKITEMS = "BankItems Tastaturbelegung"
	BINDING_NAME_TOGGLEBANKITEMS = "BankItems ein-/ausblenden"
	BINDING_NAME_TOGGLEBANKITEMSALL = "BankItems und alle Taschen ein-/ausblenden"
	BINDING_NAME_TOGGLEBANKITEMSBANK = "BankItems und alle Banktaschen ein-/ausblenden"
	BINDING_NAME_TOGGLEBANKITEMSGUILDBANK = "BankItems Gildenbank ein-/ausblenden"

	BANKITEMS_VERSIONTEXT = "BankItems v24002"
	BANKITEMS_HELPTEXT1 = "/bi oder /bankitems eintippen, um BankItems zu öffnen"
	BANKITEMS_HELPTEXT2 = "-- /bi all : Öffnet BankItems und alle Taschen (inklusive Bank)"
	BANKITEMS_HELPTEXT3 = "-- /bi allbank : Öffnet BankItems und alle Banktaschen"
	BANKITEMS_HELPTEXT4 = "-- /bi clear : Daten des momentan ausgewählten Spielers löschen"
	BANKITEMS_HELPTEXT5 = "-- /bi clearall : Alle Spielerdaten löschen"
	BANKITEMS_HELPTEXT6 = "-- /bi showbutton : Minimap Button anzeigen"
	BANKITEMS_HELPTEXT7 = "-- /bi hidebutton : Minimap Button ausblenden"
	BANKITEMS_HELPTEXT8 = "-- /bi search itemname : Suche nach Gegenständen"
	BANKITEMS_HELPTEXT9 = "-- /bis itemname : Suche nach Gegenständen"
	BANKITEMS_HELPTEXT10 = "-- /bigb : Öffnet BankItems Gildenbank"
	BANKITEMS_HELPTEXT11 = "-- /bigb clear : Daten der momentan ausgewählten Gilde löschen"

	BANKITEMS_MINIMAPBUTTON_TOOLTIP = "BankItems"
	BANKITEMS_MINIMAPBUTTON_TOOLTIP2 = "Linksklick um BankItems zu öffnen."
	BANKITEMS_MINIMAPBUTTON_TOOLTIP3 = "Rechtsklick und ziehen um Button zu bewegen."

	BANKITEMS_OPTION_TEXT = "Optionen..."
	BANKITEMS_OPTIONS_TEXT = "BankItems Optionen"
	BANKITEMS_LOCK_MAIN_WINDOW_TEXT = "Hauptfenster verriegeln (kein verschieben)"
	BANKITEMS_MINIMAP_BUTTON_TEXT = "Zeige Minimap Button"
	BANKITEMS_WINDOW_STYLE_TEXT = "BankItems mit Blizzard Fenster öffnen"
	BANKITEMS_BAGPARENT_TEXT = "BankItems Taschen mit Blizzard Taschen öffnen"
	BANKITEMS_TOOLTIP_INFO_TEXT = "Zeige BankItems Info im Tooltip"
	BANKITEMS_GTOOLTIP_TEXT = "Inklusive folgenden Gildenbank(en):"
	BANKITEMS_GTOOLTIP2_TEXT = "%d Gildenbank(en) ausgewählt"
	BANKITEMS_IGNORESOULBOUND_TEXT = "Nicht-stapelbare seelengeb. Gegenst. ignor."
	BANKITEMS_BEHAVIOR_TEXT = [[Beim Befehl "/bi":]]
	BANKITEMS_BEHAVIOR2_TEXT = "BankItems öffnen und..."
	BANKITEMS_BUTTONRADIUS_TEXT = "Minimap Button Radius"
	BANKITEMS_BUTTONPOS_TEXT = "Minimap Button Position"
	BANKITEMS_TRANSPARENCY_TEXT = "Transparenz"
	BANKITEMS_SCALING_TEXT = "Skalierung"
	BANKITEMS_RESET_TEXT = "Zurücksetzen"
	BANKITEMS_SEARCH_TEXT = "Suchen"
	BANKITEMS_SEARCH_FILTER_TEXT = "Folgendes durchsuchen:"

	BANKITEMS_TOTAL_TEXT = " (gesamt)"
	BANKITEMS_OF_TEXT = " von "
	BANKITEMS_CONTENTS_OF_TEXT = "Inhalt von: "
	BANKITEMS_CAUTION_TEXT = "ACHTUNG: Einige Gegenstände in diesem Report werden nicht angezeigt, weil sie momentan nicht in deinem lokalen WoW Cache existieren. Ein kürzlicher WoW Patch oder Launcher Update hat die Löschung des lokalen Caches verursacht. Log mit diesem Charakter nochmal ein und besuche die Bank um dies zu korrigieren ODER fahre mit der Maus über jeden Gegenstand in allen Taschen um den Server nach jedem ItemLink abzufragen (dies kann zu einem Disconnect führen).\n"
	BANKITEMS_BANK_ITEM_PREFIX_TEXT = "Bank Gegenstandplatz %d: "
	BANKITEMS_BAG_ITEM_PREFIX_TEXT = "Tasche %d Gegenstandplatz %d: "
	BANKITEMS_MONEY_PREFIX_TEXT = "Geld: "
	BANKITEMS_MONEY_FORMAT_TEXT = "%dg %ds %dk"
	BANKITEMS_SEARCH_COMPLETE_TEXT = [[Suche nach "%s" beendet.]]

	BANKITEMS_SEARCH_RESULLT_BANKITEM_TEXT = "     Bank Gegenstandplatz "
	BANKITEMS_SEARCH_RESULLT_EQUIPPED_TEXT = "     Angezogen: "
	BANKITEMS_SEARCH_RESULLT_MAILBOX_TEXT = "     Im Briefkasten: "
	BANKITEMS_SEARCH_RESULLT_BAG_TEXT = "     Tasche "
	BANKITEMS_SEARCH_RESULLT_TAB_TEXT = "     Gildenbankfach "
	BANKITEMS_SEARCH_RESULLT_ITEM_TEXT = " Gegenstandplatz "

	BANKITEMS_USERDROPDOWN_TOOLTIP_TEXT = "Du schaust gerade den Bankinhalt dieses Spielers an."
	BANKITEMS_ALLREALMS_TOOLTIP_TEXT = "Aktivieren, um alle gespeicherten Charaktere unabhängig vom Realm anzuzeigen."
	BANKITEMS_ALLREALMS_TEXT = "Zeige alle Realms"
	BANKITEMS_EXPORTBUTTON_TEXT = "BankItems exportieren..."
	BANKITEMS_SEARCHBUTTON_TEXT = "BankItems durchsuchen..."
	BANKITEMS_EQUIPPED_ITEMS_TEXT = "Angezogene Gegenstände"
	BANKITEMS_MAILBOX_ITEMS_TEXT = "Gegenstände im Briefkasten"
	BANKITEMS_MAILBOX_MONEY_TEXT = "Geld (gesamt)"

	BANKITEMS_BEHAVIORLIST = {
		"Banktaschen öffnen",
		"Inventartaschen öffnen",
		"'Angezogene Ausrüstung(s)' Tasche öffnen",
		"'Briefkastentasche' öffnen",
	}
	BANKITEMS_BEHAVIORLIST2 = {
		"Bank und Banktaschen",
		"Inventar",
		"Angezogene Ausrüstung ",
		"Briefkasten",
		"Gildenbank(en)",
	}

	BANKITEMS_BAGPARENT_CAUTION1_TEXT = "Achtung - Wenn Du diese Option benutzt kann es vorkommen, daß die Begleiterleiste"
	BANKITEMS_BAGPARENT_CAUTION2_TEXT = "gestört wird und nicht im Kampf angezeigt wird. Falls Probleme auftauchen"
	BANKITEMS_BAGPARENT_CAUTION3_TEXT = "solltest Du diese Option ausschalten und reloadui machen."
	BANKITEMS_BAGPARENT_CAUTION11_TEXT = "Hinweis - Blizzard Frames mögen es nicht, wenn die Skalierung"
	BANKITEMS_BAGPARENT_CAUTION12_TEXT = "nicht auf 100% ist wenn diese Option benutzt wird."

	BANKITEMS_ALL_DELETED_TEXT = "Alle Spielerdaten wurden gelöscht."
	BANKITEMS_DATA_NOT_FOUND_TEXT = "Angezogene Gegenstände nicht gefunden/aufgezeichnet. Bitte einmal mit diesem Charakter reloggen."
	BANKITEMS_MAILDATA_NOT_FOUND_TEXT = "Briefkastendaten nicht gefunden/aufgezeichnet. Bitte einmal mit diesem Charakter den Briefkasten besuchen."
	BANKITEMS_BAG_NOT_INIT_TEXT = "Banktaschen sind leer und nicht initialisiert."
	BANKITEMS_NO_DATA_TEXT = "Keine Daten vorhanden für: "

	BANKITEMS_SHOW_BAG_PREFIX_TEXT = "Taschenplatz anzeigen"
	BANKITEMS_GROUP_DATA_TEXT = "Gleiche Gegenstände gruppieren"
	BANKITEMS_ALL_REALMS_TEXT = "Alle Realms"

	BANKITEMS_HAS_TEXT = " hat "

	BANKITEMS_BANK_TEXT = "Bank"
	BANKITEMS_BAGS_TEXT = "Tasche"
	BANKITEMS_EQUIPPED_TEXT = "Angezogen"
	BANKITEMS_MAIL_TEXT = "Briefkasten"
	BANKITEMS_GBANK_TEXT = "Gildenbank"
	BANKITEMS_GBANKS_TEXT = "Gildenbanken"
	BANKITEMS_TOTAL_PREFIX_TEXT = "Gesamt: "

	BANKITEMS_NOT_SEEN_BEFORE_TEXT = "(Noch nicht gesehen)"
	BANKITEMS_NO_BANK_TABS_TEXT = "Kein Gildenbankfach"
	BANKITEMS_NO_GUILBANK_DATA_TEXT = "Keine Gildenbank Daten"
	BANKITEMS_NOT_SEEN_BEFORE_TEXT2 = [[Du hast den Inhalt von "%s" noch nicht gesehen]]
	BANKITEMS_NO_BANK_TABS_TEXT2 = "Es wurde noch kein Gildenbankfach von <%s> gekauft."
	BANKITEMS_NO_GUILBANK_DATA_TEXT2 = "Du hast keine Gildenbank Daten zum anzeigen."

	BANKITEMS_FeatureFrame_NAME_TEXT = "OfflineBank"
	BANKITEMS_FeatureFrame_TOOLTIP_TEXT = "Bank-, Inventar- und Briefkasteninhalt von überall anschauen!"

	BANKITEMS_FeatureFrame_GuildBankNAME_TEXT = "GuildBank"
	BANKITEMS_FeatureFrame_GuildBankTOOLTIP_TEXT = "Gildenbankinhalt von überall anschauen!"
end