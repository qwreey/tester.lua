local module = {};

function module:init(private)
    local termColor = require("termColor");
    local red = termColor.new(termColor.names.red);
    local green = termColor.new(termColor.names.green);

    local perBarLen = 37;
    local perBar = "#"
    local function drowPerBar(per)
        per = per/100
        local front = string.rep(perBar,math.floor((perBarLen * per) + 0.5));
        local back = string.rep(perBar,perBarLen - #front);

        return green(front) .. red(back);
    end

    local function getPer(max,var)
        return var/max * 100;
    end

    local function perToStr(per)
        local per = math.floor(per*100)/100;
        local str = tostring(per);

        local len = #tostring(math.floor(per));
        str = str .. string.rep("\32",3 - len);

        local point = per % 1;
        if point == 0 then
            str = str .. ".00";
        elseif #tostring(point) == 1 then
            str = str .. "0";
        end
        return str .. "%";
    end

    return function(print)
        print = print or private.print;
        if not print then
            error("printfn was not found! add print for function arg to fix this");
        end
        print("-------------------Test End!-------------------");

        -- drow total thing per
        local totalThingPass = private.totalThingPass;
        local totalThingFail = private.totalThingFail;

        local totalThingPer = getPer(
            totalThingFail + totalThingPass,totalThingPass
        );
        local totalThingPerStr = perToStr(totalThingPer);
        print(("%s : %s"):format(
            totalThingPerStr,drowPerBar(totalThingPer)
        ));
        print(("Total thing pass : %d"):format(totalThingPass));
        print(("Total thing fail : %d"):format(totalThingFail));
        print("");

        -- drow total it per
        local totalItPass = private.totalItPass;
        local totalItFail = private.totalItFail;

        local totalThingPer = getPer(
            totalItPass + totalItFail,totalItPass
        );
        local totalThingStr = perToStr(totalThingPer);
        print(("%s : %s"):format(
            totalThingStr,drowPerBar(totalThingPer)
        ));
        print(("Total it pass : %d"):format(totalItPass));
        print(("Total it fail : %d"):format(totalItFail));
        print("-----------------------------------------------");
    end
end

return module;