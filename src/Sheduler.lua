-- Author: for.sneg@gmail.com

Sheduler = {

    _time = 0,
    _delay = 0.5,
    _frame = CreateFrame("frame"),
    _sheduledFunctions = {},
    
    
    shedule = function(self, func, ...)
        local info = {
            func = func,
            arg = {...}
        }
        table.insert(self._sheduledFunctions, info)
    end,
    
    create = function(self, delay)
    
        self._frame:SetScript("OnUpdate", function(frame, elapsed) 
            self._time = self._time + elapsed
            if self._time > self._delay then
                if #self._sheduledFunctions == 0 or not self._sheduledFunctions[1].func then
                    return
                end
                
                Addon:Print("[Sheduler] execute function")
                
                self._sheduledFunctions[1].func(unpack(self._sheduledFunctions[1].arg))
                table.remove(self._sheduledFunctions, 1)
            
                self._time = 0
            end
        end)
        
        return self
    end
}

Sheduler:create(0.5)