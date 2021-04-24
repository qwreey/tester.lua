local module = {};

function module:init(private)
    local testStack = private.testStack; -- test stack holder
    local status = private.status; -- test status holder

    local function typeCheck(testThing,runFunc)
        local typeTestThing = type(testThing);
        if typeTestThing ~= "string" then
            error(("[describe] : arg1 testThing must be string, got %s"):format(typeTestThing));
        elseif status[testThing] then
            error("unit %s already exists (describe : testThing already exists)");
        end
    
        local typeRunFunc =  type(runFunc);
        if typeRunFunc ~= "function" then
            error(("[describe] : arg2 runFunc must be function, got %s"):format(typeRunFunc));
        end
    end

    ---@param testThingName string Test thing name
    ---@param runFunc function Test function
    ---@return nil void
    return function(testThingName,runFunc) -- add test stack function
        typeCheck(testThingName,runFunc); -- check args
        local nowStatus = {}; -- make status table
        status[testThingName] = nowStatus; -- add status table
        private.nowStatus = nowStatus; -- set status to now status
        local lastTest = testStack[1]; -- get last test range
        table.insert(private.testStack,testThingName); -- add stack (this)
        private.testNow = testStack; -- set test range to this
        runFunc(testThingName); -- run test
        private.testNow = lastTest; -- set test range to last
        table.remove(private.testStack); -- remove stack (this)
        return; -- return
    end;
end

return module;