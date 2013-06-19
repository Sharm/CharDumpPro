-- Author: for.sharm@gmail.com

local sheduler = Sheduler:create(0.1)

local professionSpells = {
    -- skillId = {
    --      rank1 spellId,
    --      rank2 spellId,
    --      rank3 spellId,
    --      rank4 spellId,
    --      rank5 spellId
    -- }
    
    -- Blacksmithing
    [164]	= { 2020, 2021, 3539, 9786, 29845 },
    -- Leatherworking
    [165]	= { 2155, 2154, 3812, 10663, 32550 },
    -- Alchemy
    [171]	= { 2275, 2280, 3465, 11612, 28597 },
    -- Herbalism
    [182] = { 2372, 2373, 3571, 11994, 28696 },
    -- Mining
    [186]	= { 2581, 2582, 3568, 10249, 29355 },
    -- Tailoring
    [197]	= { 3911, 3912, 3913, 12181, 26791 },
    -- Engineering
    [202]	= { 4039, 4040, 4041, 12657, 30351 },
    -- Enchanting
    [333]	= { 7414, 7415, 7416, 13921, 28030 },
    -- Skinning
    [393]	= { 8615, 8619, 8620, 10769, 32679 },
    -- Jewelcrafting
    [755]	= { 25245, 25246, 28896, 28899, 28901 },
    -- Riding
    [762] = { 33389, 33392, 34092, 34093 },
    -- Poisons
    [40]  = { 2995 },
    -- Fishing
    [356] = { 7733, 7734, 19889, 19890, 33100 },
    -- Cooking
    [185] = { 2551, 3412, 19886, 19887, 33361 },
    -- First Aid 
    [129] = { 3279, 3280, 19903, 19902, 27029 }
}

-- ATTENSION! Asynchronus work!

Restorer = { 
	_db = nil, -- reference to save table for current char
    _isErrorCatching = false,
    _isError = false,
    _itemsForRestore = 0,
    _itemsCmdForRestore = "",
    _itemsMsgTitle = "Items",
    errorCallback = nil,
    successCallback = nil,
    callbackObj = nil
}

local function _isValidInteger(value, low, high)
    return type(value) == "number" and (low == nil or value > low) and (high == nil or value < high)
end

local function _isValidString(value, count)
    return type(value) == "string" and (count == nil or #value > count)
end

function Restorer:_error(text)
    self._isError = true
    self.errorCallback(self.callbackObj, text)
end
    

function Restorer:_SendChatMessage(text)
    sheduler:shedule(function() 
        if not self._isError then
            local myname = UnitName("player")
            local targetname = UnitName("target")
            if myname ~= targetname then
                self:_error("Target self first!")
                return
            end
            Addon:Print("Execute command: "..text)
            SendChatMessage(text, "SAY")
        end
    end, self, text)
end

function Restorer:_enableErrorCatching()
    sheduler:shedule(function() 
        self._isError = false
        self._isErrorCatching = true
    end, self) 
end

function Restorer:_disableErrorCatching()
    sheduler:shedule(function() 
        self._isErrorCatching = false
    end, self) 
end

function Restorer:_registerOutput(callbackObj, successCallback, errorCallback)
    self.successCallback = successCallback
    self.errorCallback = errorCallback
    self.callbackObj = callbackObj
    self:_enableErrorCatching()
end

function Restorer:_on_CHAT_MSG_SAY()
    local msg = arg1
    local sender = arg2
    
    if self._isErrorCatching then
        local myname = UnitName("player")
        if sender == myname and string.match(msg, "^%..+") then
            self._error("Errors occures while execute GM commands.")
        end

    end
end

function Restorer:_on_CHAT_MSG_SYSTEM()
    local msg = string.lower(arg1)

    if self._isErrorCatching then
  
        if     string.find(msg, "incorrect", 0, true)
            or string.find(msg, "there is no such", 0, true)
            or string.find(msg, "not found", 0, true)
            or string.find(msg, "invalid", 0, true)
            or string.find(msg, "syntax", 0, true)
        then
            self._error("Errors occures while execute GM commands.")
        end

    end
end

function Restorer:_on_restoreFinished()
    sheduler:shedule(function() 
        if not self._isError then
            self.successCallback(self.callbackObj)
        end
        self:_disableErrorCatching()
    end, self)
end

function Restorer:openRecord(name)
	self._db = Addon.db.global[name]
    Addon:RegisterEvent("CHAT_MSG_SAY", function() self:_on_CHAT_MSG_SAY() end)
    Addon:RegisterEvent("CHAT_MSG_SYSTEM", function() self:_on_CHAT_MSG_SYSTEM() end)
end

-- Return nil if db empty
function Restorer:getRestoreRecordsNames()
    local records = nil

	for k,v in pairs(Addon.db.global) do
        local _, build, _, _ = GetBuildInfo()

        if v.mainInfo and v.mainInfo.engineVersion == DUMP_ENGINE_VERSION and v.mainInfo.clientbuild == build then
            records = records or {}
            table.insert(records, k)
        end
    end

    if records then
        table.sort(records)
    end

    return records
end

-- =================
-- Main info
-- =================

function Restorer:getMainInfoInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    -- Validates on record loading:
    -- -- self._db.mainInfo
    -- -- self._db.mainInfo.engineVersion
    -- -- self._db.mainInfo.clientbuild

    local db = self._db.mainInfo

    if not db then
        return false, "Common info is empty"
    end

    local validate = {
        ["Realmlist"] = _isValidString(db.realmlist, 4),
        ["Class"] = _isValidString(db.class, 4),
        ["Level"] = _isValidInteger(db.level, 0, 71), -- For 2.4.3
        ["Race"] = _isValidString(db.race, 4),
        ["HonorableKills"] = _isValidInteger(db.honorableKills, -1),
        ["Honor"] = _isValidInteger(db.honor, -1),
        ["Arena"] = _isValidInteger(db.arenapoints, -1),
        ["Money"] = _isValidInteger(db.money, -1)
    }

    for k,v in pairs(validate) do
        if not v then
            return false, k
        end
    end

    -- PREPARE WARNINGS
  
    local _, myclass = UnitClass("player")
    local _,myrace = UnitRace("player")

    local warnings = {
        class = {
            accepted = db.class == myclass and db.race == myrace,
        },
        kills = {
            accepted = false,
            isRestoreKills = false
        }
    }

    return true, db.class.." "..db.name.." "..tostring(db.level).." lvl", warnings
end

-- RESTORE

function Restorer:restoreMainInfo(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    local db = self._db.mainInfo

    local curLevel, curHonor, curArena, curMoney = UnitLevel("player"), GetHonorCurrency(), GetArenaCurrency(), GetMoney()

    self:_SendChatMessage(".level "..db.level - curLevel)
    self:_SendChatMessage(".mod honor "..db.honor - curHonor)
    self:_SendChatMessage(".mod arena "..db.arenapoints - curArena)
    self:_SendChatMessage(".mod money "..db.money - curMoney)

    if warnings.kills.isRestoreKills then
        self:_SendChatMessage(".debug setvalue 1517 "..db.honorableKills)
    end

    self:_on_restoreFinished()
end

-- =================
-- Inventory
-- =================
-- Send to mailbox message titles:
--  - Bags: mails contains olny bag items
--  - Equipped: mails contains olny equipped items
--  - Items: all other items from bags

function Restorer:getInventoryInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    local db = self._db.inventory

    if not db then
        return false, "Inventory info is empty"
    end

    local bagCount, itemsCount = 0, 0
    for k,v in pairs(db) do             -- loop through all bags
        for k2,v2 in pairs(v) do        -- loop through objects inside bag
            if k2 == "link" then        -- link to the bag item
                if not _isValidString(v2) then
                    return false, string.format("[%s]: bad bag link; link: [%s]", tostring(k), tostring(v2.link))
                end
                itemsCount = itemsCount + 1
            
            else if k2 == "size" then   -- bag size
                if not _isValidInteger(v2, 0, 100) then
                    return false, string.format("[%s]: bad bag size; size: [%s]", tostring(k), tostring(v2.size))
                end
                    
            else                        -- regular item object
                if not _isValidString(v2.link) or (v2.count and not _isValidInteger(v2.count, 0, 260)) then
                    return false, string.format("[%s]: bad link or count; link: [%s], count: [%s]", tostring(k), tostring(v2.link), tostring(v2.count))
                end   
                itemsCount = itemsCount + 1
            end
            end
        end
        bagCount = bagCount + 1
    end
    

    -- PREPARE WARNINGS

    local warnings = {
        onebag = {
            accepted = false,
            isRestoreOneBagOnly = false
        }
    }

    return true, itemsCount.." items in "..bagCount.." bags", warnings
end


-- RESTORE

-- return entry,chant,gem1,gem2,gem3,unk1,unk2,unk3,lvl1 in 
function Restorer:_parseItemLink(link)
    -- Hitem:31052:425:525:525:525:525:0:0
    -- linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest
    return string.match(link,".*Hitem:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+).*")
end

function Restorer:_sendItemsForRestore()
    if self._itemsForRestore > 0 then
        self:_SendChatMessage(string.format(".send items %%t \"%s\" \"%s\" %s", self._itemsMsgTitle, self._itemsMsgTitle, self._itemsCmdForRestore))
        self._itemsCmdForRestore = ""
        self._itemsForRestore = 0
    end
end

function Restorer:_pushItemForRestore(id, count)
    if self._itemsForRestore >= 5 then
        self:_sendItemsForRestore()
    end

    if self._itemsForRestore > 0 then
        self._itemsCmdForRestore = self._itemsCmdForRestore.." "
    end

    self._itemsCmdForRestore = self._itemsCmdForRestore..id
    
    if count then
        self._itemsCmdForRestore = self._itemsCmdForRestore..":"..count
    end
    
    self._itemsForRestore = self._itemsForRestore + 1
end

function Restorer:_restoreBagItems(bag, msgTitle)

    self._itemsMsgTitle = msgTitle or "Items"

    for k,v in pairs(bag) do
        -- ignore `size` and bag `link` fields
        if type(v) == "table" then 
            local id = self:_parseItemLink(v.link)
            local count = v.count or nil
            self:_pushItemForRestore(id, count)
        end
    end

    -- Restor all remaining items
    self:_sendItemsForRestore()
end

function Restorer:restoreInventory(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    local db = self._db.inventory

    -- Restore bags first
    local cmd = ""
    for k_bag, v_bag in pairs(db) do
        if v_bag.link then
            local id = self:_parseItemLink(v_bag.link)
            cmd = cmd..tostring(id).." "
        end
    end
    self:_SendChatMessage(string.format(".send items %%t \"Bags\" \"Bags\" %s", cmd))

    -- Restore equipped
    self:_restoreBagItems(db.Bag100, "Equipped")

    -- Restore bags
    if warnings.onebag.isRestoreOneBagOnly then
        self:_restoreBagItems(db.Bag0)    -- backpack
    else
        -- Restore items in all bags
        for k_bag, v_bag in pairs(db) do
            if k_bag ~= "Bag100" then
                self:_restoreBagItems(v_bag)
            end
        end
    end

    -- Flush remaining items
    self:_sendItemsForRestore()

    self:_on_restoreFinished()
end


-- =================
-- Reputations
-- =================

function Restorer:getReputationsInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    local db = self._db.reputation

    if not db then
        return false, "Reputations info is empty"
    end

    local repCount = 0
    for k,v in pairs(db) do 
        if not _isValidInteger(k, 0) or not _isValidInteger(v.factionId, 0) then
            return false, string.format("[%s] Bad faction id: %s", tostring(k), tostring(v.factionId))
        end

        if not _isValidInteger(v.earnedValue) then
            return false, string.format("[%s] Bad earned value: %s", tostring(k), tostring(v.earnedValue))
        end

        repCount = repCount + 1
    end

    return true, repCount.." reputations"
end

function Restorer:restoreReputations(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    local db = self._db.reputation

    for k,v in pairs(db) do 
        self:_SendChatMessage(string.format(".mod rep %d %d", k, v.earnedValue))
    end

    self:_on_restoreFinished()
end


-- =================
-- Skills
-- =================

function Restorer:getSkillsInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    local db = self._db.skills

    if not db then
        return false, "Skills info is empty"
    end

    local skillsCount = 0
    for k,v in pairs(db) do 
        if not _isValidInteger(k, 0) or not _isValidInteger(v.skillId, 0) then
            return false, string.format("[%s] Bad skill id: %s", tostring(k), tostring(v.skillId))
        end

        if not _isValidInteger(v.value, 0, 400) then
            return false, string.format("[%s] Bad skill value: %s", tostring(k), tostring(v.value))
        end

        if not _isValidInteger(v.maxValue, 0, 400) then
            return false, string.format("[%s] Bad skill max value: %s", tostring(k), tostring(v.maxValue))
        end

        skillsCount = skillsCount + 1
    end

    return true, skillsCount.." skills"
end

function Restorer:_getProfessionRank(maxValue)
    local rank = 5
    if maxValue < 375 then
        rank = 4
    elseif maxValue < 300 then
        rank = 3
    elseif maxValue < 225 then
        rank = 2
    elseif maxValue < 150 then
        rank = 1
    end
    return rank
end

function Restorer:restoreSkills(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    local db = self._db.skills

    for k,v in pairs(db) do 
        local rank = self:_getProfessionRank(v.maxValue)

        if v.skillId == 40 then -- Poisons
            rank = 1
        end

        if professionSpells[v.skillId] then
            if professionSpells[v.skillId][rank] then
                self:_SendChatMessage(".cast "..professionSpells[v.skillId][rank])
            else
                self:_error(string.format("[%d] Bad profession spell for rank %d", v.skillId, rank))
                return
            end
        end
        
        if not (v.skillId == 762) then -- No need to update skill for Riding
            self:_SendChatMessage(string.format(".setskill %d %d %d", v.skillId, v.value, v.maxValue))
        end
    end

    self:_on_restoreFinished()
end


-- =================
-- Recipes & specializations
-- =================

function Restorer:getRecipesInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    if not self._db.specs and not self._db.recipes then
        return false, "Recipes & specs info is empty"
    end

    if self._db.specs then
        for k,v in pairs(self._db.specs) do 
            if not _isValidInteger(v, 0) then
                return false, string.format("Bad spec spell id: %s", tostring(v))
            end
        end
    end

    if self._db.recipes then
        for k,v in pairs(self._db.recipes) do 
            if not _isValidInteger(v, 0) then
                return false, string.format("Bad recipe spell id: %s", tostring(v))
            end
        end
    end

    return true, #self._db.recipes.." recipes and "..#self._db.specs.." specializations"
end

function Restorer:_restoreSpells(spells)
    for k,v in pairs(spells) do 
        self:_SendChatMessage(".learn "..v)
    end
end

function Restorer:restoreRecipes(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    if self._db.specs then
        self:_restoreSpells(self._db.specs)
    end

    if self._db.recipes then
        self:_restoreSpells(self._db.recipes)
    end

    self:_on_restoreFinished()
end