local _G = getfenv(0);

ExScanner = {
	Tip = CreateFrame("GameTooltip","ExScannerTip",nil,"GameTooltipTemplate"),

	ItemLinkPattern = "^.+|H(item:[^|]+)|h%[.+$",
	SetNamePattern = "^(.+) %((%d)/(%d)%)$",

	Slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot",
		--"AmmoSlot", -- Only available for 'player'
	},

	StatRatingBaseTable = {
		["EXPERTISE"] = 2.5,
		["HASTE"] = 10,
		["SPELLHASTE"] = 10,
		["HIT"] = 10,
		["CRIT"] = 14,
		["SPELLHIT"] = 8,
		["SPELLCRIT"] = 14,
		["DEFENSE"] = 1.5,
		["DODGE"] = 12,
		["PARRY"] = 15,
		["BLOCK"] = 5,
		["RESILIENCE"] = 25,
	},
};

ExScanner.Tip:SetOwner(UIParent,"ANCHOR_NONE");

--------------------------------------------------------------------------------------------------------
--          Scan all items and set bonuses on given 'unit' (Make sure the tables are reset)           --
--------------------------------------------------------------------------------------------------------
function ExScanner:ScanUnitItems(unit,statTable,setTable)
	if (not unit) or (not UnitExists(unit)) then
		return;
	end
	-- Check all item slots
	local lastSetName, lastBonusCount;
	local setName, setCount, setMax;
	for _, slotName in ipairs(self.Slots) do
		-- Set New Item Tip
		self.Tip:ClearLines();
		self.Tip:SetInventoryItem(unit,GetInventorySlotInfo(slotName));
		lastSetName = nil;
		lastBonusCount = 1;
		-- Check Lines
		for i = 2, self.Tip:NumLines() do
			if (self:DoLineNeedScan(_G["ExScannerTipTextLeft"..i],true)) then
				-- Reset 'setMax' as we use that to check if the Line was a SetNamePattern (WTB continue statement in LUA)
				setMax = nil;
				-- Set Header (Only run this if we haven't found a set on this item yet)
				if (not lastSetName) then
					setName, setCount, setMax = self.text:match(self.SetNamePattern);
					if (setMax) and (not setTable[setName]) then
						setTable[setName] = { count = tonumber(setCount), max = tonumber(setMax) };
						lastSetName = setName;
						--continue :(
					end
				end
				-- Check Line for Patterns if this Line was not a SetNamePattern
				if (not setMax) then
					if (self.text:find(self.SetBonusTokenActive)) then
						-- Skip set bonues we have already included
						if (lastSetName) and (not setTable[lastSetName].scanned) then
							self:ScanLineForPatterns(self.text,statTable);
							setTable[lastSetName]["setBonus"..lastBonusCount] = self.text;
							lastBonusCount = (lastBonusCount + 1);
						end
					else
						self:ScanLineForPatterns(self.text,statTable);
					end
				end
			end
		end
		-- Mark this set as scanned, if any found
		if (lastSetName) then
			setTable[lastSetName].scanned = 1;
		end
	end
end
--------------------------------------------------------------------------------------------------------
--        Scans a single item given by 'itemLink', stats are added to the 'statTable' variable        --
--------------------------------------------------------------------------------------------------------
function ExScanner:ScanItemLink(itemLink,statTable)
	if (itemLink) then
		-- Set Link
		self.Tip:ClearLines();
		self.Tip:SetHyperlink(itemLink);
		-- Check Lines
		for i = 2, self.Tip:NumLines() do
			if (self:DoLineNeedScan(_G["ExScannerTipTextLeft"..i],false)) then
				self:ScanLineForPatterns(self.text,statTable);
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------
--                         Checks if a Line Needs to be Scanned for Patterns                          --
--------------------------------------------------------------------------------------------------------
function ExScanner:DoLineNeedScan(tipLine,scanSetBonuses)
	-- Init Line
	self.text = tipLine:GetText():gsub("|c%x%x%x%x%x%x%x%x","");
	self.r, self.g, self.b = tipLine:GetTextColor();
	self.r, self.g, self.b = ceil(self.r*255), ceil(self.g*255), ceil(self.b*255);
	-- Always *Skip* Gray Lines
	if (self.r == 128 and self.g == 128 and self.b == 128) then
		return;
	-- Active Set Bonuses (Must be checked before green color check)
	elseif (not scanSetBonuses and self.text:find(self.SetBonusTokenActive)) then
		return;
	-- Skip "Use:" lines, they are not a permanent stat, so don't include them
	elseif (self.text:find(self.ItemUseToken)) then
		return;
	-- Always *Scan* Green Lines
	elseif (self.r == 0 and self.g == 255 and self.b == 0) then
		return 1;
	-- Should Match: Normal +Stat, Base Item Armor, Block Value on Shields
	elseif (self.text:find("^%+?%d+ [^%d]")) then
		return 1;
	-- Az: WORKAROUND: Infused Amethyst *le sigh*
	elseif (self.text:find("^.+%+%d+")) then
		return 1;
	-- Set Names (Needed to Check Sets)
	elseif (scanSetBonuses and self.text:find(self.SetNamePattern)) then
		return 1;
	end
	return;
end
--------------------------------------------------------------------------------------------------------
--                                 Checks a Single Line for Patterns                                  --
--------------------------------------------------------------------------------------------------------
function ExScanner:ScanLineForPatterns(text,statTable)
	-- Mark "heal pattern found" nil
	self.foundHealPattern = nil;
	-- Loop Patterns
	for _, pattern in ipairs(self.Patterns) do
		self.findPos, _, self.findValue, self.findValue2 = text:find(pattern.p);
		if (self.findPos) and (self.findValue or pattern.v) then
			if (type(pattern.s) == "string") then
				if (pattern.s == "HEAL") then
					self.foundHealPattern = 1;
				end
				statTable[pattern.s] = (statTable[pattern.s] or 0) + (self.findValue or pattern.v);
			elseif (type(pattern.s) == "table") then
				for statIndex, statName in ipairs(pattern.s) do
					if (type(pattern.v) == "table") then
						statTable[statName] = (statTable[statName] or 0) + (pattern.v[statIndex]);
					-- Az: this is a bit messy, needs to make this part dynamic and support as many extra values as possible
					elseif (statIndex == 2) and (self.findValue2) then
						statTable[statName] = (statTable[statName] or 0) + (self.findValue2);
					-- Crappy pattern workaround with the new "+Spell Damage" meaning on "+Healing" Enchants and Gems
					elseif (statName ~= "HEAL" or not self.foundHealPattern) then
						statTable[statName] = (statTable[statName] or 0) + (self.findValue or pattern.v);
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------
--                                      Convert Rating to Percent                                     --
--------------------------------------------------------------------------------------------------------
function ExScanner:GetRatingInPercent(stat,rating,level)
	-- Check Base Rating
	if (not self.StatRatingBaseTable[stat] or not rating or not level) then
		return;
	end
	-- Calc Depending on Level
	if (level < 60) then
		return rating / (self.StatRatingBaseTable[stat] * ((level >= 10 and level or 10) - 8) / 52);
	elseif (level < 70) then
		return rating / (self.StatRatingBaseTable[stat] * 82 / (262 - 3 * level));
	else
		return rating / (self.StatRatingBaseTable[stat] * (level + 12) / 52);
	end
end