-- Author: for.sharm@gmail.com

local sheduler = Sheduler:create(0.05)
local cmdProc = CommProc:create(sheduler)

local professionSpells = {
    -- skillId = {
    --      rank1 spellId,
    --      rank2 spellId,
    --      rank3 spellId,
    --      rank4 spellId,
    --      rank5 spellId
    -- }
    
    -- Blacksmithing
    [164]	= { cast = { 2020, 2021, 3539, 9786, 29845 }},
    -- Leatherworking
    [165]	= { cast = { 2155, 2154, 3812, 10663, 32550 }},
    -- Alchemy
    [171]	= { cast = { 2275, 2280, 3465, 11612, 28597 }},
    -- Herbalism
    [182]   = { cast = { 2372, 2373, 3571, 11994, 28696 }},
    -- Mining
    [186]	= { cast = { 2581, 2582, 3568, 10249, 29355 }},
    -- Tailoring
    [197]	= { cast = { 3911, 3912, 3913, 12181, 26791 }},
    -- Engineering
    [202]	= { cast = { 4039, 4040, 4041, 12657, 30351 }},
    -- Enchanting
    [333]	= { cast = { 7414, 7415, 7416, 13921, 28030 }},
    -- Skinning
    [393]	= { cast = { 8615, 8619, 8620, 10769, 32679 }},
    -- Jewelcrafting
    [755]	= { cast = { 25245, 25246, 28896, 28899, 28901 }},
    -- Riding
    [762]   = { cast = { 33389, 33392, 34092, 34093 }},
    -- Poisons
    [40]    = { cast = { 2995 }},
    -- Lockpicking
    [633]   = { cast = { 1809 }},
    -- Fishing
    [356]   = { cast = { 7733, 7734, 7736, 18249, 33098 }},
    -- Cooking
    [185]   = { cast = { 2551, 3412, 2552, 18261, 33360 }},
    -- First Aid 
    [129]   = { cast = { 3279, 3280, 7925, 10847, 33894 }},

    -- Swords
    [43]    = { learn = { 201 }},
    -- Axes
    [44]    = { learn = { 196 }},
    -- Bows
    [45]    = { learn = { 264 }},
    -- Guns
    [46]    = { learn = { 201 }},
    -- Maces
    [54]    = { learn = { 198 }},
    -- Two-Handed Swords
    [55]    = { learn = { 202 }},
    -- Staves
    [136]   = { learn = { 227 }},
    -- Two-Handed Maces
    [160]   = { learn = { 199 }},
    -- Unarmed
    [162]   = { learn = { 203 }},
    -- Two-Handed Axes
    [172]   = { learn = { 197 }},
    -- Daggers
    [173]   = { learn = { 1180 }},
    -- Thrown
    [176]   = { learn = { 2567 }},
    -- Crossbows
    [226]   = { learn = { 5011 }},
    -- Wands
    [228]   = { learn = { 5009 }},
    -- Polearms
    [229]   = { learn = { 200 }},
    
    
}

-- ATTENSION! Asynchronus work!

Restorer = { 
	_db = nil, -- reference to save table for current char
    _itemsForRestore = 0,
    _itemsCmdForRestore = "",
    _itemsMsgTitle = "Items",
    successCallback = nil,
    callbackObj = nil
}

local function _isValidInteger(value, low, high)
    return type(value) == "number" and (low == nil or value > low) and (high == nil or value < high)
end

local function _isValidString(value, count)
    return type(value) == "string" and (count == nil or #value > count)
end

function Restorer:_registerOutput(callbackObj, successCallback, errorCallback)
    self.successCallback = successCallback
    self.callbackObj = callbackObj
    cmdProc:registerOutput(callbackObj, errorCallback)
end
function Restorer:_on_restoreFinished()
    cmdProc:sheduleSuccessFunction(self.callbackObj, self.successCallback)
end

function Restorer:openRecord(name)
	self._db = Addon.db.global[name]
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
        ["Realmlist"] = _isValidString(db.realmlist, 1),
        ["Class"] = _isValidString(db.class, 3),
        ["Level"] = _isValidInteger(db.level, 0, 71), -- For 2.4.3
        ["Race"] = _isValidString(db.race, 2),
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

    cmdProc:SendChatMessage(".level "..db.level - curLevel)
    cmdProc:SendChatMessage(".mod honor "..db.honor - curHonor)
    cmdProc:SendChatMessage(".mod arena "..db.arenapoints - curArena)
    cmdProc:SendChatMessage(".mod money "..db.money - curMoney)

    if warnings.kills.isRestoreKills then
        cmdProc:SendChatMessage(".debug setvalue 1517 "..db.honorableKills)
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
    -- "|cff0070dd|Hitem:31203:0:0:0:0:0:-41:33|h[Arcane Loop of the Beast]|h|r"
    -- Hitem:31052:425:525:525:525:525:0:0
    -- linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest
    
    return string.match(link,".*Hitem:(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+):(-?%d+).*")
end

function Restorer:_sendItemsForRestore()
    if self._itemsForRestore > 0 then
        cmdProc:SendChatMessage(string.format(".send items %%t \"%s\" \"%s\" %s", self._itemsMsgTitle, self._itemsMsgTitle, self._itemsCmdForRestore))
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
    cmdProc:SendChatMessage(string.format(".send items %%t \"Bags\" \"Bags\" %s", cmd))

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
        cmdProc:SendChatMessage(string.format(".mod rep %d %d", k, v.earnedValue))
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

    if maxValue < 150 then
        rank = 1
    elseif maxValue < 225 then
        rank = 2
    elseif maxValue < 300 then
        rank = 3
    elseif maxValue < 375 then
        rank = 4
    end

    return rank
end

function Restorer:restoreSkills(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    local db = self._db.skills

    for k,v in pairs(db) do 
        local rank = self:_getProfessionRank(v.maxValue)

        -- Poisons, Lockpicking and weapons/defense skills
        if v.skillId == 40 or v.skillId == 633 or DB.Skills[v.skillId].categoryId == 6 then 
            rank = 1
        end

        local spells = professionSpells[v.skillId]

        if spells then
            local ok = false
            
            if spells.cast and spells.cast[rank] then
                cmdProc:SendChatMessage(".cast "..spells.cast[rank])
                ok = true
            end

            if spells.learn and spells.learn[rank] then
                cmdProc:SendChatMessage(".learn "..spells.learn[rank])
                ok = true
            end
                
            if not ok then
                self:_error(string.format("[%d] Bad profession spell for rank %d", v.skillId, rank))
                return
            end
        end
        
        if not (v.skillId == 762) then -- No need to update skill for Riding
            cmdProc:SendChatMessage(string.format(".setskill %d %d %d", v.skillId, v.value, v.maxValue))
        end
    end

    self:_on_restoreFinished()
end

-- =================
-- Spells
-- =================

function Restorer:getSpellsInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    if not self._db.spells then
        return false, "Spells info is empty"
    end

    for k,v in pairs(self._db.spells) do 
        if not _isValidInteger(v, 0) then
            return false, string.format("Bad spec spell id: %s", tostring(v))
        end
    end

    return true, #self._db.spells.." non trainer spells"
end

function Restorer:_restoreSpells(spells)
    for k,v in pairs(spells) do 
        cmdProc:SendChatMessage(".learn "..v)
    end
end

function Restorer:restoreSpells(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    if self._db.spells then
        self:_restoreSpells(self._db.spells)
    end

    self:_on_restoreFinished()
end

-- =================
-- Profession specializations
-- =================

function Restorer:getSpecsInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    if not self._db.specs then
        return false, "Specs info is empty"
    end

    for k,v in pairs(self._db.specs) do 
        if not _isValidInteger(v, 0) then
            return false, string.format("Bad spec spell id: %s", tostring(v))
        end
    end

    return true, #self._db.specs.." specializations"
end

function Restorer:restoreSpecs(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    if self._db.specs then
        self:_restoreSpells(self._db.specs)
    end

    self:_on_restoreFinished()
end

-- =================
-- Recipes
-- =================

function Restorer:getRecipesInfo()
    if not self._db then
        return false, "Initializing error!"
    end

    -- VALIDATE

    if not self._db.recipes then
        return false, "Recipes info is empty"
    end

    for k,v in pairs(self._db.recipes) do 
        if not _isValidInteger(v, 0) then
            return false, string.format("Bad recipe spell id: %s", tostring(v))
        end
    end

    return true, #self._db.recipes.." recipes"
end

function Restorer:restoreRecipes(warnings, callbackObj, successCallback, errorCallback)
    self:_registerOutput(callbackObj, successCallback, errorCallback)

    if self._db.recipes then
        self:_restoreSpells(self._db.recipes)
    end

    self:_on_restoreFinished()
end