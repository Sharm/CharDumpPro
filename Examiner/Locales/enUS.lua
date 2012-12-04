--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

BINDING_HEADER_EXAMINER = "Examiner";
BINDING_NAME_EXAMINER_OPEN = "Open Examiner";
BINDING_NAME_EXAMINER_TARGET = "Inspect Target";
BINDING_NAME_EXAMINER_MOUSEOVER = "Inspect Mouseover";

Examiner.Classification = {
	["worldboss"] = BOSS,
	["rareelite"] = "RareElite",
	["elite"] = ELITE,
	["rare"] = "Rare",
};

ExScanner.SetBonusTokenActive = "^Set: ";
ExScanner.ItemUseToken = "^Use: ";

--------------------------------------------------------------------------------------------------------
--                                           Stat Patterns                                            --
--------------------------------------------------------------------------------------------------------

ExScanner.Patterns = {
	--  Base Stats  --
	{ p = "%+(%d+) Strength", s = "STR" },
	{ p = "%+(%d+) Agility", s = "AGI" },
	{ p = "%+(%d+) Stamina", s = "STA" },
	{ p = "Stamina %+(%d+)", s = "STA" }, -- WORKAROUND: Infused Amethyst (31116)
	{ p = "%+(%d+) Intellect", s = "INT" },
	{ p = "%+(%d+) Spirit", s = "SPI" },
	{ p = "(%d+) Armor", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits

	--  Resistances (Exclude the Resist-"ance" then it picks up armor patches as well)  --
	{ p = "%+(%d+) Arcane Resist", s = "ARCANERESIST" },
	{ p = "%+(%d+) Fire Resist", s = "FIRERESIST" },
	{ p = "%+(%d+) Nature Resist", s = "NATURERESIST" },
	{ p = "%+(%d+) Frost Resist", s = "FROSTRESIST" },
	{ p = "%+(%d+) Shadow Resist", s = "SHADOWRESIST" },
	{ p = "%+(%d+) All Resistances", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },
	{ p = "%+(%d+) Resist All", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, -- Void Sphere

	--  Equip: Other  --
	{ p = "Improves your resilience rating by (%d+)%.", s = "RESILIENCE" },

	{ p = "Increases defense rating by (%d+)%.", s = "DEFENSE" },
	{ p = "Increases your dodge rating by (%d+)%.", s = "DODGE" },
	{ p = "Increases your parry rating by (%d+)%.", s = "PARRY" },
	{ p = "Increases your s?h?i?e?l?d? ?block rating by (%d+)%.", s = "BLOCK" }, -- Should catch both new and old style

	{ p = "Increases the block value of your shield by (%d+)%.", s = "BLOCKVALUE" },
	{ p = "^(%d+) Block$", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield

	--  Equip: Melee & Ranged  --
	{ p = "Increases your critical strike rating by (%d+)%.", s = "CRIT" },
	{ p = "Improves critical strike rating by (%d+)%.", s = "CRIT" },
	{ p = "Increases your hit rating by (%d+)%.", s = "HIT" },
	{ p = "Improves hit rating by (%d+)%.", s = "HIT" },

	{ p = "Increases attack power by (%d+)%.", s = "AP" },
	{ p = "Increases ranged attack power by (%d+)%.", s = "RAP" },
	{ p = "Increases attack power by (%d+) in Cat, Bear, Dire Bear, and Moonkin forms only%.", s = "APFERAL" },

	{ p = "Improves haste rating by (%d+)%.", s = "HASTE" },
	{ p = "Increases your expertise rating by (%d+)%.", s = "EXPERTISE" }, -- New 2.3 Stat
	{ p = "Your attacks ignore (%d+) of your opponent's armor%.", s = "ARMORPENETRATION" },

	--  Equip: Magic (The school patterns has no "Increases" because items like 30642)  --
	{ p = "Improves spell critical strike rating by (%d+)%.", s = "SPELLCRIT" },
	{ p = "Increases your spell critical strike rating by (%d+)%.", s = "SPELLCRIT" },
	{ p = "Improves spell hit rating by (%d+)%.", s = "SPELLHIT" },
	{ p = "Increases your spell hit rating by (%d+)%.", s = "SPELLHIT" },

	{ p = "Improves spell haste rating by (%d+)%.", s = "SPELLHASTE" },
	{ p = "Increases your spell penetration by (%d+)%.", s = "SPELLPENETRATION" },

	{ p = "Increases healing done by up to (%d+) and damage done by up to (%d+) for all magical spells and effects.", s = { "HEAL", "SPELLDMG" } }, -- New 2.3 Heal/SpellDmg
	{ p = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", s = { "SPELLDMG", "HEAL" } },
	{ p = "Increases damage and healing done by magical spells and effects slightly%.", s = { "SPELLDMG", "HEAL" }, v = 6 }, -- Bronze Band of Force

	{ p = "damage done by Arcane spells and effects by up to (%d+)%.", s = "ARCANEDMG" },
	{ p = "damage done by Fire spells and effects by up to (%d+)%.", s = "FIREDMG" },
	{ p = "damage done by Nature spells and effects by up to (%d+)%.", s = "NATUREDMG" },
	{ p = "damage done by Frost spells and effects by up to (%d+)%.", s = "FROSTDMG" },
	{ p = "damage done by Shadow spells and effects by up to (%d+)%.", s = "SHADOWDMG" },
	{ p = "damage done by Holy spells and effects by up to (%d+)%.", s = "HOLYDMG" },

	--  Health & Mana Per 5 Sec  --
	{ p = "(%d+) health every 5 sec%.", s = "HP5" },
	{ p = "(%d+) [Hh]ealth per 5 sec%.", s = "HP5" },

	{ p = "%+(%d+) Mana Regen", s = "MP5" }, -- Scryer Shoulder Enchant, Priest ZG Enchant
	{ p = "%+(%d+) Mana restored per 5 seconds", s = "MP5" }, -- Magister's Armor Kit

	{ p = "%+(%d+) Mana per 5 Seconds", s = "MP5" }, -- Gem: Royal Shadow Draenite
	{ p = "Mana Regen (%d+) per 5 sec%.", s = "MP5" }, -- Bracer Enchant

	{ p = "(%d+) [Mm]ana [Pp]er 5 [Ss]ec%.$", s = "MP5" }, -- Combined Pattern: Covers [Equip Bonuses] [Socket Bonuses] --- Added "$" to avoid confusing on item 33502
	{ p = "%+(%d+) [Mm]ana every 5 [Ss]ec", s = "MP5" }, -- Combined Pattern: Covers [Chest Enchant] [Gem: Dazzling Deep Peridot] [Various Gems]

	--  Enchants / Gems / Socket Bonuses / Mixed / Misc  --
	{ p = "^%+(%d+) HP$", s = "HP" },
	{ p = "^%+(%d+) Health$", s = "HP" },
	{ p = "^%+(%d+) Mana$", s = "MP" },

	{ p = "^Vitality$", s = { "MP5", "HP5" }, v = 4 },
	{ p = "^Savagery$", s = "AP", v = 70 },
	{ p = "^Surefooted$", s = "HIT", v = 10 },
	{ p = "^Soulfrost$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },
	{ p = "^Sunfire$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },

	{ p = "%+(%d+) All Stats", s = { "STR", "AGI", "STA", "INT", "SPI" } }, -- Chest + Bracer Enchant

	{ p = "%+(%d+) Arcane S?p?e?l?l? ?Damage", s = "ARCANEDMG" },
	{ p = "%+(%d+) Fire S?p?e?l?l? ?Damage", s = "FIREDMG" },
	{ p = "%+(%d+) Nature S?p?e?l?l? ?Damage", s = "NATUREDMG" },
	{ p = "%+(%d+) Frost S?p?e?l?l? ?Damage", s = "FROSTDMG" },
	{ p = "%+(%d+) Shadow S?p?e?l?l? ?Damage", s = "SHADOWDMG" },
	{ p = "%+(%d+) Holy S?p?e?l?l? ?Damage", s = "HOLYDMG" },

	{ p = "%+(%d+) Defense", s = "DEFENSE" }, -- Exclude "Rating" from this pattern due to Paladin ZG Enchant
	{ p = "%+(%d+) Dodge Rating", s = "DODGE" },
	{ p = "%+(%d+) Parry Rating", s = "PARRY" },
	{ p = "%+(%d+) S?h?i?e?l?d? ?Block Rating", s = "BLOCK" }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]

	{ p = "%+(%d+) Block Value", s = "BLOCKVALUE" },

	{ p = "%+(%d+) Attack Power", s = "AP" },
	{ p = "%+(%d+) Ranged Attack Power", s = "RAP" },
	{ p = "%+(%d+) Hit Rating", s = "HIT" },
	{ p = "%+(%d+) Crit Rating", s = "CRIT" },
	{ p = "%+(%d+) Critical S?t?r?i?k?e? ?Rating", s = "CRIT" }, -- Matches two versions, with/without "Strike". No "Strike" on "Unstable Citrine".
	{ p = "%+(%d+) Resilience", s = "RESILIENCE" },
	{ p = "%+(%d+) Haste Rating", s = "HASTE" },
	{ p = "%+(%d+) Expertise Rating", s = "EXPERTISE" },

	{ p = "%+(%d+) Healing", s = "HEAL" }, -- Has to appear before patterns with a SPELLDMG entry, due to the workaround
	{ p = "%+(%d+) Healing and Spell Damage", s = "SPELLDMG" }, -- Warlock ZG Enchant (Healing will be cought by the pattern above)
	{ p = "Spell Damage %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- WORKAROUND: Infused Amethyst (31116)
	{ p = "%+(%d+) Spell Power", s = { "SPELLDMG", "HEAL" } },
	{ p = "%+(%d+) Damage Spells", s = "SPELLDMG" }, -- New 2.3: Damage part of the previously "+Healing" enchants
	{ p = "%+(%d+) Spell Damage", s = { "SPELLDMG", "HEAL" } },
	{ p = "%+(%d+) Spell Hit", s = "SPELLHIT" }, -- Exclude "Rating" from this pattern to catch Mage ZG Enchant
	{ p = "%+(%d+) Spell Crit Rating", s = "SPELLCRIT" },
	{ p = "%+(%d+) Spell Critical S?t?r?i?k?e? ?Rating", s = "SPELLCRIT" }, -- Matches two versions, with/without "Strike"
	{ p = "%+(%d+) Spell Penetration", s = "SPELLPENETRATION" },
	{ p = "%+(%d+) Damage and Healing Spells", s = { "SPELLDMG", "HEAL" } },

	{ p = "%+(%d+)  ?Weapon Damage", s = "WPNDMG" }, -- Added optional space as I found a "+1  Weapon Damage" enchant on someone
	{ p = "^Scope %(%+(%d+) Damage%)$", s = "RANGEDDMG" },

	-- Demon's Blood
	{ p = "Increases defense rating by 5, Shadow resistance by 10 and your normal health regeneration by 3%.", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },

	-- Void Star Talisman (Warlock T5 Class Trinket)
	{ p = "Increases your pet's resistances by 130 and increases your spell damage by up to 48%.", s = "SPELLDMG", v = 48 },

	-- Temp Enchants (Disabled as they are not part of "gear" stats)
	--{ p = "Minor Mana Oil", s = "MP5", v = 4 },
	--{ p = "Lesser Mana Oil", s = "MP5", v = 8 },
	--{ p = "Superior Mana Oil", s = "MP5", v = 14 },
	--{ p = "Brilliant Mana Oil", s = { "MP5", "HEAL" }, v = { 12, 25 } },

	--{ p = "Minor Wizard Oil", s = "SPELLDMG", v = 8 },
	--{ p = "Lesser Wizard Oil", s = "SPELLDMG", v = 16 },
	--{ p = "Wizard Oil", s = "SPELLDMG", v = 24 },
	--{ p = "Superior Wizard Oil", s = "SPELLDMG", v = 42 },
	--{ p = "Brilliant Wizard Oil", s = { "SPELLDMG", "SPELLCRIT" }, v = { 36, 14 } },

	-- Future Patterns (Disabled)
	--{ p = "When struck in combat inflicts (%d+) .+ damage to the attacker.", s = "DMGSHIELD" },
};

--------------------------------------------------------------------------------------------------------
--                                        Stat Order & Naming                                         --
--------------------------------------------------------------------------------------------------------

Examiner.StatEntryOrder = {
	{ name = "Basic Stats", stats = {"STR", "AGI", "STA", "INT", "SPI", "ARMOR"} },
	{ name = "Health & Mana", stats = {"HP", "MP", "HP5", "MP5"} },
	{ name = "Melee & Ranged Stats", stats = {"AP", "RAP", "APFERAL", "CRIT", "HIT", "HASTE", "WPNDMG", "RANGEDDMG", "ARMORPENETRATION", "EXPERTISE"} },
	{ name = "Spell Stats", stats = {"HEAL", "SPELLDMG", "ARCANEDMG", "FIREDMG", "NATUREDMG", "FROSTDMG", "SHADOWDMG", "HOLYDMG", "SPELLCRIT", "SPELLHIT", "SPELLHASTE", "SPELLPENETRATION"} },
	{ name = "Defensive Stats", stats = {"DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCKVALUE", "RESILIENCE"} },
};

ExScanner.StatNames = {
	["STR"] = "Strength",
	["AGI"] = "Agility",
	["STA"] = "Stamina",
	["INT"] = "Intellect",
	["SPI"] = "Spirit",

	["ARMOR"] = "Armor",

	["ARCANERESIST"] = "Arcane Resistance",
	["FIRERESIST"] = "Fire Resistance",
	["NATURERESIST"] = "Nature Resistance",
	["FROSTRESIST"] = "Frost Resistance",
	["SHADOWRESIST"] = "Shadow Resistance",

	["DODGE"] = "Dodge Rating",
	["PARRY"] = "Parry Rating",
	["DEFENSE"] = "Defense Rating",
	["BLOCK"] = "Block Rating",
	["BLOCKVALUE"] = "Block Value",
	["RESILIENCE"] = "Resilience Rating",

	["AP"] = "Attack Power",
	["RAP"] = "Ranged Attack Power",
	["APFERAL"] = "Attack Power (Feral)",
	["CRIT"] = "Crit Rating",
	["HIT"] = "Hit Rating",
	["HASTE"] = "Haste Rating",
	["WPNDMG"] = "Weapon Damage",
	["RANGEDDMG"] = "Ranged Damage",
	["ARMORPENETRATION"] = "Armor Penetration",
	["EXPERTISE"] = "Expertise Rating",

	["SPELLCRIT"] = "Spell Crit Rating",
	["SPELLHIT"] = "Spell Hit Rating",
	["SPELLHASTE"] = "Spell Haste Rating",
	["SPELLPENETRATION"] = "Spell Penetration",

	["HEAL"] = "Healing",
	["SPELLDMG"] = "Spell Damage",
	["ARCANEDMG"] = "Spell Damage (Arcane)",
	["FIREDMG"] = "Spell Damage (Fire)",
	["NATUREDMG"] = "Spell Damage (Nature)",
	["FROSTDMG"] = "Spell Damage (Frost)",
	["SHADOWDMG"] = "Spell Damage (Shadow)",
	["HOLYDMG"] = "Spell Damage (Holy)",

	["HP"] = "Health Points",
	["MP"] = "Mana Points",

	["HP5"] = "Health Regen Per 5 Sec",
	["MP5"] = "Mana Regen Per 5 Sec",
};