local module = {};
local private,global;

function module:init(private)
    local global = private.global;

    local function typeCheck(description,testFunc)
    end

    return function (description,testFunc)
        private.it = description;
        testFunc(global);
    end;
end

return module;