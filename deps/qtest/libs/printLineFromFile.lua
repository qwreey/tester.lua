local codeViewMaxLen = 82;--47;
local function printLineFromFile(print,pos,maxpos,file,highlight)
    local lineTextLen = #tostring(maxpos);
    local lineText = tostring(pos);
    local codeText = file[pos];
    if not codeText then
        lineText = string.rep("\32",lineTextLen) .. "|";
    else
        codeText = string.gsub(codeText,"\t","\32");
        lineText = lineText .. string.rep("\32",lineTextLen - #lineText) .. "| ";
        local codeLen = codeViewMaxLen - (lineTextLen + 2);
        lineText = lineText .. string.sub(codeText,1,codeLen);
        if highlight then
            lineText = highlight(lineText);
        end
    end
    print(lineText);
end

return printLineFromFile;