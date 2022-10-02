local module = {};

-- CLASS : testItem
local testItemMT = {};
function testItemMT:say(funcOrStr)
    local debug = self.debugInfo or debug.getinfo(2);
    self.debugInfo = debug;
    table.insert(
        self.thisIt.say,
        ("[MSG Line : %d] %s"):format(
            debug.currentline,
            (type(funcOrStr) == "string" and funcOrStr or (funcOrStr(self)))
        )
    );
    return self;
end

function testItemMT:failMsg(funcOrStr)
    if not self.value then
        return self:say(funcOrStr);
    end
    return self;
end
testItemMT.__index = testItemMT;

-- CLASS : module
function module:init(private)
    local this = {};

    local waitForEnter = private.waitForEnter;
    local termColor = require("termColor");
    local red = termColor.new(termColor.names.red);

    local function test(isPass)
        local nowIt = private.nowIt;
        local debugInfo;

        if not private.isRunning then
            private.print(red("[ERROR]" .. " test is not running!"));
            --waitForEnter();
        elseif not nowIt then
            private.print(red("[ERROR]" .. " it is not exist!"));
            --waitForEnter();
        end

        if isPass then
            nowIt.pass = nowIt.pass + 1;
        else
            nowIt.fail = nowIt.fail + 1;
            nowIt.isPass = false;
            debugInfo = debug.getinfo(2);
            table.insert(nowIt.debugInfos,debugInfo);
        end

        local testItem = {
            debugInfo = debugInfo;
            value = isPass;
            thisIt = private.nowIt;
        };
        setmetatable(testItem,testItemMT);
        return testItem;
    end

    -- check the thing is boolean
    function this.isBoolean(val)
        return test(type(val) == "boolean");
    end

    -- check the thing is number
    function this.isNumber(val)
        return test(type(val) == "number");
    end

    -- check the thing is string
    function this.isString(val)
        return test(type(val) == "string");
    end

    -- check the thing is table
    function this.isTable(val)
        return test(type(val) == "table");
    end

    -- check the this is function
    function this.isFunction(val)
        return test(type(val) == "function");
    end

    -- check the thing is not nil
    function this.isExist(val)
        return test(val ~= nil);
    end

    -- run function and cahtches error
    function this.checkError(func,...)
        local pass = pcall(func, ...);
        return test(pass);
    end

    -- nothing do
    function this.nop()
        return test(true);
    end

    function this.isTrue(val)
        return test(val == true);
    end

    function this.isFalse(val)
        return test(val == false);
    end

    function this.isNil(val)
        return test(val == nil);
    end

    function this.equals(val1,val2)
        return test(val1 == val2);
    end

    function this.tableSame(table1,table2)
        local isPass = true;
        for i,v in pairs(table1) do
            if not table2[i] == v then
                isPass = false;
                break;
            end
        end
        if isPass then
            for i,v in pairs(table2) do
                if not table1[i] == v then
                    isPass = false;
                    break;
                end
            end
        end
        return test(isPass);
    end

    return this;
end

return module;
