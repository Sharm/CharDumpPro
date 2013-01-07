local _G = getfenv(0);

-- Saved Data Tables
local cfg, cache;
Examiner_Config = { activePage = 3 }; -- Set activePage here as we do not want to revert to default value as this variable can be nil, but still want to be non-nil the first time Examiner is run.
Examiner_Cache = {};

-- Working Vars
local u = {};
local ExStats = {};
local ExSets = {};
local ExCacheList = {};
local ExStatList = {};
local ExCompare;

-- Misc Constants
local EX_MagicSchools = { "ARCANE", "FIRE", "NATURE", "FROST", "SHADOW", "HOLY" };

local EX_Frames = { "Config", "Cache", "Stat", "PVP" };

local EX_Checks = {
	{ var = "EnableCache", label = "Enable Caching of Players", tip = "If enabled, everytime you inspect a player, their items will be cached so you can look them up later." },
	{ var = "CachePvP", label = "Cache Honor and Arena Details", tip = "In addition to normal item caching, this option will cache honor and arena team details as well when enabled. When normal caching is disabled, this option has no effect." },
	{ var = "CombineAdditiveStats", label = "Combine Additive Stats", tip = "This option makes sure that certain stats which stacks with others, gets combined at the stats page. This include Spell Damage to specific spell schools, AP to Feral AP and AP to Ranged AP." },
	{ var = "RatingsInPercent", label = "Show Ratings in Percentage", tip = "With this option enabled, ratings will be displayed in percent relative to the inspected person's level." },
	{ var = "ActAsUIFrame", label = "Act as UI Frame", tip = "Enabled, Examiner will act like a normal UI frame, like Talents, Quest Log and the Mailbox frame.\nIf you want to be able to move Examiner around, disable this option." },
	{ var = "AutoInspect", label = "Auto Inspect on Target Change", tip = "With this option turned on, Examiner will automatically inspect your target when you change it." },
	{ var = "AcceptAddonMsg", label = "Accept AddOn Messages", tip = "When this option is enabled, Examiner can accept inspection data from other people with Examiner." },
	{ var = "ScanUnknownItems", label = "Scan Unknown Cached Items", tip = "When loading from the cache, Examiner will normally ignore items that was not found in the local item cache, to avoid getting you DC'd. You can override that behavior with this option, at the risk of DC's." },
};

local EX_DefaultConfig = {
	EnableCache = true,
	CachePvP = false,
	CombineAdditiveStats = true,
	RatingsInPercent = false,
	ActAsUIFrame = true,
	AutoInspect = true,
	AcceptAddonMsg = false,
	ScanUnknownItems = false,
	cacheSort = "class",
	cacheFilter = "",
	scale = 1,
	showBackground = true,
};

-- Texture Mapping
local EX_Backgrounds = {
	"DruidBalance",
	"DruidFeralCombat",
	"DruidRestoration",
	"HunterBeastMastery",
	"HunterMarksmanship",
	"HunterSurvival",
	"MageArcane",
	"MageFire",
	"MageFrost",
	"PaladinCombat",
	"PaladinHoly",
	"PaladinProtection",
	"PriestDiscipline",
	"PriestHoly",
	"PriestShadow",
	"RogueAssassination",
	"RogueCombat",
	"RogueSubtlety",
	"ShamanElementalCombat",
	"ShamanEnhancement",
	"ShamanRestoration",
	"WarlockCurses",
	"WarlockDestruction",
	"WarlockSummoning",
	"WarriorArms",
	"WarriorFury",
	"WarriorProtection",
};

-- RaceCoords. For females, add 0.5 to "top" and "bottom".
-- Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races
local EX_RaceCoord = {
	["Human"]		= { left = 0/8, right = 1/8, top = 0/4, bottom = 1/4 },
	["Dwarf"]		= { left = 1/8, right = 2/8, top = 0/4, bottom = 1/4 },
	["Gnome"]		= { left = 2/8, right = 3/8, top = 0/4, bottom = 1/4 },
	["NightElf"]	= { left = 3/8, right = 4/8, top = 0/4, bottom = 1/4 },
	["Draenei"]		= { left = 4/8, right = 5/8, top = 0/4, bottom = 1/4 },
	["Tauren"]		= { left = 0/8, right = 1/8, top = 1/4, bottom = 2/4 },
	["Scourge"]		= { left = 1/8, right = 2/8, top = 1/4, bottom = 2/4 },
	["Troll"]		= { left = 2/8, right = 3/8, top = 1/4, bottom = 2/4 },
	["Orc"]			= { left = 3/8, right = 4/8, top = 1/4, bottom = 2/4 },
	["BloodElf"]	= { left = 4/8, right = 5/8, top = 1/4, bottom = 2/4 },
};

--------------------------------------------------------------------------------------------------------
--                                         OnLoad & OnUpdate                                          --
--------------------------------------------------------------------------------------------------------
function Examiner_OnLoad(self)
	-- Init Specific Mod Vars
	self.modName = "Examiner";
	self.modVers = GetAddOnMetadata(self.modName,"Version");
	-- Add Slash Command
	SlashCmdList[self.modName] = Examiner_OnSlash;
	_G["SLASH_"..self.modName.."1"] = "/examiner";
	_G["SLASH_"..self.modName.."2"] = "/ex";
	-- Events
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("UNIT_MODEL_CHANGED");
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self:RegisterEvent("INSPECT_HONOR_UPDATE");
	self:RegisterEvent("INSPECT_TALENT_READY");
	self:RegisterEvent("CHAT_MSG_ADDON");
	-- Set Misc Stuff
	self.showItems = true;
	Examiner_ConfigFrameFooter:SetText("Examiner |cffffff80"..self.modVers);
	-- UIPanelWindow & UISpecialFrames Entry
	UIPanelWindows[self.modName] = { area = "left", pushable = 1, whileDead = 1 };
	tinsert(UISpecialFrames,self.modName);
	-- Hook Blizz Inspect
	InspectUnit = Examiner_InspectUnit;
	UnitPopupButtons["INSPECT"].text = "Examine";
	UnitPopupButtons["INSPECT"].dist = 0;
	-- Talent Init
	Examiner.inspect = true;
	TalentFrame_Load(Examiner);
	-- Talent Tabs
	self.selectedTab = 1;
	self.currentSelectedTab = 1;
	PanelTemplates_SetNumTabs(self,5);
	PanelTemplates_UpdateTabs(self);
end

-- OnUpdate
function Examiner_OnUpdate(self,elapsed)
	if (self.markForUpdate) and (Examiner_CheckLastUnit()) and (CheckInteractDistance(u.token,1)) then
		Examiner_InspectUnit(u.token);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------
function Examiner_OnEvent(self,event)
	-- Variables Loaded
	if (event == "VARIABLES_LOADED") then
		cfg = Examiner_Config;
		cache = Examiner_Cache;
		-- Default Config
		for option, defValue in pairs(EX_DefaultConfig) do
			if (cfg[option] == nil) then
				cfg[option] = defValue;
			end
		end
		-- SET: Background Visibility | Scale | Frame Movability
		Examiner_ShowBackground();
		self:SetScale(cfg.scale);
		self:SetMovable(not cfg.ActAsUIFrame);
		-- Build Cache List
		if (cfg.activePage == 2) then
			Examiner_BuildCacheList();
		end
	-- AddOn Messages
	elseif (event == "CHAT_MSG_ADDON") and (cfg.AcceptAddonMsg) then
		if (arg3 == "WHISPER") and (arg2 ~= "") and (arg1:sub(1,8) == "EXAMINER") then
			-- Split
			local entryName, data = arg1:match("^EXAMINER#(.-)#(.+)$");
			data = { entryName, ("\\"):split(data) };
			-- Special Commands
			if (data[2] and data[2] == "CMD") then
				if (arg2 == "CLEAR") then
					cache[data[1]] = { Items = {}, Sets = {} };
				elseif (arg2 == "DONE") then
					AzMsg("|2Examiner|r Received inspection data for |1"..Examiner_PlayerChatLink(data[1]).."|r from |1"..Examiner_PlayerChatLink(arg4).."|r.");
					SendAddonMessage("EXAMINER#"..data[1].."#CMD","RECIEVED","WHISPER",arg4);
					if (cfg.activePage == 2) then
						Examiner_BuildCacheList();
					end
				elseif (arg2 == "RECIEVED") then
					AzMsg("|2Examiner|r Your data of |1"..Examiner_PlayerChatLink(data[1]).."|r was received by |1"..Examiner_PlayerChatLink(arg4).."|r.");
				end
				return;
			end
			-- Fill out table
			local cacheTable = cache;
			for i = 1, #data - 1 do
				if (not cacheTable[data[i]]) then
					cacheTable[data[i]] = {};
				end
				cacheTable = cacheTable[data[i]];
			end
			-- Set Value
			cacheTable[data[#data]] = (tonumber(arg2) and tonumber(arg2) or arg2);
		end
	------------------------------------
	-- End Here if Examiner is Closed --
	------------------------------------
	elseif (not Examiner:IsShown()) then
		return;
	-- Target Unit Changed
	elseif (event == "PLAYER_TARGET_CHANGED") then
		if (cfg.AutoInspect) and (UnitExists("target")) then
			Examiner_InspectUnit("target");
		elseif (u.token == "target") then
			u.token = nil;
			self.markForUpdate = nil;
		end
	-- Mouseover Unit Changed
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		u.token = nil;
		self.markForUpdate = nil;
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
	-- Model or Portrait Change
	elseif (event == "UNIT_MODEL_CHANGED" or event == "UNIT_PORTRAIT_UPDATE") then
		if (Examiner_CheckLastUnit() and UnitIsUnit(arg1,u.token)) then
			ExaminerModel:ClearModel();
			ExaminerModel:SetUnit(u.token);
			SetPortraitTexture(ExaminerPortrait,u.token);
		end
	-- Refresh on Item Change
	elseif (event == "UNIT_INVENTORY_CHANGED") then
		if (Examiner_CheckLastUnit() and UnitIsUnit(arg1,u.token) and CheckInteractDistance(u.token,1)) then
			Examiner_InspectUnit(u.token);
		end
	-- Honor Update
	elseif (event == "INSPECT_HONOR_UPDATE") then
		Examiner_PVPUpdate();
	-- Talent Update
	elseif (event == "INSPECT_TALENT_READY") then
		if (ExaminerTalents:IsShown()) then
			Examiner_TalentsTabs_Update();
			TalentFrame_Update(Examiner);
		end
		u.talents = select(3,GetTalentTabInfo(1,true)).."/"..select(3,GetTalentTabInfo(2,true)).."/"..select(3,GetTalentTabInfo(3,true));
		if (cfg.EnableCache) then
			local cacheEntry = cache[Examiner_GetEntryName()];
			if (cacheEntry) and (time() - cacheEntry.time <= 8) then
				cacheEntry.talents = u.talents;
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Slash Handling                                           --
--------------------------------------------------------------------------------------------------------
function Examiner_OnSlash(cmd)
	-- Extract Parameters
	local param1, param2 = cmd:match("^([^%s]+)%s*(.*)$");
	param1 = (param1 and param1:lower() or cmd:lower());
	-- Inspect!
	if (param1 == "inspect" or param1 == "i") then
		Examiner_InspectUnit(param2 == "" and "target" or param2);
	-- Scan a Single Item
	elseif (param1 == "si") then
		if (param2 ~= "") then
			local itemStats = {};
			ExScanner:ScanItemLink(param2,itemStats);
			AzMsg("--- |2Scan Overview for "..param2.."|r ---");
			for stat in pairs(itemStats) do
				AzMsg((ExScanner.StatNames[stat] or stat).." = |1"..Examiner_GetStatValue(stat,itemStats,nil,UnitLevel("player")).."|r.");
			end
		else
			AzMsg("No item link given.");
		end
	-- Compares two Items
	elseif (param1 == "compare") then
		if (param2 ~= "") then
			local item1, item2 = param2:match("(|c.+|r)%s+(|c.+|r)");
			if (item1 and item2) then
				local itemStats1, itemStats2 = {}, {};
				ExScanner:ScanItemLink(item1,itemStats1);
				ExScanner:ScanItemLink(item2,itemStats2);
				AzMsg("--- |2Compare of "..item1.."|2 to "..item2.."|r ---");
				for statToken, statName in pairs(ExScanner.StatNames) do
					if (itemStats1[statToken] or itemStats2[statToken]) then
						AzMsg(statName.." = |1"..Examiner_GetStatValue(statToken,itemStats1,itemStats2,UnitLevel("player")).."|r.");
					end
				end
			else
				AzMsg("Could not parse item links.");
			end
		else
			AzMsg("No item links given.");
		end
	-- Arena Calculator
	elseif (param1 == "arena") then
		param2 = tonumber(param2);
		if (type(param2) == "number") then
			AzMsg(format("|2Arena Point Calculation|r |1%d|r Rating |2=|r 2v2: |1%.1f|r, 3v3: |1%.1f|r, 5v5: |1%.1f|r.",param2,Examiner_CalculateArenaPoints(param2,2),Examiner_CalculateArenaPoints(param2,3),Examiner_CalculateArenaPoints(param2,5)));
		end
	-- Scale
	elseif (param1 == "scale") then
		param2 = tonumber(param2);
		if (type(param2) == "number") then
			cfg.scale = param2;
			Examiner:SetScale(param2);
		end
	-- Clear Cache
	elseif (param1 == "clearcache") then
		Examiner_Cache = {};
		cache = Examiner_Cache;
		if (Examiner.activePage == 2) then
			Examiner_BuildCacheList();
		end
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg("----- |2"..Examiner.modName.."|r |1"..Examiner.modVers.."|r ----- |1"..format("%.2f",GetAddOnMemoryUsage(Examiner.modName)).." |2kb|r -----");
		AzMsg("The following |2parameters|r are valid for |2/examiner|r or |2/ex|r:");
		AzMsg(" |2inspect 'unit'|r = Inspects the given unit ('target' if no unit given)");
		AzMsg(" |2si 'itemlink'|r = Scans one item and shows the total sum of its stats combined");
		AzMsg(" |2compare 'itemlink1' 'itemlink2'|r = Compares two items by listing the stat differences");
		AzMsg(" |2arena 'rating'|r = Arena Point Calculator");
		AzMsg(" |2scale 'value'|r = Sets the scale of the Examiner window (Default is 1)");
		AzMsg(" |2clearcache|r = Clears the entire Examiner cache");
	end
end

--------------------------------------------------------------------------------------------------------
--                                Global Chat Message Function (Rev 3)                                --
--------------------------------------------------------------------------------------------------------
if (not AZMSG_REV or AZMSG_REV < 3) then
	AZMSG_REV = 3;
	function AzMsg(text)
		DEFAULT_CHAT_FRAME:AddMessage(tostring(text):gsub("|1","|cffffff80"):gsub("|2","|cffffffff"),128/255,192/255,255/255);
	end
end
--------------------------------------------------------------------------------------------------------
--                                            Model Frame                                             --
--------------------------------------------------------------------------------------------------------

function Examiner_Model_OnUpdate(self,elapsed)
	if (self.isRotating) then
		local endx, endy = GetCursorPosition();
		self.rotation = (endx - self.startx) / 34 + self:GetFacing();
		self:SetFacing(self.rotation);
		self.startx, self.starty = GetCursorPosition();
	elseif (self.isPanning) then
		local endx, endy = GetCursorPosition();
		local z, x, y = self:GetPosition(z,x,y);
		x = (endx - self.startx) / 45 + x;
		y = (endy - self.starty) / 45 + y;
		self:SetPosition(z,x,y);
		self.startx, self.starty = GetCursorPosition();
	end
end

function Examiner_Model_OnMouseWheel(self)
	local z, x, y = self:GetPosition();
	local scale = (IsControlKeyDown() and 2 or 0.7);
	z = (arg1 > 0 and z + scale or z - scale);
	self:SetPosition(z,x,y);
end

function Examiner_Model_OnMouseDown(self)
	self.startx, self.starty = GetCursorPosition();
	if (arg1 == "LeftButton") then
		self.isRotating = 1;
		if (IsControlKeyDown()) then
			Examiner_SetBackgroundTexture(nil);
		end
	elseif (arg1 == "RightButton") then
		self.isPanning = 1;
		if (IsControlKeyDown()) then
			cfg.showBackground = (not cfg.showBackground);
			Examiner_ShowBackground();
		end
	end
end

function Examiner_Model_OnMouseUp(self)
	if (arg1 == "LeftButton") then
		self.isRotating = nil;
	elseif (arg1 == "RightButton") then
		self.isPanning = nil;
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Config Stuff                                            --
--------------------------------------------------------------------------------------------------------

-- CheckBoxes: OnLoad
function Examiner_ConfigCheckBox_OnLoad(self)
	self.tooltipText = EX_Checks[self:GetID()].tip;
	_G[self:GetName().."Text"]:SetText(EX_Checks[self:GetID()].label);
end

-- Config Frame OnShow
function Examiner_Config_OnShow()
	for index, table in ipairs(EX_Checks) do
		_G["Examiner_ConfigFrameCheck"..index]:SetChecked(cfg[EX_Checks[index].var]);
	end
end

-- CheckBoxes: OnClick
function Examiner_ConfigCheckBox_OnClick(self,button)
	local id = self:GetID();
	cfg[EX_Checks[id].var] = not cfg[EX_Checks[id].var];
	if (EX_Checks[id].var == "CombineAdditiveStats" or EX_Checks[id].var == "RatingsInPercent") then
		Examiner_BuildStatList();
	elseif (EX_Checks[id].var == "ActAsUIFrame") then
		Examiner:SetMovable(not cfg.ActAsUIFrame);
		if (cfg.ActAsUIFrame) then
			Examiner:Hide();
			ShowUIPanel(Examiner);
		else
			HideUIPanel(Examiner);
			Examiner:Show();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                             Item Slots                                             --
--------------------------------------------------------------------------------------------------------

-- OnLoad
function Examiner_ItemSlots_OnLoad(self)
	local buttonName = self:GetName();
	local slotId;
	self.slotName = buttonName:sub(20);
	slotId, self.backgroundTextureName = GetInventorySlotInfo(self.slotName);
	_G[buttonName.."IconTexture"]:SetTexture(self.backgroundTextureName);
	self:RegisterForClicks("LeftButtonUp","RightButtonUp");
	self:RegisterForDrag("LeftButton");
	self:SetID(slotId);
end

-- OnClick
function Examiner_ItemSlots_OnClick(self,button)
	if (self.link) then
		if (button == "RightButton") then
			local gemLink;
			AzMsg("---|2 Gem Overview for "..select(2,GetItemInfo(self.link)).." |r---");
			for i = 1, 3 do
				gemLink = select(2,GetItemGem(self.link,i));
				if (gemLink) then
					AzMsg(format("Gem |1%d|r = %s",i,gemLink));
				end
			end
		elseif (button == "LeftButton") then
			if (IsControlKeyDown()) then
				DressUpItemLink(self.link);
			elseif (IsShiftKeyDown()) and (ChatFrameEditBox:IsVisible()) then
				ChatFrameEditBox:Insert(select(2,GetItemInfo(self.link)));
			else
				Examiner_ItemSlots_OnDrag(self);
			end
		end
	elseif (self.realLink) then
		ExScannerTip:ClearLines();
		ExScannerTip:SetHyperlink(self.realLink);
		Examiner_LoadPlayerFromCache(cache[Examiner_GetEntryName()],3);
		Examiner_ItemSlots_OnEnter(self);
	end
end

-- OnDrag
function Examiner_ItemSlots_OnDrag(self)
	if (Examiner_CheckLastUnit() and UnitIsUnit(u.token,"player")) then
		PickupInventoryItem(self:GetID());
	end
end

-- OnEnter
function Examiner_ItemSlots_OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	if (Examiner_CheckLastUnit() and CheckInteractDistance(u.token,1) and GameTooltip:SetInventoryItem(u.token,self:GetID())) then
	elseif (self.link) then
		GameTooltip:SetHyperlink(self.link);
	elseif (self.realLink) then
		GameTooltip:SetText(_G[self.slotName:upper()]);
		GameTooltip:AddLine("ItemID: "..self.realLink:match("item:(%d+)"),0,0.44,0.86);
		GameTooltip:AddLine("This item is unsafe, you can click to query\nthe server, but it may result in a disconnect.",1,1,1);
		GameTooltip:Show();
	else
		GameTooltip:SetText(_G[self.slotName:upper()]);
	end
end

-- OnLeave
function Examiner_ItemSlots_OnLeave(self)
	ResetCursor();
	GameTooltip:Hide();
	Examiner.statTooltip = nil;
end

-- OnUpdate
function Examiner_ItemSlots_OnUpdate(self,elapsed)
	if (GameTooltip:IsOwned(self)) and (self.link) then
		-- Inspect Cursor
		if (IsControlKeyDown()) then
			ShowInspectCursor();
		else
			ResetCursor();
		end
		-- StatTip Hide
		if (not IsAltKeyDown()) and (Examiner.statTooltip) then
			Examiner.statTooltip = nil;
			Examiner_ItemSlots_OnEnter(self);
		-- StatTip Show
		elseif (IsAltKeyDown()) and (not Examiner.statTooltip) then
			Examiner.statTooltip = 1;
			GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
			local itemStats1, itemStats2 = {};
			local itemName, _, itemRarity = GetItemInfo(self.link);
			GameTooltip:AddLine(itemName,GetItemQualityColor(itemRarity));
			ExScanner:ScanItemLink(self.link,itemStats1);
			if (ExCompare) then
				itemStats2 = {};
				ExScanner:ScanItemLink(ExCompare[self.slotName],itemStats2);
			end
			for statToken, statName in pairs(ExScanner.StatNames) do
				if (itemStats1[statToken]) or (itemStats2 and itemStats2[statToken]) then
					GameTooltip:AddDoubleLine(statName,Examiner_GetStatValue(statToken,itemStats1,itemStats2),1,1,1);
				end
			end
			GameTooltip:Show();
		end
		-- Update the tip every frame to support Equip Compare...
		if (not Examiner.statTooltip) then
			Examiner_ItemSlots_OnEnter(self);
		end
	end
end

-- UpdateSlot: Updates slot from "button.link"
function Examiner_ItemSlots_UpdateItemSlot(button)
	local border = _G[button:GetName().."BorderTexture"];
	if (button.link) then
		local _, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(button.link);
		SetItemButtonTexture(button,itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark");
		local r,g,b = GetItemQualityColor(itemRarity and itemRarity > 0 and itemRarity or 0);
		border:SetVertexColor(r,g,b);
		border:Show();
	elseif (button.realLink) then
		SetItemButtonTexture(button,"Interface\\Icons\\INV_Misc_QuestionMark");
		border:Hide();
	else
		SetItemButtonTexture(button,button.backgroundTextureName);
		border:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Unit Details                                            --
--------------------------------------------------------------------------------------------------------

-- Unit Detail String
function Examiner_UnitDetailString()
	local info, color = {};
	-- Level
	color = GetDifficultyColor(u.level ~= -1 and u.level or 500);
	tinsert(info,LEVEL..(" |cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255)..(u.level ~= -1 and u.level or "??").."|r");
	-- Classification (non players only, so ok to use u.token)
	if (not u.raceFixed) then
		local classification = UnitClassification(u.token);
		if (Examiner.Classification[classification]) then
			tinsert(info,"("..Examiner.Classification[classification]..")");
		end
	end
	-- Race for Players / Family or Type for NPC's
	if (u.race) then
		tinsert(info,u.race ~= "Not specified" and u.race or "Unknown");
	end
	-- Players Only: Class (+ Realm)
	if (u.raceFixed) then
		if (u.class) then
			color = RAID_CLASS_COLORS[u.classFixed];
			tinsert(info,("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255)..u.class.."|r");
		end
		if (u.realm) then
			tinsert(info,"of "..u.realm);
		end
	end
	-- Return
	return table.concat(info," ");
end

-- Unit Guild String (Faction for NPC's)
function Examiner_UnitGuildString()
	-- Players
	if (u.raceFixed) then
		if (u.guild and u.guildRank and u.guildIndex) then
			return u.guildRank.." ("..u.guildIndex..") of <"..u.guild..">";
		end
	-- NPC's only, so ok to use 'u.token' here
	else
		ExScannerTip:ClearLines();
		ExScannerTip:SetUnit(u.token);
		local line;
		for i = 2, ExScannerTip:NumLines() - 1 do
			line = _G["ExScannerTipTextLeft"..i]:GetText();
			if (line:find("^"..LEVEL.." .+")) then
				line = _G["ExScannerTipTextLeft"..(i + 1)]:GetText();
				if (line ~= PVP_ENABLED) then
					return line;
				end
			end
		end
	end
	-- Else return empty
	return "";
end

-- Return name used for entires
function Examiner_GetEntryName()
	return (u.realm and u.name.."-"..u.realm or u.name);
end

--------------------------------------------------------------------------------------------------------
--                                            Cache Stuff                                             --
--------------------------------------------------------------------------------------------------------

-- Format Time (sec)
function Examiner_FormatTime(time)
	local color = "|cffffff80";
	-- bugged?
	if (time < 0) then
		return "n/a";
	-- under a min
	elseif (time < 60) then
		return color..time.."|rs";
	-- less than 1 hour
	elseif (time < 60*60) then
		return format(color.."%d|rm"..color.."%.2d|rs",time/60,mod(time,60));
	-- less than 1 day
	elseif (time < 60*60*24) then
		time = (time/60);
		return format(color.."%d|rh"..color.."%.2d|rm",time/60,mod(time,60));
	-- above 1 day
	else
		time = (time/60/60);
		return format(color.."%d|rd"..color.."%.2d|rh",time/24,mod(time,24));
	end
end

-- Cache Player
function Examiner_CachePlayer(override)
	if (not override) and (not cfg.EnableCache) then
		return;
	end
	-- New Entry
	local entryName = Examiner_GetEntryName();
	cache[entryName] = {};
	local entry = cache[entryName];
	for name, value in pairs(u) do
		if (name ~= "token") then
			entry[name] = value;
		end
	end
	-- Cache Items
	entry["Items"] = {};
	for _, slotName in ipairs(ExScanner.Slots) do
		entry["Items"][slotName] = _G["Examiner_ItemButton"..slotName].link;
	end
	-- Cache Sets
	entry["Sets"] = {};
	local idx;
	for setName, setEntry in pairs(ExSets) do
		entry["Sets"][setName] = { count = setEntry.count, max = setEntry.max };
		idx = 1;
		while (setEntry["setBonus"..idx]) do
			entry["Sets"][setName]["setBonus"..idx] = setEntry["setBonus"..idx];
			idx = (idx + 1);
		end
	end
	-- Cache Complete
	return 1;
end

-- Load player from cache
function Examiner_LoadPlayerFromCache(entry,loadLevel)
	-- loadLevel Information --
	-- 2 = Load no extra info from cache besides items/sets/pvp (Use when unit is in loading range but outside inspect range)
	-- 1 = Load just what we cannot get from being outside inspect range (Use when unit is outside loading and inspect range)
	-- 0 = Load everything (Use when you have no unit to get info from)
	if (loadLevel <= 2) then
		u.time = entry.time;
		u.zone = entry.zone;
		if (loadLevel > 0) and (u.level == -1) then
			u.level = entry.level;
		end
		if (loadLevel <= 1) then
			u.pvpName = entry.pvpName;
			u.guild, u.guildRank, u.guildIndex = entry.guild, entry.guildRank, entry.guildIndex;
			u.talents = entry.talents;
			if (loadLevel <= 0) then
				-- Clear last unit, as we don't have one for a cached player at level 0
				ClearInspectPlayer();
				u.token = nil;
				-- General Info
				u.name, u.realm = entry.name, entry.realm;
				u.level = entry.level;
				u.class, u.classFixed = entry.class, entry.classFixed;
				u.race, u.raceFixed = entry.race, entry.raceFixed;
				u.sex = entry.sex;
				-- Textures & Model
				ExaminerPortrait:SetTexture("Interface\\CharacterFrame\\TemporaryPortrait-"..(u.sex == 3 and "Female" or "Male").."-"..u.raceFixed);
				ExaminerModel:ClearModel();
				ExaminerModel:SetUnit("");
				Examiner_SetBackgroundTexture(u.raceFixed);
			end
		end
	end
	-- Title, Detail & Guild Text
	ExaminerTitle:SetText(u.pvpName);
	ExaminerDetails:SetText(Examiner_UnitDetailString());
	ExaminerGuild:SetText(Examiner_UnitGuildString());
	-- Reset
	ExStats = {};
	ExSets = {};
	-- Item Slots
	local button;
	for _, slotName in ipairs(ExScanner.Slots) do
		button = _G["Examiner_ItemButton"..slotName];
		button.link = entry["Items"][slotName];
		button.realLink = nil;
		-- Only scan the item if it's in the users local cache, to avoid DC's
		if (button.link) then
			if (GetItemInfo(button.link)) then
				ExScanner:ScanItemLink(button.link,ExStats);
			else
				if (cfg.ScanUnknownItems) then
					ExScannerTip:ClearLines();
					ExScannerTip:SetHyperlink(button.link);
				end
				button.realLink = button.link;
				button.link = nil;
			end
		end
		Examiner_ItemSlots_UpdateItemSlot(button);
	end
	-- Sets + Set Bonuses
	local idx;
	for setName, setEntry in pairs(entry["Sets"]) do
		ExSets[setName] = { count = setEntry.count, max = setEntry.max };
		idx = 1;
		while (setEntry["setBonus"..idx]) do
			ExSets[setName]["setBonus"..idx] = setEntry["setBonus"..idx];
			ExScanner:ScanLineForPatterns(setEntry["setBonus"..idx],ExStats);
			idx = (idx + 1);
		end
	end
	-- Honor + Arena
	Examiner_PVPClear();
	Examiner_LoadHonorFromCache(entry["Honor"]);
	Examiner_LoadArenaTeamsFromCache(entry);
	-- Update Stats
	Examiner_BuildStatList();
	Examiner_UpdateResistances();
	-- Finalize
	Examiner_StatFrameCached:Show();
	Examiner.statsLoaded = 1;
	Examiner.unitType = 3; -- Force unitType to 3 to make things simple by having Examiner believe it's a same faction unit?
	Examiner_Button_Stats:Enable();
	Examiner_Button_PvP:Enable();
	-- Talents Button
	if (Examiner_CheckLastUnit()) and (UnitIsVisible(u.token)) then
		Examiner_Button_Talents:Enable();
	else
		Examiner_Button_Talents:Disable();
	end
	-- Fix UI: Force page to Stats (but only if we are loading a person from the cache page)
	if (loadLevel == 0) then
		cfg.activePage = 3;
		Examiner_StatFrame:Show();
		Examiner_CacheFrame:Hide();
		Examiner_ShowItemSlotButtons();
	end
end

-- Cache List Sorting
function Examiner_SortCacheList(a,b)
	if (cache[a][cfg.cacheSort] == cache[b][cfg.cacheSort]) then
		return cache[a].name < cache[b].name;
	else
		return (cache[a][cfg.cacheSort] or "") < (cache[b][cfg.cacheSort] or "");
	end
end

-- Build the table used to display the cache (display table)
function Examiner_BuildCacheList()
	-- Create display table
	for index in ipairs(ExCacheList) do
		ExCacheList[index] = nil;
	end
	local filter = cfg.cacheFilter:upper();
	for entryName, entryTable in pairs(cache) do
		if (cfg.cacheFilter == "") or (entryName:upper():find(filter)) or (entryTable.guild and entryTable.guild:upper():find(filter)) then
			tinsert(ExCacheList,entryName);
		end
	end
	sort(ExCacheList,Examiner_SortCacheList);
	-- Update
	Examiner_CacheFrameHeader:SetText("Cached Players ("..#ExCacheList..")"..(cfg.cacheFilter ~= "" and " |cffffff00*" or ""));
	Examiner_CacheList_Update();
end

-- ScrollBar: Cache list update
function Examiner_CacheList_Update()
	FauxScrollFrame_Update(Examiner_CacheFrameScroll,#ExCacheList,8,30);
	local button, index, entryName, entry, color, coords, iconOffset;
	for i = 1, 8 do
		index = (FauxScrollFrame_GetOffset(Examiner_CacheFrameScroll) + i);
		button = _G["Examiner_CacheFrameEntry"..i];
		if (ExCacheList[index]) then
			entryName = ExCacheList[index];
			entry = cache[entryName];
			color = RAID_CLASS_COLORS[entry.classFixed];

			button.entryName = entryName;
			_G["Examiner_CacheFrameEntry"..i.."Name"]:SetText("|cffffffff"..entry.level.."|r "..entryName);
			_G["Examiner_CacheFrameEntry"..i.."Name"]:SetTextColor(color.r,color.g,color.b);

			coords = EX_RaceCoord[entry.raceFixed];
			iconOffset = (entry.sex == 3 and 0.5 or 0);
			_G["Examiner_CacheFrameEntry"..i.."Race"]:SetTexCoord(coords.left,coords.right,coords.top+iconOffset,coords.bottom+iconOffset);

			button:SetWidth(#ExCacheList > 8 and 200 or 214);
			button:Show();
		else
			button:Hide();
		end
	end
	-- Update Tooltip if we Scroll
	local mouseFocus = GetMouseFocus();
	if (mouseFocus) and (cache[mouseFocus.entryName]) and (GameTooltip:IsOwned(mouseFocus)) then
		Examiner_CacheEntry_OnEnter(mouseFocus);
	end
end

-- CacheEntry: OnClick
function Examiner_CacheEntry_OnClick(self,button)
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) and (ChatFrameEditBox:IsVisible()) then
			ChatFrameEditBox:Insert(self.entryName);
		else
			PlaySound("igMainMenuOptionCheckBoxOn");
			Examiner_LoadPlayerFromCache(cache[self.entryName],0);
		end
	elseif (button == "RightButton") and (IsShiftKeyDown()) then
		cache[self.entryName] = nil;
		Examiner_BuildCacheList();
	end
end

-- CacheEntry: OnEnter
function Examiner_CacheEntry_OnEnter(self)
	local entry = cache[self.entryName];
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	-- Init Text & Colors
	local color = RAID_CLASS_COLORS[entry.classFixed];
	local classText = ("|cff%.2x%.2x%.2x%s|r"):format(color.r*255,color.g*255,color.b*255,entry.class);
	color = GetDifficultyColor(entry.level);
	local level = ("|cff%.2x%.2x%.2x%d|r"):format(color.r*255,color.g*255,color.b*255,entry.level);
	-- Add Lines & Show
	GameTooltip:AddLine(entry.pvpName..(entry.realm and " - "..entry.realm or ""),0.5,0.75,1.0);
	if (entry.guild) then
		GameTooltip:AddLine("<"..entry.guild..">",0.0,0.5,0.8);
	end
	GameTooltip:AddLine(level.." "..entry.race.." "..classText,1,1,1);
	GameTooltip:AddLine(entry.zone,1,1,1);
	GameTooltip:AddLine(" ");
	GameTooltip:AddDoubleLine("Cache Index:",FauxScrollFrame_GetOffset(Examiner_CacheFrameScroll) + self:GetID());
	GameTooltip:AddDoubleLine("Last Inspected:",Examiner_FormatTime(time()-entry.time));
	GameTooltip:AddLine("Shift + Right-Click to Delete",0.75,0.75,0.75);
	GameTooltip:Show();
end

--------------------------------------------------------------------------------------------------------
--                                            Stats Stuff                                             --
--------------------------------------------------------------------------------------------------------

-- Returns a modified and formatted stat from the given "statTable", which might be adjusted by certain options
-- If "compareTable" is set, it assumes compare mode and displays and colorizes the differences.
function Examiner_GetStatValue(statToken,statTable,compareTable,level)
	local value = (statTable[statToken] or 0);
	local valuePct;
	-- Compare
	if (type(compareTable) == "table") then
		value = (value - Examiner_GetStatValue(statToken,compareTable,true));
	end
	-- OPTION: Add additive stats which stack to each other
	if (cfg.CombineAdditiveStats) then
		if (statTable["SPELLDMG"]) then
			for _, schoolToken in ipairs(EX_MagicSchools) do
				if (statToken == schoolToken.."DMG") then
					value = (value + statTable["SPELLDMG"]);
					break;
				end
			end
		end
		if (statToken == "RAP" or statToken == "APFERAL") and (statTable["AP"]) then
			value = (value + statTable["AP"]);
		end
	end
	-- OPTION: Give Rating Values in Percent
	if (ExScanner:GetRatingInPercent(statToken,value,level or u.level)) then
		valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(statToken,value,level or u.level)));
	end
	-- Do not modify the value further if we are just getting the compare value (compareTable == true)
	if (type(compareTable) ~= "boolean") then
		-- If Compare, Add Colors
		if (type(compareTable) == "table") then
			local color = (value > 0 and "|cff80ff80+") or (value < 0 and "|cffff8080");
			if (value ~= 0) then
				value = color..value;
			end
			if (valuePct) and (valuePct ~= 0) then
				valuePct = color..valuePct;
			end
		end
		-- Add "%" to converted ratings (Exclude Defense and Expertise)
		if (ExScanner.StatRatingBaseTable[statToken]) and (statToken ~= "DEFENSE") and (statToken ~= "EXPERTISE") then
			valuePct = valuePct.."%";
		end
	end
	-- Return
	if (type(compareTable) == "boolean") then
		return value;
	elseif (cfg.RatingsInPercent) and (ExScanner.StatRatingBaseTable[statToken]) then
		return valuePct, value;
	else
		return value, valuePct;
	end
end

-- Show Resistances
function Examiner_UpdateResistances()
	local label, statToken;
	for i = 1, 5 do
		label = _G["Examiner_StatFrameResistBox"..i.."Text"];
		statToken = (EX_MagicSchools[i].."RESIST");
		if (ExStats[statToken]) or (ExCompare and ExCompare[statToken]) then
			label:SetText(Examiner_GetStatValue(statToken,ExStats,ExCompare));
		else
			label:SetText("");
		end
	end
end

-- Build Stat List
function Examiner_BuildStatList()
	local lastHeader;
	local value, tip;
	-- Clear ExStatList
	for index in ipairs(ExStatList) do
		ExStatList[index] = nil;
	end
	-- Build display table
	for _, statCat in ipairs(Examiner.StatEntryOrder) do
		lastHeader = (#ExStatList + 1);
		for _, statToken in ipairs(statCat.stats) do
			if (ExStats[statToken]) or (ExCompare and ExCompare[statToken]) then
				value, tip = Examiner_GetStatValue(statToken,ExStats,ExCompare);
				tinsert(ExStatList,{ name = ExScanner.StatNames[statToken], value = value, tip = tip });
			end
		end
		if (lastHeader <= #ExStatList) then
			tinsert(ExStatList,lastHeader,{ name = statCat.name });
		end
	end
	-- Add Sets + One Line of Padding
	lastHeader = (#ExStatList + 1);
	for setName, setEntry in pairs(ExSets) do
		tinsert(ExStatList,{ name = setName, value = setEntry.count.."/"..setEntry.max });
	end
	if (lastHeader <= #ExStatList) then
		tinsert(ExStatList,lastHeader,{});
		tinsert(ExStatList,lastHeader+1,{ name = "Sets" });
	end
	-- Update
	tinsert(ExStatList,{});
	Examiner_StatList_Update();
end

-- ScrollBar: Update Stat List
function Examiner_StatList_Update()
	local maxEntries = 20;
	FauxScrollFrame_Update(Examiner_StatFrameScroll,#ExStatList,maxEntries,12);
	local index, entry, entryName, entryValue, entryTip;
	for i = 1, maxEntries do
		index = (FauxScrollFrame_GetOffset(Examiner_StatFrameScroll) + i);
		entry = _G["Examiner_StatFrameEntry"..i];
		if (ExStatList[index]) then
			entryName = _G["Examiner_StatFrameEntry"..i.."Name"];
			entryValue = _G["Examiner_StatFrameEntry"..i.."Value"];
			entryTip = _G["Examiner_StatFrameEntry"..i.."Tip"];
			if (ExStatList[index].value) then
				entryName:SetTextColor(1,1,1);
				entryName:SetText("  "..ExStatList[index].name);
				entryValue:SetText(ExStatList[index].value);
			elseif (ExStatList[index].name) then
				entryName:SetTextColor(0.5,0.75,1.0);
				entryName:SetText(ExStatList[index].name..":");
				entryValue:SetText("");
			else
				entryName:SetText("");
				entryValue:SetText("");
			end

			if (ExStatList[index].tip) then
				entryTip.tip = ExStatList[index].tip;
				entryTip:SetWidth(entryValue:GetWidth());
				entryTip:Show();
			else
				entryTip:Hide();
			end

			entry:SetWidth(#ExStatList > maxEntries and 200 or 214);
			entry:Show();
		else
			entry:Hide();
		end
	end
end

-- Entry Tip OnEnter
function Examiner_EntryTip_OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:SetText(self.tip);
end

--------------------------------------------------------------------------------------------------------
--                                             PvP Stuff                                              --
--------------------------------------------------------------------------------------------------------

-- Arena Team Detail Frame OnLoad
function Examiner_ArenaTeamDetail_OnLoad(self)
	local labels = { "Games", "Played", "Wins", "Losses", "Calculated Points", "PR" };
	_G[self:GetName().."Label"]:SetText(labels[self:GetID()]..":");
end

-- Update PvP Info
function Examiner_PVPUpdate()
	if (HasInspectHonorData()) then
		Examiner_LoadHonorNormal();
		Examiner_LoadArenaTeamsNormal();
	else
		RequestInspectHonorData();
	end
end

-- Load Honor Normal
function Examiner_LoadHonorNormal()
	local unit = (u.token or "");
	local faction = UnitFactionGroup(unit);
	local todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank = GetInspectHonorData();
	-- Update
	Examiner_UpdateHonor(todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank, faction);
	-- Cache
	if (cfg.EnableCache) and (cfg.CachePvP) then
		local cacheEntry = cache[Examiner_GetEntryName()];
		if (cacheEntry) and (time() - cacheEntry.time <= 8) then
			cacheEntry["Honor"] = { todayHK = todayHK, todayHonor = todayHonor, yesterdayHK = yesterdayHK, yesterdayHonor = yesterdayHonor, lifetimeHK = lifetimeHK, lifetimeRank = lifetimeRank };
		end
	end
	-- Show Honor Points for Player only
	if (UnitIsUnit(unit,"player")) then
		Examiner_PVPFrameLifetimeHonor:SetText(GetHonorCurrency());
		Examiner_PVPFrameLifetimeHonor:SetTextColor(0,1,0);
		--Examiner_PVPFrameHonorPointsValue:SetText("|cffffff80"..GetHonorCurrency());
		--Examiner_PVPFrameArenaPointsValue:SetText("|cffffff80"..GetArenaCurrency());
	end
end

-- Load Honor From Cache (Az: faction is always given as the player's which is a bit wrong)
function Examiner_LoadHonorFromCache(honorEntry)
	if (honorEntry) then
		Examiner_UpdateHonor(honorEntry.todayHK, honorEntry.todayHonor, honorEntry.yesterdayHK, honorEntry.yesterdayHonor, honorEntry.lifetimeHK, honorEntry.lifetimeRank, UnitFactionGroup("player"));
	end
end

-- Honor Update
function Examiner_UpdateHonor(todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank, faction)
	-- Show Rank
	if (lifetimeRank ~= 0) then
		Examiner_PVPFrameRank:SetTexture("Interface\\PvPRankBadges\\PvPRank"..format("%.2d",lifetimeRank-4));
		Examiner_PVPFrameRank:SetTexCoord(0,1,0,1);
		Examiner_PVPFrameHeader:SetText(GetPVPRankInfo(lifetimeRank,u.token).." (Rank "..(lifetimeRank-4)..")");
	-- Az: This needs a little rework
	else
		if (faction) then
			Examiner_PVPFrameRank:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..faction);
			Examiner_PVPFrameRank:SetTexCoord(0,0.59375,0,0.59375);
		else
			Examiner_PVPFrameRank:SetTexture(nil);
		end
		Examiner_PVPFrameHeader:SetText("No PvP Rank");
	end
	-- Show Kills/Honor
	Examiner_PVPFrameTodayKills:SetText(todayHK);
	Examiner_PVPFrameTodayHonor:SetText(todayHonor);
	Examiner_PVPFrameYesterdayKills:SetText(yesterdayHK);
	Examiner_PVPFrameYesterdayHonor:SetText(yesterdayHonor);
	Examiner_PVPFrameLifetimeKills:SetText(lifetimeHK);
	Examiner_PVPFrameLifetimeHonor:SetText("---");
	Examiner_PVPFrameLifetimeHonor:SetTextColor(1,1,0);

	-- New Show Kills/Honor (Not Used Yet)
--[[	Examiner_PVPFrameKillsTodayValue:SetText("|cffffff80"..todayHK);
	Examiner_PVPFrameKillsYesterdayValue:SetText("|cffffff80"..yesterdayHK);
	Examiner_PVPFrameKillsLifetimeValue:SetText("|cffffff80"..lifetimeHK);
	Examiner_PVPFrameHonorTodayValue:SetText("|cffffff80"..todayHonor);
	Examiner_PVPFrameHonorYesterdayValue:SetText("|cffffff80"..yesterdayHonor);]]
end

-- Load Arena Teams Normal
function Examiner_LoadArenaTeamsNormal()
	local teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, emblem, border;
	local seasonTeamPlayed, seasonTeamWins, seasonPlayerPlayed, teamRank;
	local backR, backG, backB, emblemR, emblemG, emblemB, borderR, borderG, borderB;
	local arenaFrame;
	local cacheEntry = cache[Examiner_GetEntryName()];
	-- Loop
	for i = 1, MAX_ARENA_TEAMS do
		if (Examiner_CheckLastUnit() and UnitIsUnit(u.token,"player")) then
			teamName, teamSize, teamRating, teamPlayed, teamWins, seasonTeamPlayed, seasonTeamWins, playerPlayed, seasonPlayerPlayed, teamRank, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB = GetArenaTeam(i);
			teamPlayed, teamWins, playerPlayed = seasonTeamPlayed, seasonTeamWins, seasonPlayerPlayed;
		else
			teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB = GetInspectArenaTeamData(i);
		end
		-- Update
		if (teamName) then
			Examiner_ArenaTeamUpdate(teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB);
			-- Cache
			if (cfg.EnableCache) and (cfg.CachePvP) and (cacheEntry) and (time() - cacheEntry.time <= 8) then
				cacheEntry["Arena"..i] = { teamName = teamName, teamSize = teamSize, teamRating = teamRating, teamPlayed = teamPlayed, teamWins = teamWins, playerPlayed = playerPlayed, playerRating = playerRating, backR = backR, backG = backG, backB = backB, emblem = emblem, emblemR = emblemR, emblemG = emblemG, emblemB = emblemB, border = border, borderR = borderR, borderG = borderG, borderB = borderB };
			end
		end
	end
end

-- Load Arena Team From Cache
function Examiner_LoadArenaTeamsFromCache(cacheEntry)
	local a;
	for i = 1, MAX_ARENA_TEAMS do
		if (cacheEntry["Arena"..i]) then
			a = cacheEntry["Arena"..i];
			Examiner_ArenaTeamUpdate(a.teamName, a.teamSize, a.teamRating, a.teamPlayed, a.teamWins, a.playerPlayed, a.playerRating, a.backR, a.backG, a.backB, a.emblem, a.emblemR, a.emblemG, a.emblemB, a.border, a.borderR, a.borderG, a.borderB);
		end
	end
end

-- Arena Team Update
function Examiner_ArenaTeamUpdate(teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, backR, backG, backB, emblem, emblemR, emblemG, emblemB, border, borderR, borderG, borderB)
	local arenaFrame = "Examiner_PVPFrameArenaTeam"..teamSize;
	-- General
	_G[arenaFrame.."Name"]:SetText(teamName);
	_G[arenaFrame.."Rating"]:SetText(teamRating);
	-- Games/Played
	_G[arenaFrame.."GamesValue"]:SetText("|cffffff80"..teamPlayed);
	_G[arenaFrame.."PlayedValue"]:SetText(Examiner_PVPFormatNumbers(playerPlayed,teamPlayed));
	-- Wins/Loss
	_G[arenaFrame.."WinsValue"]:SetText(Examiner_PVPFormatNumbers(teamWins,teamPlayed));
	_G[arenaFrame.."LossValue"]:SetText(Examiner_PVPFormatNumbers(teamPlayed-teamWins,teamPlayed));
	-- Estimated Points
	_G[arenaFrame.."PointsValue"]:SetFormattedText("|cffffff80%.1f",Examiner_CalculateArenaPoints(teamRating,teamSize));
	-- Personal Rating
	_G[arenaFrame.."PersonalValue"]:SetText("|cffffff80"..tostring(playerRating));
	-- Banner
	_G[arenaFrame.."Banner"]:SetTexture("Interface\\PVPFrame\\PVP-Banner-"..teamSize);
	_G[arenaFrame.."Banner"]:SetVertexColor(backR,backG,backB);
	_G[arenaFrame.."Emblem"]:SetVertexColor(emblemR,emblemG,emblemB);
	_G[arenaFrame.."Border"]:SetVertexColor(borderR,borderG,borderB);
	_G[arenaFrame.."Border"]:SetTexture(border ~= -1 and "Interface\\PVPFrame\\PVP-Banner-"..teamSize.."-Border-"..border or nil);
	_G[arenaFrame.."Emblem"]:SetTexture(emblem ~= -1 and "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-"..emblem or nil);
	-- Show Frame
	_G[arenaFrame]:Show();
end

-- Clear the PvP info
function Examiner_PVPClear()
	-- Header
	Examiner_PVPFrameRank:SetTexture(nil);
	Examiner_PVPFrameHeader:SetText("No PvP Details");
	-- Clear Honor
	Examiner_PVPFrameTodayKills:SetText("---");
	Examiner_PVPFrameTodayHonor:SetText("---");
	Examiner_PVPFrameYesterdayKills:SetText("---");
	Examiner_PVPFrameYesterdayHonor:SetText("---");
	Examiner_PVPFrameLifetimeKills:SetText("---");
	Examiner_PVPFrameLifetimeHonor:SetText("---");
	Examiner_PVPFrameLifetimeHonor:SetTextColor(1,1,0);
	-- Hide Arena Teams
	Examiner_PVPFrameArenaTeam2:Hide();
	Examiner_PVPFrameArenaTeam3:Hide();
	Examiner_PVPFrameArenaTeam5:Hide();
end

-- Format Numbers
function Examiner_PVPFormatNumbers(value,max)
	local color = (value == 0 and "|cffff8080" or "|cffffff80");
	if (max == 0) then
 		return color.."0|r ("..color.."0%|r)";
	else
		return color..value.."|r  ("..color..format("%.1f",value / max * 100).."%|r)";
	end
end

-- Calculate Arena Points (Updated Formula for 2.2)
function Examiner_CalculateArenaPoints(teamRating,teamSize)
	local points;
	if (teamRating <= 1500) then
		points = (0.22 * teamRating + 14);
	else
		points = (1511.26 / (1 + 1639.28 * 2.71828 ^ (-0.00412 * teamRating)));
	end
	return (teamSize == 5 and points) or (teamSize == 3 and points * 0.88) or (teamSize == 2 and points * 0.76);
end

--------------------------------------------------------------------------------------------------------
--                                           Inspect Stuff                                            --
--------------------------------------------------------------------------------------------------------

-- Normal Open
function Examiner_Open(unit)
	if (not u.name) then
		Examiner_InspectUnit("player");
	elseif (Examiner:IsVisible()) then
		HideUIPanel(Examiner);
	elseif (cfg.ActAsUIFrame) then
		ShowUIPanel(Examiner);
	else
		Examiner:Show();
	end
end

-- Inspect Unit
function Examiner_InspectUnit(unit)
	ClearInspectPlayer();
	-- Check Unit
	if (not unit or not UnitExists(unit)) then
		unit = "player";
	end
	-- Convert "mouseover" unit to party/raid unit
	if (unit == "mouseover") then
		if (GetNumRaidMembers() > 0) then
			for i = 1, GetNumRaidMembers() do
				if (UnitIsUnit("mouseover","raid"..i)) then
					unit = "raid"..i;
					break;
				end
			end
		elseif (GetNumPartyMembers() > 0) then
			for i = 1, GetNumPartyMembers() do
				if (UnitIsUnit("mouseover","party"..i)) then
					unit = "party"..i;
					break;
				end
			end
		end
	end
	-- Mouseover Event
	if (unit == "mouseover") then
		Examiner:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	else
		Examiner:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
	end
	-- Get Unit Info
	u.token = unit;
	u.name, u.realm = UnitName(unit);
	if (u.realm == "") then
		u.realm = nil;
	end
	u.pvpName = UnitPVPName(unit);
	u.level = (UnitLevel(unit) or 0);
	u.sex = (UnitSex(unit) or 1);
	u.class, u.classFixed = UnitClass(unit);
	u.race, u.raceFixed = UnitRace(unit);
	if (not u.race) then
		u.race = UnitCreatureFamily(unit) or UnitCreatureType(unit);
	end
	u.guild, u.guildRank, u.guildIndex = GetGuildInfo(unit);
	u.time = time();
	u.zone = GetMinimapZoneText();
	if (GetRealZoneText() ~= u.zone) then
		u.zone = GetRealZoneText()..", "..u.zone;
	end
	u.talents = nil;
	-- Textures & Model
	ExaminerModel:ClearModel();
	ExaminerModel:SetUnit(unit);
	SetPortraitTexture(ExaminerPortrait,unit);
	Examiner_SetBackgroundTexture(u.raceFixed);
	-- Title, Detail & Guild Text
	ExaminerTitle:SetText(u.pvpName or u.name);
	ExaminerDetails:SetText(Examiner_UnitDetailString());
	ExaminerGuild:SetText(Examiner_UnitGuildString());
	-- Reset
	ExStats = {};
	ExSets = {};
	Examiner.markForUpdate = nil;
	Examiner.statsLoaded = nil;
	Examiner_PVPClear();
	-- Unit Type (1 = npc, 2 = opposing faction, 3 = same faction)
	Examiner.unitType = (not UnitIsPlayer(unit) and 1) or (UnitCanCooperate("player",unit) and 3) or 2;
	-- Inspect & Cache (If 'markForUpdate' gets set to true, it will reinspect once when getting into inspect range)
	local inInspectRange = CheckInteractDistance(unit,1);
	local isVisible = UnitIsVisible(unit);
	-- NPC's
	if (Examiner.unitType == 1) then
		Examiner_PVPFrame:Hide();
		Examiner_Button_PvP:Disable();
		Examiner_Button_Talents:Disable();
	-- Players
	else
		Examiner_Button_PvP:Enable();
		-- Is Unit Loaded?
		if (isVisible) then
			NotifyInspect(unit);
			Examiner_Button_Talents:Enable();
			Examiner.unit = u.token;
			if (ExaminerTalents:IsShown()) then
				Examiner_TalentsTabs_Update();
				TalentFrame_Update(Examiner);
			end
		else
			Examiner_Button_Talents:Disable();
		end
		-- In or Out of Inspect Range Depending Stuff
		if (inInspectRange) then
			Examiner_PVPUpdate();
		else
			Examiner.markForUpdate = 1;
		end
		-- In Range & Same Faction Unit
		if (inInspectRange) and (Examiner.unitType == 3) then
			Examiner_StatFrameCached:Hide();
			Examiner.statsLoaded = 1;
			ExScanner:ScanUnitItems(unit,ExStats,ExSets);
			Examiner_GetUnitItems(unit);
			Examiner_UpdateResistances();
			Examiner_BuildStatList();
			if (Examiner_CachePlayer()) and (cfg.activePage == 2) then
				Examiner_BuildCacheList();
			end
		-- Otherwise, try and load from Cache
		else
			local entryName = Examiner_GetEntryName();
			if (cache[entryName]) then
				Examiner_LoadPlayerFromCache(cache[entryName],isVisible and 2 or 1);
			end
		end
	end
	-- If Talents are Showing
	if (ExaminerTalents:IsShown()) and (not isVisible or Examiner.unitType == 1) then
		Examiner_TalentsVisible(false);
	end
	-- Fix UI Depending on Stats Being Loaded
	if (Examiner.statsLoaded) then
		if (cfg.activePage) then
			_G["Examiner_"..EX_Frames[cfg.activePage].."Frame"]:Show();
		end
		Examiner_Button_Stats:Enable();
	else
		if (cfg.activePage ~= 4) then
			Examiner_UIToggleExclusive(nil);
		end
		Examiner_Button_Stats:Disable();
	end
	-- Item Buttons
	Examiner_ShowItemSlotButtons();
	-- Show Examiner
	if (not Examiner:IsShown()) then
		if (cfg.ActAsUIFrame) then
			ShowUIPanel(Examiner);
		else
			Examiner:Show();
		end
	end
end

-- Get Unit Items
function Examiner_GetUnitItems(unit)
	local button;
	for _, slotName in ipairs(ExScanner.Slots) do
		button = _G["Examiner_ItemButton"..slotName];
		button.link = GetInventoryItemLink(unit,button:GetID());
		if (button.link) then
			button.link = button.link:match(ExScanner.ItemLinkPattern);
		end
		Examiner_ItemSlots_UpdateItemSlot(button);
	end
end

-- Hover over the CachedIcon
function Examiner_CacheIcon_OnEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:AddLine("Cached Entry");
	GameTooltip:AddDoubleLine("Last Inspected:",Examiner_FormatTime(time()-u.time),1,1,1);
	GameTooltip:AddDoubleLine("Zone:",u.zone,1,1,1);
	GameTooltip:Show();
end

-- Hover over the InfoIcon
function Examiner_InfoIcon_OnEnter(self)
	-- Get Data that Requires a Loop Through items
	local iLvlTotal, iLvl = 0;
	local gemCount, gemRed, gemYellow, gemBlue = 0, 0, 0, 0;
	local link, gemLink, line;
	for _, slotName in ipairs(ExScanner.Slots) do
		link = _G["Examiner_ItemButton"..slotName].link;
		-- Count Gem Colors
		if (link) then
			for i = 1, 3 do
				gemLink = select(2,GetItemGem(link,i));
				if (gemLink) and (GetItemInfo(gemLink)) then
					gemCount = (gemCount + 1);
					ExScannerTip:ClearLines();
					ExScannerTip:SetHyperlink(gemLink);
					for i = 3, ExScannerTip:NumLines() do
						line = _G["ExScannerTipTextLeft"..i]:GetText();
						if (line:find("^\".+\"$")) then
							if (line:find(RED_GEM)) then
								gemRed = (gemRed + 1);
							end
							if (line:find(YELLOW_GEM)) then
								gemYellow = (gemYellow + 1);
							end
							if (line:find(BLUE_GEM)) then
								gemBlue = (gemBlue + 1);
							end
							break;
						end
					end
				end
			end
		end
		-- Calculate Item Level Numbers
		if (slotName ~= "TabardSlot") and (slotName ~= "ShirtSlot") and (link) then
			iLvl = select(4,GetItemInfo(link));
			if (iLvl) then
				if (slotName == "MainHandSlot") and (not _G["Examiner_ItemButtonSecondaryHandSlot"].link) then
					iLvl = (iLvl * 2);
				end
				iLvlTotal = (iLvlTotal + iLvl);
			end
		end
	end
	-- Generate Tooltip
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:AddLine("Other Details");
	GameTooltip:AddDoubleLine("Unit Token",tostring(u.token),1,1,1);
	if (u.talents) then
		GameTooltip:AddDoubleLine("Talent Specialization",u.talents,1,1,1);
	end
	GameTooltip:AddDoubleLine("Combined Item Levels",iLvlTotal,1,1,1);
	GameTooltip:AddDoubleLine("Average Item Level",format("%.2f",iLvlTotal / (#ExScanner.Slots - 2)),1,1,1);
	GameTooltip:AddDoubleLine("Number of Gems",gemCount,1,1,1);
	GameTooltip:AddDoubleLine("Gem Color Matches",format("|cffff6060%d|r/|cffffff00%d|r/|cff6060ff%d",gemRed,gemYellow,gemBlue),1,1,1);
	GameTooltip:Show();
end

--------------------------------------------------------------------------------------------------------
--                                             UI Buttons                                             --
--------------------------------------------------------------------------------------------------------

-- Main UI Buttons: OnEnter
function Examiner_Buttons_OnEnter(self)
	local id = self:GetID();
	local headers = { "Configurations", "Cached Players", "Gear Statistics", "Player vs. Player", "Show Talents" };
	local hints = { "Examiner Settings", "Right Click for extended menu", "Right Click for extended menu", "Honor & Arena Details", "The Inspected Player's Talent Specialization" };
	GameTooltip_SetDefaultAnchor(GameTooltip,self);
	GameTooltip:AddLine(headers[id]);
	GameTooltip:AddLine(hints[id],1,1,1);
	GameTooltip:Show();
end

-- Main UI Buttons: OnClick
function Examiner_Buttons_OnClick(self,button)
	local id = self:GetID();
	CloseDropDownMenus();
	-- Button = Left --
	if (button == "LeftButton") then
		-- Hide Talents if they are shown
		if (ExaminerTalents:IsShown()) then
			Examiner_TalentsVisible(false);
			Examiner_SetBackgroundTexture(u.raceFixed);
			if (id == 5) then
				id = nil;
				Examiner_UIToggleExclusive(nil);
				if (cfg.activePage) and (cfg.activePage ~= 3 or Examiner.statsLoaded) then
					_G["Examiner_"..EX_Frames[cfg.activePage].."Frame"]:Show();
				end
			end
		end
		-- Do stuff depending on button pressed
		if (id == 5) then
			Examiner_TalentsVisible(true);
			Examiner_TalentsTabs_Update();
			TalentFrame_Update(Examiner);
		elseif (id == 2) and (IsShiftKeyDown()) then
			AzDialog:New("Enter new cache filter...",cfg.cacheFilter,function(text) cfg.cacheFilter = text; Examiner_BuildCacheList(); end);
		elseif (id == 3) and (IsShiftKeyDown()) and (Examiner.statsLoaded) then
			Examiner_CacheStatsForCompare();
		elseif (id) then
			Examiner_UIToggleExclusive(id);
		end
		-- Update Cache List if Visible
		if (Examiner_CacheFrame:IsShown()) then
			Examiner_BuildCacheList();
		end
		-- Set Item Buttons Visible State
		if (ExaminerModel:IsShown()) then
			Examiner_ShowItemSlotButtons();
		end
	-- Button = Right --
	elseif (button == "RightButton") then
		if (id == 2 or id == 3) then
			ToggleDropDownMenu(1,nil,ExaminerDropDown,self:GetName(),0,0);
		end
	end
end

-- DropDown: OnLoad
function Examiner_DropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self,Examiner_DropDown_Initialize,"MENU");
end

-- DropDown: OnClick
function Examiner_DropDown_SelectItem()
	-- Sort
	if (type(this.value) == "string") then
		cfg.cacheSort = this.value;
	-- Cache Filter
	elseif (this.value == 1) then
		AzDialog:New("Enter new cache filter...",cfg.cacheFilter,function(text) cfg.cacheFilter = text; Examiner_BuildCacheList(); end);
	-- Clear Cache
	elseif (this.value == 2) then
		local entryCount = 0;
		table.foreach(cache,function() entryCount = (entryCount +1); end);
		AzDialog:New("Are you sure you want to clear "..entryCount.." entries?",nil,function() Examiner_Cache = {}; cache = Examiner_Cache; Examiner_BuildCacheList(); end);
	-- Cache Player
	elseif (this.value == 11) then
		Examiner_CachePlayer(1);
	-- Send To...
	elseif (this.value == 12) then
		local name, realm = UnitName("target");
		name = realm and format("%s-%s",name,realm:gsub(" ","")) or name or "";
		AzDialog:New("Enter name to send inspect data to...",name,Examiner_SendPlayer);
	-- Mark for Compare & Clear Compare
	elseif (this.value == 13 or this.value == 14) then
		Examiner_CacheStatsForCompare(this.value == 14);
	end

	-- Rebuild Cache List
	if (cfg.activePage == 2) and (type(this.value) == "string" or this.value == 2) then
		Examiner_BuildCacheList();
	end
end

-- DropDown: Init
local info = { func = Examiner_DropDown_SelectItem };
local EX_SortMethods = { "name", "realm", "level", "guild", "race", "class", "time" };
function Examiner_DropDown_Initialize()
	-- Cache
	if (this:GetID() == 2) then
		-- title: sort
		info.isTitle = 1;
		info.text = "Sort Method";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- method
		for _, method in ipairs(EX_SortMethods) do
			info.text = "Sort by "..method;
			info.value = method;
			info.checked = (cfg.cacheSort == method);
			UIDropDownMenu_AddButton(info);
		end
		info.checked = nil;
		info.isTitle, info.disabled = nil, nil;
		-- title: filter
		info.isTitle = 1;
		info.text = "";
		UIDropDownMenu_AddButton(info);
		info.text = "Filter";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- set filter
		info.text = "Set Filter...";
		info.value = 1;
		UIDropDownMenu_AddButton(info);
		-- title: clear
		info.isTitle = 1;
		info.text = "";
		UIDropDownMenu_AddButton(info);
		info.text = "Cache";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- clear
		info.text = "Clear All Entries";
		info.value = 2;
		UIDropDownMenu_AddButton(info);
	-- Stats
	elseif (this:GetID() == 3) then
		-- title: stats
		info.isTitle = 1;
		info.text = "Stats";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- items
		info.text = "Cache Player";
		info.value = 11;
		info.checked = (cache[Examiner_GetEntryName()] ~= nil);
		UIDropDownMenu_AddButton(info);
		info.checked = nil;
		-- send to
		info.text = "Send To...";
		info.value = 12;
		UIDropDownMenu_AddButton(info);
		-- title: compare
		info.isTitle = 1;
		info.text = "";
		UIDropDownMenu_AddButton(info);
		info.text = "Compare";
		UIDropDownMenu_AddButton(info);
		info.isTitle, info.disabled = nil, nil;
		-- mark for compare
		info.text = "Mark for Compare";
		info.value = 13;
		info.checked = (ExCompare and ExCompare.entry == Examiner_GetEntryName());
		UIDropDownMenu_AddButton(info);
		info.checked = nil;
		-- clear compare
		if (ExCompare) then
			info.text = "Clear Compare";
			info.value = 14;
			UIDropDownMenu_AddButton(info);
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Talent Stuff                                            --
--------------------------------------------------------------------------------------------------------

-- Select Tab
function Examiner_TalentsTab_OnClick(self,button)
	local id = self:GetID();
	PanelTemplates_SetTab(Examiner,id);
	Examiner.currentSelectedTab = id;
	Examiner.pointsSpent = select(3,GetTalentTabInfo(id,true));
	TalentFrame_Update(Examiner);
end

-- Update Tabs
function Examiner_TalentsTabs_Update()
	local numTabs = GetNumTalentTabs(true);
	local tab, tabName, pointsSpent;
	for i = 1, MAX_TALENT_TABS do
		tab = _G["ExaminerTab"..i];
		if (i <= numTabs) then
			tabName, _, pointsSpent = GetTalentTabInfo(i,true);
			if (i == Examiner.selectedTab) then
				Examiner.pointsSpent = pointsSpent;
			end
			tab:SetText(tabName.." |cff00ff00"..pointsSpent);
			tab:Show();
			PanelTemplates_TabResize(-18,tab);
		else
			tab:Hide();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                 Send Player (AddOn Whisper Message)                                --
--------------------------------------------------------------------------------------------------------

-- Returns a clickable chat link for a player
function Examiner_PlayerChatLink(name)
	return "|Hplayer:"..name.."|h["..name.."]|h";
end

-- Sends Table Recursive
function Examiner_SendStatRecursive(target,root,table)
	for name, value in pairs(table) do
		if (type(value) == "table") then
			Examiner_SendStatRecursive(target,root..name.."\\",value);
		elseif (name ~= "token") then
			SendAddonMessage(root..name,value,"WHISPER",target);
		end
	end
end

-- Sends the current inspected player to another person through SendAddonMessage()
function Examiner_SendPlayer(target)
	-- Check if we can actually send data
	if (not Examiner.statsLoaded) then
		AzMsg("|2Examiner|r No inspect data to send!");
		return;
	end
	-- Check if we have someone to send to
	if (not target or target == "") then
		AzMsg("|2Examiner|r Need player name to send to.");
		return;
	end
	-- Send Data: Clear Old Record & Send Root Values
	local entryName = Examiner_GetEntryName();
	SendAddonMessage("EXAMINER#"..entryName.."#CMD","CLEAR","WHISPER",target);
	Examiner_SendStatRecursive(target,"EXAMINER#"..entryName.."#",u);
	-- Items
	for _, slotName in ipairs(ExScanner.Slots) do
		SendAddonMessage("EXAMINER#"..entryName.."#Items\\"..slotName,_G["Examiner_ItemButton"..slotName].link,"WHISPER",target);
	end
	-- Sets
	Examiner_SendStatRecursive(target,"EXAMINER#"..entryName.."#Sets\\",ExSets);
	-- Honor + Arena
		-- Az: bla bla bla, not yet!
	-- Done
	SendAddonMessage("EXAMINER#"..entryName.."#CMD","DONE","WHISPER",target);
	AzMsg("|2Examiner|r Inspected player |1"..Examiner_PlayerChatLink(entryName).."|r sent to |1"..Examiner_PlayerChatLink(target).."|r.");
end

--------------------------------------------------------------------------------------------------------
--                                          UI Helper Stuff                                           --
--------------------------------------------------------------------------------------------------------

-- Cache current stats for compare or clear previous marked one
function Examiner_CacheStatsForCompare(unmark)
	if (unmark) then
		ExCompare = nil;
	else
		ExCompare = Examiner_CopyTable(ExStats);
		ExCompare.entry = Examiner_GetEntryName();
		for _, slotName in ipairs(ExScanner.Slots) do
			ExCompare[slotName] = _G["Examiner_ItemButton"..slotName].link;
		end
	end
	Examiner_BuildStatList();
	Examiner_UpdateResistances();
end

-- Toggle given frame, hide all others (give nil to hide all)
function Examiner_UIToggleExclusive(id)
	local frame;
	for frameId, frameName in ipairs(EX_Frames) do
		frame = _G["Examiner_"..frameName.."Frame"];
		if (frameId == id) and (not frame:IsShown()) then
			frame:Show();
		else
			frame:Hide();
		end
		if (frameId == id) then
			cfg.activePage = (frame:IsShown() and id or nil);
		end
	end
end

-- Show/Hide Item Slot Buttons
function Examiner_ShowItemSlotButtons(visible)
	if (not visible) then
		visible = (cfg.activePage ~= 4 and Examiner.statsLoaded and Examiner.showItems);
	end
	for _, slotName in ipairs(ExScanner.Slots) do
		if (visible) then
			_G["Examiner_ItemButton"..slotName]:Show();
		else
			_G["Examiner_ItemButton"..slotName]:Hide();
		end
	end
end

-- Talents visible or not
function Examiner_TalentsVisible(show)
	-- Show Talents
	if (show) then
		ExaminerModel:Hide();
		ExaminerTalents:Show();
		ExaminerDetails:Hide();
		ExaminerGuild:Hide();

		Examiner_UIToggleExclusive(nil);
		Examiner_ShowBackground(true);

		ExaminerBackgroundTopLeft:SetHeight(270);
		ExaminerBackgroundTopRight:SetHeight(270);
		ExaminerBackgroundBottomLeft:SetHeight(141);
		ExaminerBackgroundBottomRight:SetHeight(141);
		ExaminerBackgroundTopLeft:SetWidth(267);
		ExaminerBackgroundTopRight:SetWidth(74);
		ExaminerBackgroundBottomLeft:SetWidth(267);
		ExaminerBackgroundBottomRight:SetWidth(74);
	-- Hide Talents
	else
		ExaminerModel:Show();
		ExaminerTalents:Hide();
		ExaminerDetails:Show();
		ExaminerGuild:Show();
		for i = 1, MAX_TALENT_TABS do
			_G["ExaminerTab"..i]:Hide();
		end
		Examiner_ShowBackground();
		Examiner_SetBackgroundTexture(u.raceFixed);
	end
end

-- Toggle the Background
function Examiner_ShowBackground(show)
	if (show == nil and cfg.showBackground or show) then
		ExaminerBackgroundTopLeft:Show();
		ExaminerBackgroundTopRight:Show();
		ExaminerBackgroundBottomLeft:Show();
		ExaminerBackgroundBottomRight:Show();
	else
		ExaminerBackgroundTopLeft:Hide();
		ExaminerBackgroundTopRight:Hide();
		ExaminerBackgroundBottomLeft:Hide();
		ExaminerBackgroundBottomRight:Hide();
	end
end

-- Background Texture
function Examiner_SetBackgroundTexture(race)
	-- If watching talents, ignore this call
	if (ExaminerTalents:IsShown()) then
		return;
	end
	-- Find Texture
	local texture;
	if (not race) then
		texture = "Interface\\TalentFrame\\"..EX_Backgrounds[random(1,#EX_Backgrounds)].."-";
	else
		if (race == "Gnome") then
			race = "Dwarf";
		elseif (race == "Troll") then
			race = "Orc";
		end
		texture = "Interface\\DressUpFrame\\DressUpBackground-"..race;
	end
	-- Set Texture Height
	ExaminerBackgroundTopLeft:SetHeight(270);
	ExaminerBackgroundTopRight:SetHeight(270);
	ExaminerBackgroundBottomLeft:SetHeight(141);
	ExaminerBackgroundBottomRight:SetHeight(141);
	-- Set Texture
	if (texture:find("DressUpFrame")) then
		ExaminerBackgroundTopLeft:SetTexture(texture.."1");
		ExaminerBackgroundTopRight:SetTexture(texture.."2");
		ExaminerBackgroundBottomLeft:SetTexture(texture.."3");
		ExaminerBackgroundBottomRight:SetTexture(texture.."4");
		ExaminerBackgroundTopLeft:SetWidth(256);
		ExaminerBackgroundTopRight:SetWidth(64);
		ExaminerBackgroundBottomLeft:SetWidth(256);
		ExaminerBackgroundBottomRight:SetWidth(64);
	else
		ExaminerBackgroundTopLeft:SetTexture(texture.."TopLeft");
		ExaminerBackgroundTopRight:SetTexture(texture.."TopRight");
		ExaminerBackgroundBottomLeft:SetTexture(texture.."BottomLeft");
		ExaminerBackgroundBottomRight:SetTexture(texture.."BottomRight");
		ExaminerBackgroundTopLeft:SetWidth(267);
		ExaminerBackgroundTopRight:SetWidth(74);
		ExaminerBackgroundBottomLeft:SetWidth(267);
		ExaminerBackgroundBottomRight:SetWidth(74);
	end
end

-- Copy Table
function Examiner_CopyTable(source)
	local dest = {};
	for k, v in pairs(source) do
		if (type(v) == "table") then
			dest[k] = Examiner_CopyTable(v);
		else
			dest[k] = v;
		end
	end
	return dest;
end

-- Check Last Unit
function Examiner_CheckLastUnit()
	if (u.token) and (UnitExists(u.token)) and (UnitName(u.token) == u.name) then
		return 1;
	else
		u.token = nil;
		Examiner.markForUpdate = nil;
		return;
	end
end