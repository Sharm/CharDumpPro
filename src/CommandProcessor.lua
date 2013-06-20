
CommProc = {}

local sheduler = Sheduler:create(0)

function CommProc:create(callbackObj, executedCallback, errorCallback)
    local object = {} 
    setmetatable(object, self) 
    self.__index = self

    object._sheduler = Sheduler:create(0)
    object._isError = false
    object._errorCallback = errorCallback
    object._executedCallback = executedCallback
    object._callbackObj = callbackObj

    object:enableErrorCatching()
    return object
end

function CommProc:enableErrorCatching()
    self._isError = false
    Addon:RegisterEvent("CHAT_MSG_SAY", function() self:_on_CHAT_MSG_SAY() end)
    Addon:RegisterEvent("CHAT_MSG_SYSTEM", function() self:_on_CHAT_MSG_SYSTEM() end)
end

function CommProc:disableErrorCatching()
    Addon:UnregisterEvent("CHAT_MSG_SAY")
    Addon:UnregisterEvent("CHAT_MSG_SYSTEM")
end

function CommProc:SendChatMessage(text)
    self._sheduler:shedule(function() 
        if not self._isError then
            local myname = UnitName("player")
            local targetname = UnitName("target")
            if myname ~= targetname then
                self._error("ERROR: Target self first!")
                return
            end
            --Addon:Print("Execute command: "..text)
            self._executedCallback(self.callbackObj, text)
            SendChatMessage(text, "SAY")
        end
    end, self, text)
end

function CommProc:_error(text)
    self._isError = true
    self.errorCallback(self.callbackObj, text)
end

function CommProc:_on_CHAT_MSG_SAY()
    local msg = arg1
    local sender = arg2
    
    local myname = UnitName("player")
    if sender == myname and string.match(msg, "^%..+") then
        self._error("Errors occures while execute GM commands.")
    end
end

function CommProc:_on_CHAT_MSG_SYSTEM()
    local msg = string.lower(arg1)

    if     string.find(msg, "incorrect", 0, true)
        or string.find(msg, "there is no such", 0, true)
        or string.find(msg, "not found", 0, true)
        or string.find(msg, "invalid", 0, true)
        or string.find(msg, "syntax", 0, true)
    then
        self._error("Errors occures while execute GM commands.")
    end
end