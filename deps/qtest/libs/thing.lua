local module = {};

-- thing = {
--     __thing__ = {
--         asdf
--     };
--     __children__ = {
--         child thing ...
--     };
--     it ...
-- };


-- TODO: 이거 깃헙에 올릴꺼라 한국어 쓰면 안됨, **싹 다 영어로 바꾸기**
-- TODO: Igno 만들기 (아무 테스트도 없는경우)

function module:init(private)
    local status = private.status; -- test status holder
    local waitForEnter = private.waitForEnter;
    local termColor = require("termColor");
    local red = termColor.new(termColor.names.red);
    local thingPrint = require("thingPrint");

    local function typeCheck(testThing,runFunc)
        if not private.isRunning then
            (private.print or print)(red("[WARN]") .. " Test is not running! qtest.run(print); first for run test!");
            waitForEnter();
        end

        local typeTestThing = type(testThing);
        if typeTestThing ~= "string" then
            error(("[describe] : arg1 testThing must be string, got %s"):format(typeTestThing));
        elseif private.thingNow and private.thingNow[testThing] or status[testThing] then
            error("unit %s already exists (describe : testThing already exists)");
        end

        local typeRunFunc = type(runFunc);
        if typeRunFunc ~= "function" then
            error(("[describe] : arg2 runFunc must be function, got %s"):format(typeRunFunc));
        end
    end

    ---@param testThingName string Test thing name
    ---@param runFunc function Test function
    ---@return nil void
    return function(testThingName,runFunc) -- add test stack function
        typeCheck(testThingName,runFunc); -- check args
        
        -- make thing
        local lastThing = private.nowThing; -- get last test thing
        local thisThing = {
            __thing__ = {
                name = testThingName;
                isPass = true;
                itPass = 0;
                itFail = 0;
            },
            __children__ = {},
        }; -- make new test thing
        private.nowThing = thisThing; -- set nowThing to this thing
        (lastThing and lastThing.__children__ or status)[
            lastThing and (#lastThing.__children__ + 1) or testThingName] = thisThing; -- set parent of this thing

        -- run test func
        local pass,errmsg = pcall(runFunc); -- run test
        if not pass then
            errmsg = errmsg or "none";
            thisThing.__thing__.hasErrorOnTesting = true;
            thisThing.__thing__.pass = false;
            thisThing.__thing__.errmsg = errmsg;

            private.print(red("[ERROR] ") .. errmsg);
            private.print(red("[ERROR]") .. (" run error occur on testing thing '%s' ... continue?")
                :format(testThingName));
            waitForEnter();
        end

        -- set total thing pass/fail
        if thisThing.__thing__.isPass then
            private.totalThingPass = private.totalThingPass + 1;
        else
            private.totalThingFail = private.totalThingFail + 1;
        end
        if lastThing then
            -- set parent status
            lastThing.__thing__.isPass = lastThing.__thing__.isPass and thisThing.__thing__.isPass;
            lastThing.__thing__.itPass = lastThing.__thing__.itPass + thisThing.__thing__.itPass;
            lastThing.__thing__.itFail = lastThing.__thing__.itFail + thisThing.__thing__.itFail;
        else
            -- print thing status
            private.totalItPass = private.totalItPass + thisThing.__thing__.isPass;
            private.totalItFail = private.totalItFail + thisThing.__thing__.itFail;
            thingPrint(private.print,thisThing);
        end

        -- reset
        private.nowThing = lastThing; -- set thing to last thing
        return; -- return
    end;
end

return module;