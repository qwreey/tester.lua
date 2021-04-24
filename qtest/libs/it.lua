local module = {};
local private,global;

function module:init(private)
    local function typeCheck(description,testFunc)
    end

    return function (description,testFunc)
        private.it = description;
        testFunc();
    end;
end

return module;