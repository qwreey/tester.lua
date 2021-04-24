local module = {};

function module:init(private)
    local testStack = private.testStack; -- test stack holder
    local status = private.status; -- test status holder
    local logger = private.logger;

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

        -- status table init
        local nowStatus = {__i = {}}; -- make status table
        status[testThingName] = nowStatus; -- add status table
        private.nowStatus = nowStatus; -- set status to now status

        -- test thing handle
        local lastTest = private.nowStatus; -- get last test thing
        private.testNow = testStack; -- set test thing to this

        -- run test
        local pass,errmsg = pcall(runFunc(testThingName)); -- run test
        if pass then
            nowStatus.__i.hasError = true;
            
        end
        private.testNow = lastTest; -- set test thing to last
        return; -- return
    end;
end

return module;