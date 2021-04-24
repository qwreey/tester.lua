local module = {};
local private,global;

function module:init(private)
    local function typeCheck(description,testFunc)
        local typeDescription = type(description);
        if typeDescription ~= "string" then
            error(("[it] : arg1 description must be string, got %s"):format(typeDescription));
        end

        local typeTestFunc = type(testFunc);
        if typeTestFunc ~= "function" then
            error(("[it] : arg2 description must be string, got %s"):format(typeDescription))
        end
    end

    return function (description,testFunc)
        private.it = description;
        testFunc();
    end;
end

return module;