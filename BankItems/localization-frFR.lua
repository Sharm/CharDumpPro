-- BankItems frFR localization file, by pettigrow
if GetLocale() == "frFR" then
	BINDING_HEADER_BANKITEMS = "Raccourcis BankItems"
	BINDING_NAME_TOGGLEBANKITEMS = "Ouvrir/fermer BankItems"
	BINDING_NAME_TOGGLEBANKITEMSALL = "Ouvrir/fermer BankItems et les sacs"
	BINDING_NAME_TOGGLEBANKITEMSBANK = "Ouvrir/fermer BankItems et les sacs de banque"
	BINDING_NAME_TOGGLEBANKITEMSGUILDBANK = "Ouvrir/fermer la banque de guilde de BankItems"

	BANKITEMS_VERSIONTEXT	= "BankItems v24002"
	BANKITEMS_HELPTEXT1 = "Tapez /bi ou /bankitems pour ouvrir BankItems"
	BANKITEMS_HELPTEXT2 = "-- /bi all : ouvre BankItems et tous les sacs"
	BANKITEMS_HELPTEXT3 = "-- /bi allbank : ouvre BankItems et uniquement tous les sacs de banque"
	BANKITEMS_HELPTEXT4 = "-- /bi clear : efface les infos du personnage actuellement sélectionné"
	BANKITEMS_HELPTEXT5 = "-- /bi clearall : efface les infos de tous les joueurs"
	BANKITEMS_HELPTEXT6 = "-- /bi showbutton : affiche le bouton de la minicarte"
	BANKITEMS_HELPTEXT7 = "-- /bi hidebutton : masque le bouton de la minicarte"
	BANKITEMS_HELPTEXT8 = "-- /bi search nomobjet : recherche l'objet indiqué"
	BANKITEMS_HELPTEXT9 = "-- /bis nomobjet : recherche l'objet indiqué"
	BANKITEMS_HELPTEXT10 = "-- /bigb : ouvre la banque de guilde dans BankItems"
	BANKITEMS_HELPTEXT11 = "-- /bigb clear : efface les infos de la guilde sélectionnée"

	BANKITEMS_MINIMAPBUTTON_TOOLTIP = "BankItems"
	BANKITEMS_MINIMAPBUTTON_TOOLTIP2 = "Clic gauche pour ouvrir BankItems."
	BANKITEMS_MINIMAPBUTTON_TOOLTIP3 = "Clic droit et saisir pour déplacer ce bouton."

	BANKITEMS_OPTION_TEXT = "Options..."
	BANKITEMS_OPTIONS_TEXT = "Options de BankItems"
	BANKITEMS_LOCK_MAIN_WINDOW_TEXT = "Verrouiller la fenêtre principale"
	BANKITEMS_MINIMAP_BUTTON_TEXT = "Afficher le bouton de la minicarte"
	BANKITEMS_WINDOW_STYLE_TEXT = "Ouvrir BankItems avec les fenêtres Blizzard"
	BANKITEMS_BAGPARENT_TEXT = "Ouvrir les sacs de BI avec ceux de Blizzard"
	BANKITEMS_TOOLTIP_INFO_TEXT = "Infos suppl. dans l'infobulle des objets"
	BANKITEMS_GTOOLTIP_TEXT = "Inclure les banques de guilde suivantes :"
	BANKITEMS_GTOOLTIP2_TEXT = "%d banque(s) de guilde cochée(s)"
	BANKITEMS_IGNORESOULBOUND_TEXT = "Ignore unstackable soulbound items"
	BANKITEMS_BEHAVIOR_TEXT = [[À la commande "/bi" :]]
	BANKITEMS_BEHAVIOR2_TEXT = "Ouvrir BankItems et..."
	BANKITEMS_BUTTONRADIUS_TEXT = "Rayon du bouton de la minicarte"
	BANKITEMS_BUTTONPOS_TEXT = "Position du bouton de la minicarte"
	BANKITEMS_TRANSPARENCY_TEXT = "Transparence"
	BANKITEMS_SCALING_TEXT = "Échelle"
	BANKITEMS_RESET_TEXT = "RÀZ"
	BANKITEMS_SEARCH_TEXT = "Rechercher"
	BANKITEMS_SEARCH_FILTER_TEXT = "Rechercher dans..."

	BANKITEMS_TOTAL_TEXT = " (total)"
	BANKITEMS_OF_TEXT = " de "
	BANKITEMS_CONTENTS_OF_TEXT = "Contenu de "
	BANKITEMS_CAUTION_TEXT = "ATTENTION : Certains objets n'ont pas été parsed/affichés dans ce rapport car ils n'existent pas pas encore dans votre cache local de WoW. Un patch WoW récent ou une mise à jour du lanceur a sans doute causé le nettoyage du cache local. Connectez ce personnage et ouvrez la banque pour corriger ceci, OU passez votre souris sur tous les objets de tous les sacs pour faire une requête serveur pour chaque lien d'objet (ceci peut vous déconnecter).\n"
	BANKITEMS_BANK_ITEM_PREFIX_TEXT = "Objet de banque %d : "
	BANKITEMS_BAG_ITEM_PREFIX_TEXT = "Sac %d Objet %d : "
	BANKITEMS_MONEY_PREFIX_TEXT = "Argent : "
	BANKITEMS_MONEY_FORMAT_TEXT = "%do %da %dc"
	BANKITEMS_SEARCH_COMPLETE_TEXT = [[Recherche concernant "%s" terminée.]]

	BANKITEMS_SEARCH_RESULLT_BANKITEM_TEXT = "     Objet de banque "
	BANKITEMS_SEARCH_RESULLT_EQUIPPED_TEXT = "     Equipé : "
	BANKITEMS_SEARCH_RESULLT_MAILBOX_TEXT = "     Courrier : "
	BANKITEMS_SEARCH_RESULLT_BAG_TEXT = "     Sac "
	BANKITEMS_SEARCH_RESULLT_TAB_TEXT = "     Onglet "
	BANKITEMS_SEARCH_RESULLT_ITEM_TEXT = " Objet "

	BANKITEMS_USERDROPDOWN_TOOLTIP_TEXT = "Vous regardez actuellement le contenu de la banque de ce joueur."
	BANKITEMS_ALLREALMS_TOOLTIP_TEXT = "Cochez pour afficher tous les personnages sauvegardés, quelques soit leurs royaumes."
	BANKITEMS_ALLREALMS_TEXT = "Tous les royaumes"
	BANKITEMS_EXPORTBUTTON_TEXT = "Exporter BankItems..."
	BANKITEMS_SEARCHBUTTON_TEXT = "Rechercher dans BankItems..."
	BANKITEMS_EQUIPPED_ITEMS_TEXT = "Objets équipés"
	BANKITEMS_MAILBOX_ITEMS_TEXT = "Objets du courrier"
	BANKITEMS_MAILBOX_MONEY_TEXT = "Argent (cumulé)"

	BANKITEMS_BEHAVIORLIST = {
		"Ouvrir les sacs de banque",
		"Ouvrir les sacs de l'inventaire",
		"Ouvrir le sac des équipés",
		"Ouvrir le sac du courrier",
	}
	BANKITEMS_BEHAVIORLIST2 = {
		"Rechercher dans la banque et dans ses sacs",
		"Rechercher dans les sacs de l'inventaire",
		"Rechercher dans les objets équipés",
		"Rechercher dans la boîte aux lettres",
		"Rechercher dans la banque de guilde",
	}

	BANKITEMS_BAGPARENT_CAUTION1_TEXT = "Attention - Utiliser cette option peut corrompre la barre de fam."
	BANKITEMS_BAGPARENT_CAUTION2_TEXT = "et empêcher son affichage en combat. Il est recommandé de la désactiver"
	BANKITEMS_BAGPARENT_CAUTION3_TEXT = "et d'ensuite recharger l'IU si vous rencontrez des problèmes."
	BANKITEMS_BAGPARENT_CAUTION11_TEXT = "Note - Les fenêtres de Blizzard n'aiment pas si votre"
	BANKITEMS_BAGPARENT_CAUTION12_TEXT = "échelle n'est pas de 100% quand vous utilisez cette option."

	BANKITEMS_ALL_DELETED_TEXT = "Les données de tous les personnages ont été effacées."
	BANKITEMS_DATA_NOT_FOUND_TEXT = "Données des objets équipés introuvables. Veuillez connecter au moins une fois ce personnage pour les enregistrer."
	BANKITEMS_MAILDATA_NOT_FOUND_TEXT = "Données des objets du courrier introuvables. Veuillez vous rendre au moins une fois à la boîte aux lettres sur ce personnage pour les enregistrer."
	BANKITEMS_BAG_NOT_INIT_TEXT = "Le sac de banque est vide et non initialisé."
	BANKITEMS_NO_DATA_TEXT = "Il n'existe aucune donnée pour "

	BANKITEMS_SHOW_BAG_PREFIX_TEXT = "Afficher le préfixe des sacs"
	BANKITEMS_GROUP_DATA_TEXT = "Grouper les objets similaires"
	BANKITEMS_ALL_REALMS_TEXT = "Tout serveur"

	BANKITEMS_HAS_TEXT = " en a "

	BANKITEMS_BANK_TEXT = "Banque"
	BANKITEMS_BAGS_TEXT = "Sacs"
	BANKITEMS_EQUIPPED_TEXT = "Équipé"
	BANKITEMS_MAIL_TEXT = "Courrier"
	BANKITEMS_GBANK_TEXT = "Banque de guilde"
	BANKITEMS_GBANKS_TEXT = "Guildes"
	BANKITEMS_TOTAL_PREFIX_TEXT = "Total : "

	BANKITEMS_NOT_SEEN_BEFORE_TEXT = "(jamais vu auparavant)"
	BANKITEMS_NO_BANK_TABS_TEXT = "Aucun onglet de guilde"
	BANKITEMS_NO_GUILBANK_DATA_TEXT = "Banques de guilde : aucune donnée"
	BANKITEMS_NOT_SEEN_BEFORE_TEXT2 = [[Vous n'avez encore jamais vu le contenu de l'onglet "%s".]]
	BANKITEMS_NO_BANK_TABS_TEXT2 = "La banque de guilde de <%s> n'a aucun onglet."
	BANKITEMS_NO_GUILBANK_DATA_TEXT2 = "Il n'y a aucune donnée concernant les banques de guilde à afficher."

	BANKITEMS_FeatureFrame_NAME_TEXT = "BanqueHorsLigne"
	BANKITEMS_FeatureFrame_TOOLTIP_TEXT = "Permet de voir le contenu de votre banque/inventaire/courrier de n'importe où !"

	BANKITEMS_FeatureFrame_GuildBankNAME_TEXT = "BanqueGuilde"
	BANKITEMS_FeatureFrame_GuildBankTOOLTIP_TEXT = "Permet de voir le contenu de la banque de guilde de n'importe où !"
end