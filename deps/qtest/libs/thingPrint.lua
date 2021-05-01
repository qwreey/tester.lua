local thingText = "%sThing '%s'";
local itText = "%s%%s %s%%%%s | %%%%s%%%%%%%%s | %%%%%%%%s";
local tab = string.rep("\32",4);
local tree = " |- ";
local none = ""

local termColor = require("termColor");
local red = termColor.new(termColor.names.red);
local green = termColor.new(termColor.names.green);
local itPassText = green("[PASS]");
local itFailText = red("[FAIL]");
local thingPassText = green("--- Test passed! (Total it passed : %d)\n");
local thingFailText = red("--- Test failed! (Total it failed : %d)\n");

local function thingPrint(print,thing,DEEP,printTable)
    DEEP = DEEP or 0;
    printTable = printTable or {longest = 0};
    -- thing print
    table.insert(printTable,
        thingText:format(string.rep(tab,DEEP-1) .. (DEEP == 0 and none or tree),thing.__thing__.name)
    );

    -- item
    for _,it in ipairs(thing) do
        local new = {
            text = itText:format(
                string.rep(tab,DEEP) .. tree,
                it.name
            );
            it = it;
        };
        local len = utf8.len(new.text);
        new.len = len;
        new.text = new.text:format(it.isPass and itPassText or itFailText)
        if printTable.longest < len then
            printTable.longest = len;
        end
        
        table.insert(printTable,new);
    end

    for _,childThing in ipairs(thing.__children__) do
        thingPrint(print,childThing,DEEP + 1,printTable);
    end

    if DEEP == 0 then
        table.insert(printTable,thing.__thing__.isPass and
            (thingPassText:format(thing.__thing__.itPass)) or
            (thingFailText:format(thing.__thing__.itFail))
        );
        local longestCountTextLen = 0;
        for i,v in ipairs(printTable) do
            if i ~= 1 and i ~= #printTable and type(v) == "table" then
                local isPass = v.it.isPass
                local count = (isPass and "Pass : " or "Fail : ") .. tostring(isPass and v.it.pass or v.it.fail);
                local len = #count
                longestCountTextLen = (longestCountTextLen < len)
                    and len or longestCountTextLen;
                v.text = v.text:format(
                    string.rep("\32",printTable.longest - v.len),
                    (isPass and green or red)(count)
                );
                v.len = len;
            end
        end
        for i,v in ipairs(printTable) do
            if i ~= 1 and i ~= #printTable and type(v) == "table" then
                print(v.text:format(
                    string.rep("\32",longestCountTextLen - v.len),
                    (tostring(v.it.time) .. "s")
                ));
            else
                print(v);
            end
        end
    end
end

return thingPrint;