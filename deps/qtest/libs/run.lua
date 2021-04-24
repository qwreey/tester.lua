local module = {};

function module:init(private)
    local termColor = require("termColor");
    local green = termColor.new(termColor.names.green);

    return function (print)
        print("----------------------------------------");
        print(green("Time") .. " : " .. os.date());
        print(green("TestName") .. " : " .. private.testProfile .. "\n");
        private.print = print;
        private.isRunning = true;
        return;
    end;
end

return module;