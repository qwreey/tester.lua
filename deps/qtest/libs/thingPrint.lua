local thingText = "%sThing '%s'";
local itText = "%s%%s %s%%%%s | %%%%s%%%%%%%%s | %%%%%%%%s";
local itMsg = "%s%s"
local tab = " |  ";
local tree = " |- ";
local none = ""

local termColor = require("termColor");
local red = termColor.new(termColor.names.red);
local green = termColor.new(termColor.names.green);
local yellow = termColor.new(termColor.names.yellow);
local itPassText = green("[PASS]");
local itFailText = red("[FAIL]");
local thingPassText = green("--- Test passed! (Total it passed : %d)");
local thingFailText = red("--- Test failed! (Total it failed : %d)");

local codeViewMaxLen = 47;
local function printLineFromFile(print,pos,maxpos,file)
    local lineTextLen = #tostring(maxpos);
    local lineText = tostring(pos);
    local codeText = file[pos];
    if not codeText then
        
    end
    lineText = lineText .. string.rep("\32",lineTextLen - #lineText) .. "| ";
    local codeLen = codeViewMaxLen - (lineTextLen + 2);
    
end

local function thingPrint(print,thing,DEEP,printTable)
    DEEP = DEEP or 0;
    printTable = printTable or {debugInfos = {},longest = 0};
    -- thing print
    table.insert(printTable,
        thingText:format(string.rep(tab,DEEP-1) .. (DEEP == 0 and none or tree),thing.__thing__.name)
    );

    -- item
    for _,it in ipairs(thing) do
        table.insert(printTable.debugInfos,it.debugInfos);
        local new = {
            type = "itItem";
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

        for _,text in pairs(it.say) do
            table.insert(printTable,itMsg:format(string.rep(tab,DEEP+1) .. tree,text));
        end
    end

    for _,childThing in ipairs(thing.__children__) do
        thingPrint(print,childThing,DEEP + 1,printTable);
    end

    if DEEP == 0 then -- print all
        table.insert(printTable,thing.__thing__.isPass and
            (thingPassText:format(thing.__thing__.itPass)) or
            (thingFailText:format(thing.__thing__.itFail))
        );
        table.insert(printTable,"");
        local longestCountTextLen = 0;
        for i,v in ipairs(printTable) do -- format 1
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
        for i,v in ipairs(printTable) do -- format 2 and print
            if i ~= 1 and i ~= #printTable and type(v) == "table" then
                print(v.text:format(
                    string.rep("\32",longestCountTextLen - v.len),
                    (tostring(v.it.time) .. "s")
                ));
            else
                print(v);
            end
        end
        for _,debugInfos in ipairs(printTable.debugInfos) do -- print debugInfos
            if #debugInfos ~= 0 then
                print(("--- Failed on %s : %s"):format(debugInfos.thingName,debugInfos.itName));
            end
            for _,debugInfo in ipairs(debugInfos) do
                local file = io.open(debugInfo.source,"r");
                if file then
                    local cur = debugInfo.currentline;
                    local maxcur = cur + 2
                    local fileT = {};
                    for line in file:lines() do
                        table.insert(fileT, line)
                    end
                    file:close()
                    for i = -2,2 do
                        printLineFromFile(print,cur + i,maxcur,fileT);
                    end
                else
                    print(yellow("[WARN]") .. " File %s was not found, bypassed open/debugging!");
                end
                print("");
            end
        end
    end
end

return thingPrint;