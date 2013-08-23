-- Author: for.sharm@gmail.com
local debug = false
local debug_blocked = false

Sheduler = {

    _time = 0,
    _delay = 0.5,
    _stepByStepMode = false,

    create = function(self, delay, stepByStepMode)
        local object = {} 
        setmetatable(object, self) 
        self.__index = self
        object._delay = delay
        object._stepByStepMode = stepByStepMode or false
        object._frame = CreateFrame("frame")
        object._frame.obj = object
        object:enable()
        return object
    end,
    
    enable = function(self)
        self._conditions = {}
        self._sheduledFunctions = {}
        self._isNextStep = true
        self._frame:SetScript("OnUpdate", self._onUpdate)
    end,

    disable = function(self)
        self._frame:SetScript("OnUpdate", nil)
    end,
    
    shedule = function(self, func, ...)
        local info = {
            func = func,
            arg = {...}
        }
        if debug then
            Addon:Print("Shedule func "..tostring(info.func))
        end
        table.insert(self._sheduledFunctions, info)
    end,

    next = function(self)
        self._isNextStep = true
    end,

    continue = function(self, conditionName)
        if self._conditions[conditionName] then
            self._conditions[conditionName] = nil
        end
    end,

    stop = function(self, conditionName, timeout)
        self._conditions[conditionName] = {
            timeout = timeout,
            time = 0
        }
    end,
    _onUpdate = function(frame, elapsed)
        self = frame.obj

        self._time = self._time + elapsed
        if self._time > self._delay then

            -- Check conditions
            for k,v in pairs(self._conditions) do
                if v and v.timeout then
                    if debug then
                        Addon:Print(k.." "..table.tostring(v))
                    end
                    v.time = v.time + elapsed
                    if v.time > v.timeout then
                        v = nil
                        self._conditions[k] = nil
                    end
                end
                if v then
                    if debug and not debug_blocked then
                        debug_blocked = true
                        Addon:Print("Blocked by "..k)
                    end
                    return
                end
            end

            if #self._sheduledFunctions == 0 or not self._sheduledFunctions[1].func or not self._isNextStep then
                return
            end

            if debug then
                Addon:Print("Exec "..tostring(self._sheduledFunctions[1].func))
                debug_blocked = false
            end
                
            self._sheduledFunctions[1].func(unpack(self._sheduledFunctions[1].arg))
            table.remove(self._sheduledFunctions, 1)
            
            self._time = 0

            if self._stepByStepMode then
                self._isNextStep = false
            end
        end
    end
}