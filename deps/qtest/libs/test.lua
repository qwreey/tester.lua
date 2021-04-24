local module = {};


--머리터짐
function module:init(private)
    local this = {};

    local function test(isPass)
        if not private.nowThing then

        elseif not private.isRunning then

        elseif not private.nowIt then

        end

        if isPass then
            private.nowIt.pass =
                private.nowIt.pass + 1;
        else -- when failed
            if private.nowIt.isPass then
                private.nowThing.__thing__.itPass =
                    private.nowThing.__thing__.itPass - 1;
                private.nowThing.__thing__.itFail =
                    private.nowThing.__thing__.itFail + 1;
            end
            private.nowThing.__thing__.isPass = false;
            private.nowIt.isPass = false;
            private.nowIt.fail =
                private.nowIt.fail + 1;
        end

        return isPass;
    end

    -- check the thing is boolean
    function this.isBoolean(thing)
        return test(
            type(thing) == "boolean"
        );
    end

    -- check the thing is number
    function this.isNumber(thing)
        return test(
            type(thing) == "number"
        );
    end

    -- check the thing is string
    function this.isString(thing)
        return test(
            type(thing) == "string"
        );
    end

    -- check the thing is table
    function this.isTable(thing)
        return test(
            type(thing) == "table"
        );
    end

    -- check the this is function
    function this.isFunction(thing)
        return test(
            type(thing) == "function"
        );
    end

    -- check the thing is not nil
    function this.isExist(thing)
        return test(
            thing ~= nil
        );
    end

    -- run function and cahtches error
    function this.checkError(func,...)
        local pass = pcall( func(...) );
        return test(pass);
    end

    -- nothing do
    function this.nop()
        return test(true);
    end

    return this;
end

return module;