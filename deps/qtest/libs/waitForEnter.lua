local module = {};

function module:init(io,print)
    return function ()
        print("\n [Enter for continue ...]\n");
        return io.read();
    end;
end

return module;