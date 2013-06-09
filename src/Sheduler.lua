-- Author: for.sharm@gmail.com

Sheduler = {

    _time = 0,
    _delay = 0.5,
    _frame = CreateFrame("frame"),
    _stepByStepMode = false,

    create = function(self, delay, stepByStepMode)
        self._delay = delay
        self._stepByStepMode = stepByStepMode or false
        self._frame.obj = self
        self:enable()
        return self
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
        --Addon:Print("Shedule func "..tostring(info.func))
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
                    --Addon:Print(k.." "..table.tostring(v))
                    v.time = v.time + elapsed
                    if v.time > v.timeout then
                        v = nil
                        self._conditions[k] = nil
                    end
                end
                if v then
                    --Addon:Print("Blocked by "..k)
                    return
                end
            end

            if #self._sheduledFunctions == 0 or not self._sheduledFunctions[1].func or not self._isNextStep then
                return
            end

            --Addon:Print("Exec "..tostring(self._sheduledFunctions[1].func))
                
            self._sheduledFunctions[1].func(unpack(self._sheduledFunctions[1].arg))
            table.remove(self._sheduledFunctions, 1)
            
            self._time = 0

            if self._stepByStepMode then
                self._isNextStep = false
            end
        end
    end
}

Sheduler:create(0.1)