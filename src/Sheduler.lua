-- Author: for.sneg@gmail.com

Sheduler = {

    _time = 0,
    _delay = 0.5,
    _frame = CreateFrame("frame"),
    _sheduledFunctions = {},
    _stepByStepMode = false,
    _isNextStep = true,
    _conditions = {},
    
    
    shedule = function(self, func, ...)
        local info = {
            func = func,
            arg = {...}
        }
        table.insert(self._sheduledFunctions, info)
    end,

    next = function(self)
        self._isNextStep = true
    end,

    continue = function(self, conditionName)
        if self._conditions[conditionName] then
            self._conditions[conditionName] = false
        end
    end,

    stop = function(self, conditionName)
        self._conditions[conditionName] = true
    end,
    
    create = function(self, delay, stepByStepMode)
        self._delay = delay
        self._stepByStepMode = stepByStepMode or false

        self._frame:SetScript("OnUpdate", function(frame, elapsed) 
            self._time = self._time + elapsed
            if self._time > self._delay then
                if #self._sheduledFunctions == 0 or not self._sheduledFunctions[1].func or not self._isNextStep then
                    return
                end
                
                -- Check conditions
                for k,v in pairs(self._conditions) do
                    if v then
                        return
                    end
                end
                
                self._sheduledFunctions[1].func(unpack(self._sheduledFunctions[1].arg))
                table.remove(self._sheduledFunctions, 1)
            
                self._time = 0
                if self._stepByStepMode then
                   self._isNextStep = false
                end
            end
        end)
        
        return self
    end
}

Sheduler:create(0.1)