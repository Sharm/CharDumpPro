
CommProc = {}

function CommProc:create(sheduler)
    local object = {} 
    setmetatable(object, self) 
    self.__index = self

    local delay = nil
    if type(sheduler) == "number" then
        delay = sheduler
        sheduler = nil
    end

    ---- Declaration
    object._sheduler = sheduler or Sheduler:create(delay or 0.1)
    object._isError = false
    object._errorCallback = nil
    object._callbackObj = nil
    ----

    object:enableErrorCatching()
    return object
end

function CommProc:registerOutput(callbackObj, errorCallback)
    self._errorCallback = errorCallback
    self._callbackObj = callbackObj
    self:enableErrorCatching()
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
    if not self._isError then
        local myname = UnitName("player")
        local targetname = UnitName("target")
        if myname ~= targetname then
            self:_error("Target self first!")
            return
        end

        self._sheduler:shedule(function() 
            -- Check isError again, that right
            if not self._isError then
                Addon:Print("Execute command: "..text)
                SendChatMessage(text, "SAY")
            end
        end, self, text)
    end
end

function CommProc:sheduleSuccessFunction(obj, func)
    self._sheduler:shedule(function() 
        if not self._isError then
            func(obj)
        end
        self:disableErrorCatching()
    end, self)
end

function CommProc:_error(text)
    self._isError = true
    self._errorCallback(self._callbackObj, text)
end

function CommProc:_on_CHAT_MSG_SAY()
    local msg = arg1
    local sender = arg2
    
    local myname = UnitName("player")
    if sender == myname and string.match(msg, "^%..+") then
        self:_error("Errors occures while execute GM commands.")
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
        self:_error("Errors occures while execute GM commands.")
    end
end