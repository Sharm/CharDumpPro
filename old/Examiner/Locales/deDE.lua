-- German localization by Haldamir of Gorgonnash, 19.6. 2007
-- Modified by xonyx (aka Siphony of EU-Onyxia) for Patch 2.3, 15.11.2007 & 25.12.2007

if (GetLocale() == "deDE") then
--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

BINDING_HEADER_EXAMINER = "Examiner";
BINDING_NAME_EXAMINER_OPEN = "\195\150ffne Examiner";
BINDING_NAME_EXAMINER_TARGET = "Ziel inspizieren";
BINDING_NAME_EXAMINER_MOUSEOVER = "Mouseover inspizieren";

Examiner.Classification = {
	["worldboss"] = "Boss",
	["rareelite"] = "RarElite",
	["elite"] = "Elite",
	["Rare"] = "Rar",
};

ExScanner.SetBonusTokenActive = "^Anlegen: ";
ExScanner.ItemUseToken = "^Benutzen: ";

--------------------------------------------------------------------------------------------------------
--                                           Stat Patterns                                            --
--------------------------------------------------------------------------------------------------------

ExScanner.Patterns = {
	-- Base stats
	{ p = "%+(%d+) St\195\164rke", s = "STR" },
	{ p = "%+(%d+) Beweglichkeit", s = "AGI" },
	{ p = "%+(%d+) Ausdauer", s = "STA" },
	{ p = "Ausdauer %+(%d+)", s = "STA" }, -- WORKAROUND: Infused Amethyst (31116) => Energieerfüllter Amethyst 		
	{ p = "%+(%d+) Intelligenz", s = "INT" },
	{ p = "%+(%d+) Willenskraft", s = "SPI" },
	{ p = "(%d+) R\195\188stung", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits

	-- Resistances (Exclude the Resist-"ance" then it picks up armor patches as well)
	{ p = "%+(%d+) Arkanwiderstand", s = "ARCANERESIST" },
	{ p = "%+(%d+) Feuerwiderstand", s = "FIRERESIST" },
	{ p = "%+(%d+) Naturwiderstand", s = "NATURERESIST" },
	{ p = "%+(%d+) Frostwiderstand", s = "FROSTRESIST" },
	{ p = "%+(%d+) Schattenwiderstand", s = "SHADOWRESIST" },
	{ p = "%+(%d+) Alle Widerstandsarten", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },
	-- Void Sphere => Sphäre der Leere (already covered by "Alle Widerstandsarten")

	-- Equip (Other)
	{ p = "Erh\195\182ht Eure Abh\195\164rtungswertung um (%d+)%.", s = "RESILIENCE" },

	{ p = "Erh\195\182ht die Verteidigungswertung um (%d+)%.", s = "DEFENSE" },
	{ p = "Erh\195\182ht Eure Ausweichwertung um (%d+)%.", s = "DODGE" },
	{ p = "Erh\195\182ht Eure Parierwertung um (%d+)%.", s = "PARRY" },
	{ p = "Erh\195\182ht Eure Blockwertung um (%d+)%.", s = "BLOCK" },

	{ p = "Erh\195\182ht den Blockwert Eures Schildes um (%d+)%.", s = "BLOCKVALUE" },
	{ p = "^(%d+) Blocken$", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield -- translated by g3gg0

	-- Equip (Melee)
	{ p = "Erh\195\182ht kritische Trefferwertung um (%d+)%.", s = "CRIT" },
	{ p = "Erh\195\182ht Eure kritische Trefferwertung um (%d+)%.", s = "CRIT" },
	{ p = "Erh\195\182ht Trefferwertung um (%d+)%.", s = "HIT" },
	{ p = "Erh\195\182ht Eure Trefferwertung um (%d+)%.", s = "HIT" },

	{ p = "Erh\195\182ht die Angriffskraft um (%d+)%.", s = "AP" },
	{ p = "Erh\195\182ht die Distanzangriffskraft um (%d+)%.", s = "RAP" },
	{ p = "Erh\195\182ht die Angriffskraft in Katzengestalt, B\195\164rengestalt, Terrorb\195\164rengestalt oder Mondkingestalt um (%d+)%.", s = "APFERAL" },

	{ p = "Erh\195\182ht Tempowertung um (%d+)%.", s = "HASTE" },
	{ p = "Erh\195\182ht Eure Waffenkundewertung um (%d+)%.", s = "EXPERTISE" }, -- New 2.3 Stat (Expertise => Waffenkundewertung)
	{ p = "Eure Angriffe ignorieren (%d+) R\195\188stung Eures Gegners%.", s = "ARMORPENETRATION" },

	-- Equip (Magic)
	{ p = "Erh\195\182ht kritische Zaubertrefferwertung um (%d+)%.", s = "SPELLCRIT" },
	{ p = "Erh\195\182ht Eure kritische Zaubertrefferwertung um (%d+)%.", s = "SPELLCRIT" },
	{ p = "Erh\195\182ht Zaubertrefferwertung um (%d+)%.", s = "SPELLHIT" },
	{ p = "Erh\195\182ht Eure Zaubertrefferwertung um (%d+)%.", s = "SPELLHIT" },

	{ p = "Erh\195\182ht Zaubertempowertung um (%d+)%.", s = "SPELLHASTE" },
	{ p = "Erh\195\182ht Eure Zauberdurchschlagskraft um (%d+)%.", s = "SPELLPENETRATION" },

	{ p = "Erh\195\182ht durch Zauber und Effekte verursachte Heilung um bis zu (%d+)%.", s = "HEAL" }, -- Az: Is this really obsolete in 2.3?
	{ p = "Erh\195\182ht durch s\195\164mtliche Zauber und magische Effekte verursachte Heilung um bis zu (%d+) und den verursachten Schaden um bis zu (%d+)%.", s = { "HEAL", "SPELLDMG" } }, -- New 2.3 Heal/SpellDmg
	{ p = "Erh\195\182ht durch Zauber und magische Effekte verursachten Schaden und Heilung um bis zu (%d+)%.", s = { "SPELLDMG", "HEAL" } },
	{ p = "Erh\195\182ht durch Zauber und magische Effekte verursachten Schaden und Heilung leicht%.", s = { "SPELLDMG", "HEAL" }, v = 6 }, -- Bronze Band of Force => Bronzeband der Kraft
	
	{ p = "Arkanzauber und Arkaneffekte zugef\195\188gten Schaden um bis zu (%d+)%.", s = "ARCANEDMG" },
	{ p = "Feuerzauber und Feuereffekte zugef\195\188gten Schaden um bis zu (%d+)%.", s = "FIREDMG" },
	{ p = "Naturzauber und Natureffekte zugef\195\188gten Schaden um bis zu (%d+)%.", s = "NATUREDMG" },
	{ p = "Frostzauber und Frosteffekte zugef\195\188gten Schaden um bis zu (%d+)%.", s = "FROSTDMG" },
	{ p = "Schattenzauber und Schatteneffekte zugef\195\188gten Schaden um bis zu (%d+)%.", s = "SHADOWDMG" },
	{ p = "Heiligzauber und Heiligeffekte zugef\195\188gten Schaden um bis zu (%d+)%.", s = "HOLYDMG" },
	
	--  Health & Mana Per 5 Sec  -- (xonyx: Different than the Englisch version, though should cover the most)
	{ p = "Stellt alle 5 Sek%. %+(%d+) Mana wieder her%.", s = "MP5" },
	{ p = "%+(%d+) Mana alle 5 Sekunden", s = "MP5" },
	{ p = "(%d+) Mana alle 5 Sek", s = "MP5" },
	{ p = "(%d+) Mana alle 5 Sekunden", s = "MP5" },
	{ p = "(%d+) Mana per 5 Sek%.", s = "MP5" }, -- Covers equip bonus as well as socket bonus
	{ p = "Mana Regeneration (%d+) alle 5 Sek%.", s = "MP5" },
	{ p = "alle 5 Sek%. (%d+) Mana", s = "MP5" },
	{ p = "Alle 5 Sek%. (%d+) Mana", s = "MP5" },
	{ p = "%+(%d+) Manaregeneration", s = "MP5" },

	{ p = "+(%d) Gesundheit alle 5 Sek%.", s = "HP5" },
	{ p = "Stellt alle 5 Sek%. (%d+) Gesundheit wieder her%.", s = "HP5" },

	-- Enchants / Gems / Socket Bonuses / Mixed / Misc
	{ p = "^%+(%d+) GP$", s = "HP" },
	{ p = "^%+(%d+) Gesundheit$", s = "HP" },
	{ p = "^%+(%d+) Mana$", s = "MP" },

	{ p = "^Vitalit\195\164t$", s = { "MP5", "HP5" }, v = 4 },
	{ p = "^Unb\195\164ndigkeit$", s = "AP", v = 70 }, -- Old DE: "^Wildheit$"
	{ p = "^Sicherer Stand$", s = "HIT", v = 10 },
	{ p = "^Seelenfrost$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },
	{ p = "^Sonnenfeuer$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },

	{ p = "%+(%d+) Alle Werte", s = { "STR", "AGI", "STA", "INT", "SPI" } },

	{ p = "%+(%d+) Arkanzauber", s = "ARCANEDMG" },
	{ p = "%+(%d+) Feuerschaden", s = "FIREDMG" },
	{ p = "%+(%d+) Naturschaden", s = "NATUREDMG" },
	{ p = "%+(%d+) Frostschaden", s = "FROSTDMG" },
	{ p = "%+(%d+) Schattenschaden", s = "SHADOWDMG" },
	{ p = "%+(%d+) Heiligschaden", s = "HOLYDMG" },

	{ p = "%+(%d+) Verteidigung", s = "DEFENSE" }, -- Exclude "Rating" from this pattern due to Paladin ZG Enchant
	{ p = "%+(%d+) Ausweichwertung", s = "DODGE" },
	{ p = "%+(%d+) Parierwertung", s = "PARRY" },
	{ p = "%+(%d+) Blockwertung", s = "BLOCK" },
	{ p = "%+(%d+) Blockwert$", s = "BLOCKVALUE" }, -- workaround by g3gg0
	{ p = "%+(%d+) Blockwert ", s = "BLOCKVALUE" }, -- workaround by g3gg0

	{ p = "%+(%d+) Angriffskraft", s = "AP" },
	{ p = "%+(%d+) Distanzangriffskraft", s = "RAP" },
	{ p = "%+(%d+) Trefferwertung", s = "HIT" },
	{ p = "%+(%d+) Crit Rating", s = "CRIT" },
	{ p = "%+(%d+) Kritische Trefferwertung", s = "CRIT" },
	{ p = "%+(%d+) Abh\195\164rtung", s = "RESILIENCE" },
	{ p = "%+(%d+) Tempowertung", s = "HASTE" },
	{ p = "%+(%d+) Waffenkundewertung", s = "EXPERTISE" },

	{ p = "%+(%d+) Heilung", s = "HEAL" },
	{ p = "%+(%d+) Heilzauber", s = "HEAL" },
	{ p = "%+(%d+) Heilung und Zauberschaden", s = "SPELLDMG" }, -- Warlock ZG Enchant (Healing will be cought by the other pattern)
	{ p = "%+(%d+) Schadenszauber", s = "SPELLDMG" },
	{ p = "%+(%d+) Zauberkraft", s = { "SPELLDMG", "HEAL" } },
	{ p = "%+(%d+) Zauberschaden", s = { "SPELLDMG", "HEAL" } },
	{ p = "%+(%d+) Zaubertrefferwertung", s = "SPELLHIT" }, -- Exclude "Rating" from this pattern due to Mage ZG Enchant
	{ p = "%+(%d+) Kritische Zaubertrefferwertung", s = "SPELLCRIT" },
	{ p = "%+(%d+) Spell Critical Rating", s = "SPELLCRIT" },
	{ p = "%+(%d+) Spell Critical Strike Rating", s = "SPELLCRIT" },
	{ p = "%+(%d+) Zauberdurchschlagskraft", s = "SPELLPENETRATION" },
	{ p = "%+(%d+) Schaden und Heilzauber", s = { "SPELLDMG", "HEAL" } },

	{ p = "%+(%d+) Waffenschaden", s = "WPNDMG" },
	{ p = "^Zielfernrohr %(%+(%d+) Schaden%)$", s = "RANGEDDMG" }, -- translated by g3gg0

	-- Dämonenblut (Demons's Blood) 
	{ p = "Verbessert Verteidigungswertung um 5, Schattenwiderstand um 10 sowie Eure normale Gesundheitsregeneration um 3%.", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },
	
	-- Void Star Talisman (Warlock T5 Class Trinket)
	{ p = "Erh\195\182ht die Widerstände Eures Begleiters um 130 und Euren Zauberschaden um bis zu 48%.", s = "SPELLDMG", v = 48 },

	-- Temp Enchants (Disabled as they are not part of "gear" stats)
	--{ p = "Schwaches Mana\195\182l", s = "MP5", v = 4 },
	--{ p = "Geringes Mana\195\182l", s = "MP5", v = 8 },
	--{ p = "\195\156berragendes Mana\195\182l", s = "MP5", v = 14 },
	--{ p = "Hervorragendes Mana\195\182l", s = { "MP5", "HEAL" }, v = { 12, 25 } },

	--{ p = "Schwaches Zauber\195\182l", s = "SPELLDMG", v = 8 },
	--{ p = "Geringes Zauber\195\182l", s = "SPELLDMG", v = 16 },
	--{ p = "Zauber\195\182l", v = 24 },
	--{ p = "\195\156überragendes Zauber\195\182l", s = "SPELLDMG", v = 42 },
	--{ p = "Hervorragendes Zauber\195\182l", s = { "SPELLDMG", "SPELLCRIT" }, v = { 36, 14 } },

	-- Future Patterns (Disabled)
	--{ p = "When struck in combat inflicts (%d+) .+ damage to the attacker.", s = "DMGSHIELD" },

};

--------------------------------------------------------------------------------------------------------
--                                        Stat Order & Naming                                         --
--------------------------------------------------------------------------------------------------------

Examiner.StatEntryOrder = {
	{ name = "Grundwerte", stats = {"STR", "AGI", "STA", "INT", "SPI", "ARMOR"} },
	{ name = "Gesundheit & Mana", stats = {"HP", "MP", "HP5", "MP5"} },
	{ name = "Nah- und Distanzkampf", stats = {"AP", "RAP", "APFERAL", "CRIT", "HIT", "HASTE", "WPNDMG", "RANGEDDMG", "ARMORPENETRATION", "EXPERTISE"} },
	{ name = "Zauber", stats = {"HEAL", "SPELLDMG", "ARCANEDMG", "FIREDMG", "NATUREDMG", "FROSTDMG", "SHADOWDMG", "HOLYDMG", "SPELLCRIT", "SPELLHIT", "SPELLHASTE", "SPELLPENETRATION"} },
	{ name = "Verteidigung", stats = {"DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCKVALUE", "RESILIENCE"} },
};

ExScanner.StatNames = {
	["STR"] = "St\195\164rke",
	["AGI"] = "Beweglichkeit",
	["STA"] = "Ausdauer",
	["INT"] = "Intelligenz",
	["SPI"] = "Willenskraft",

	["ARMOR"] = "R\195\188stung",

	["ARCANERESIST"] = "Arkanwiderstand",
	["FIRERESIST"] = "Feuerwiderstand",
	["NATURERESIST"] = "Naturwiderstand",
	["FROSTRESIST"] = "Frostwiderstand",
	["SHADOWRESIST"] = "Schattenwiderstand",

	["DODGE"] = "Ausweichwertung",
	["PARRY"] = "Parierwertung",
	["DEFENSE"] = "Verteidigungswertung",
	["BLOCK"] = "Blockwertung",
	["BLOCKVALUE"] = "Blockwert des Schildes",
	["RESILIENCE"] = "Abh\195\164rtungswertung",

	["AP"] = "Angriffskraft",
	["RAP"] = "Distanzangriffskraft",
	["APFERAL"] = "Angriffskraft (Feral)",
	["CRIT"] = "Kritische Trefferwertung",
	["HIT"] = "Trefferwertung",
	["HASTE"] = "Tempowertung ",
	["WPNDMG"] = "Waffenschaden",
	["RANGEDDMG"] = "Distanzschaden",
	["ARMORPENETRATION"] = "Ignorierte R\195\188stung",
	["EXPERTISE"] = "Waffenkundewertung",

	["SPELLCRIT"] = "Krit. Zaubertrefferwertung",
	["SPELLHIT"] = "Zaubertrefferwertung",
	["SPELLHASTE"] = "Zaubertempowertung",
	["SPELLPENETRATION"] = "Zauberdurchschlagskraft",

	["HEAL"] = "Heilung",
	["SPELLDMG"] = "Zauberschaden",
	["ARCANEDMG"] = "Zauberschaden (Arkan)",
	["FIREDMG"] = "Zauberschaden (Feuer)",
	["NATUREDMG"] = "Zauberschaden (Natur)",
	["FROSTDMG"] = "Zauberschaden (Frost)",
	["SHADOWDMG"] = "Zauberschaden (Schatten)",
	["HOLYDMG"] = "Zauberschaden (Heilig)",

	["HP"] = "Gesundheitspunkte",
	["MP"] = "Manapunkte",

	["HP5"] = "Gesundheitsreg. alle 5 Sek",
	["MP5"] = "Manaregeneration alle 5 Sek",
};
end