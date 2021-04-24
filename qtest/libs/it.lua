local module = {};
local private,global;

local function typeCheck(description,testFunc)
    
end

function module:init(nprivate)
    private = nprivate;
    global = private.global;

    return function (description,testFunc)
        private.it = description;
        
        testFunc(global);

    end;
end

return module;