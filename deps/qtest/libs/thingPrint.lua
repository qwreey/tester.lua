local thingText = "%sThing '%s'";
local itText = "%s%%s %s%%%%s | %%%%s%%%%%%%%s | %%%%%%%%s";
local itMsg = "%s%s"
local tab = " |  ";
local tree = " |- ";
local none = ""

local printLineFromFile = require("printLineFromFile");
local termColor = require("termColor");
local bgRed = termColor.new(termColor.names.onred);
local red = termColor.new(termColor.names.red);
local green = termColor.new(termColor.names.green);
local yellow = termColor.new(termColor.names.yellow);
local itPassText = green("[PASS]");
local itFailText = red("[FAIL]");
local thingPassText = green("--- Test passed! (Total it passed : %d)");
local thingFailText = red("--- Test failed! (Total it failed : %d)");

local function thingPrint(print,thing,DEEP,printTable,private)
    local waitForEnter = private.waitForEnter;
    DEEP = DEEP or 0; -- deep of this function loop
    printTable = printTable or {debugInfos = {},longest = 0}; -- if print table is not exist, make one

    table.insert(printTable, -- render now thing header (Thing : 'luvit')
        thingText:format(string.rep(tab,DEEP-1) .. (DEEP == 0 and none or tree),thing.__thing__.name)
    );

    for _,it in ipairs(thing) do -- loop for it items
        table.insert(printTable.debugInfos,it.debugInfos); -- add debuginfo for debug files

        -- render it item ( |- [PASS] has string library? | Pass : 1 | 0s)
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

        -- render msg ( |- [MSG Line : 32] test say)
        for _,text in pairs(it.say) do
            table.insert(printTable,itMsg:format(string.rep(tab,DEEP+1) .. tree,text));
        end
    end

    -- render child
    for _,childThing in ipairs(thing.__children__) do -- loop for child things
        thingPrint(print,childThing,DEEP + 1,printTable,private); -- recursion for thing (child)
    end

    -- last redner
    if DEEP == 0 then -- print all
        table.insert(printTable,thing.__thing__.isPass and
            (thingPassText:format(thing.__thing__.itPass)) or
            (thingFailText:format(thing.__thing__.itFail))
        );
        table.insert(printTable,"");
        local longestCountTextLen = 0;
        local thingPass = true;
        for i,v in ipairs(printTable) do -- format 1
            if i ~= 1 and i ~= #printTable and type(v) == "table" then
                local isPass = v.it.isPass
                if not isPass then
                    thingPass = false;
                end
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
        if not (private.disableViewCode or thingPass or string.lower(waitForEnter("[Test failed, type 'y' for show fail point of code or press enter for skip ...]")) ~= "y") then
            print("------------------Fail Points------------------");
            print("");
            for _,debugInfos in ipairs(printTable.debugInfos) do -- print debugInfos
                if #debugInfos ~= 0 then
                    print(("--- Failed on %s : %s"):format(debugInfos.thingName,debugInfos.itName));
                end
                for _,debugInfo in ipairs(debugInfos) do
                    local source = string.sub(debugInfo.source,2,-1);
                    local file do
                        file = private.files[source];
                        if not file then
                            local readFile = io.open(source,"r");
                            if readFile then
                                file = {};
                                private.files[source] = file;
                                for line in readFile:lines() do
                                    table.insert(file, line)
                                end
                            end
                        end
                    end
    
                    if file then
                        local cur = debugInfo.currentline;
                        local maxcur = cur + 2
                        print((" |  FILE : %s"):format(source));
                        for i = -2,2 do
                            printLineFromFile(
                                print,cur + i,maxcur,file,
                                i == 0 and bgRed
                            );
                        end
                    else
                        print(
                            yellow("[WARN]") ..
                            (" File %s was not found, bypassed open/debugging!")
                                :format(debugInfo.source)
                        );
                    end
                    print("");
                end
            end
            print("-----------------------------------------------");
            print("");
        end
    end
end

return thingPrint;