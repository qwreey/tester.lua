local module = {};

function module:init(private)
    local global = private.global;
    return function (func)
        return func(global);
    end;
end

return module;