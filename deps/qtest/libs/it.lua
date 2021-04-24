local module = {};
local clock = os.clock;

function module:init(private)
    local status = private.status;
    local waitForEnter = private.waitForEnter;
    local termColor = require("termColor");
    local red = termColor.new(termColor.names.red);

    local function typeCheck(itName,testFunc)
        if not private.isRunning then
            (private.print or print)(red("[WARN]") .. "Test is not running! qtest.run(print); first for run test!");
            waitForEnter();
        end

        if not private.nowThing then
            private.print("lastThing is not exist! qtest.thing(testname,func); for run it test!");
            waitForEnter();
        end

        if string.sub(itName,1,2) == "__" then
            private.print("It name cannot be starting with '__'!");
            waitForEnter();
        end

        if private.nowIt then
            private.print("you cannot run it function on it is running! continue?");
            waitForEnter();
        end
    end

    return function (itName,testFunc)
        typeCheck(itName,testFunc);
        local nowThing = private.nowThing;

        -- make it
        local nowIt = {isPass = true,pass = 0,fail = 0,name = itName}; -- make new it
        private.nowIt = nowIt; -- set now it to this it
        nowThing[#nowThing + 1] = nowIt; -- set parent of it
        nowThing.__thing__.itPass = nowThing.__thing__.itPass + 1;

        local st = clock();
        local pass,errmsg = pcall(testFunc); -- call it
        if not pass then
            private.print(red("[ERROR] ") .. errmsg);
            private.print(red("[ERROR]") .. (" run error occur on testing it '%s' ... continue?")
                :format(itName));
            waitForEnter();
        end
        local ed = clock();
        nowIt.time = math.floor((ed - st)*10000)/10000;
        private.nowIt = nil;
        return;
    end;
end

return module;