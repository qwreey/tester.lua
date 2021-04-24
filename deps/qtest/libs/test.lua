local module = {};


--머리터짐
function module:init(private)
    local this = {}

    function module.isBoolean(thing)
        return type(thing) == "boolean";
    end

    function module.isNumber(thing)
        return type(thing) == "number";
    end

    function module.isString(thing)
        return type(thing) == "string";
    end

    function module.isTable(thing)
        return type(thing) == "table";
    end

    function module.isFunction(thing)
        return type(thing) == "function";
    end

    function module.isExist(thing)
        return thing ~= nil;
    end

    function module.hasError(func,...)
        local pass,errmsg = pcall( func(...) );

        return;
    end

    return this;
end

return module;