local module = {};

function module:init(private)
    local termColor = require("termColor");
    local green = termColor.new(termColor.names.green);

    return function (print)
        print = print or private.print or function (...)
            local items = {...};
            local str = "";
            for _,v in ipairs(items) do
                str = str .. v .. "\32";
            end
            io.write(str .. "\n");
        end;
        print("------------------Test Start!------------------");
        print(green("Time") .. " : " .. os.date());
        print(green("TestName") .. " : " .. private.testProfile);
        print("");
        private.print = print;
        private.isRunning = true;
        return;
    end;
end

return module;