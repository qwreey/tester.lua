local module = {};

function module:init(io,print)
    return function (q)
        print(q or "[Enter for continue or Ctrl+C for cancel ...]");
        io.write("Test > ");
        return io.read();
    end;
end

return module;