local module = {};
local private;

function module:init(nprivate)
    private = nprivate;
    return function (...)
        local tests = {...};
        for index,test in pairs(tests) do
        end
    end;
end

return module;