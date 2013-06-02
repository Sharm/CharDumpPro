-- Author: for.sneg@gmail.com

-- ATTENSION! Asynchronus work!

Restorer = { 
	_db = nil, -- reference to save table for current char
    _isErrorCatching = false,
    _isError = false,
    _timerFrame = CreateFrame("frame"),
    _timerCounter = 0,
    errorCallback = nil,
    successCallback = nil,
    callbackObj = nil
}

-- TODO: Move timer code to separate class/file and extend its functionality

function Restorer:startTimer(func, delay, isSingleShot)
    isSingleShot = true -- now only single shot timers supported

    self._timerFrame:SetScript("OnUpdate", function(frame, elapsed) 
        self._timerCounter = self._timerCounter + elapsed
        if self._timerCounter > delay then
            func()
            self._timerCounter = 0
            if isSingleShot then
                self._timerFrame:SetScript("OnUpdate", nil)
            end
        end
    end)
end

local function _isValidInteger(value, low, high)
    return type(value) == "number" and (low == nil or value > low) and (high == nil or value < high)
end

local function _isValidString(value, count)
    return type(value) == "string" and (count == nil or #value > count)
end

function Restorer:_SendChatMessage(text)
    if not self.cmdError then
        local myname = UnitName("player")
        local targetname = UnitName("target")
        if myname ~= targetname then
            self._isError = true
            self.errorCallback(self.callbackObj, "Target self first!")
            return
        end
        SendChatMessage(text, "SAY")
    end
end

function Restorer:_enableErrorCatching()
    self._isError = false
    self._isErrorCatching = true
end

function Restorer:_disableErrorCatching()
    self._isErrorCatching = false
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
            self._isError = true
            self.errorCallback(self.callbackObj, "Errors occures while execute GM commands.")
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
            self._isError = true
            self.errorCallback(self.callbackObj, "Errors occures while execute GM commands.")
        end

    end
end

function Restorer:_on_restoreFinished()
    if not self._isError then
        self.successCallback(self.callbackObj)
    end
    self:_disableErrorCatching()
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

    self:_SendChatMessage(".level "..db.level)
    self:_SendChatMessage(".mod honor "..db.honor)
    self:_SendChatMessage(".mod arena "..db.arenapoints)
    self:_SendChatMessage(".mod money "..db.money)

    if warnings.kills.isRestoreKills then
        self:_SendChatMessage(".debug setvalue 1517 "..db.honorableKills)
    end

    self:startTimer(function() self:_on_restoreFinished() end, 3)
end

-- =================
-- Inventory
-- =================

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
