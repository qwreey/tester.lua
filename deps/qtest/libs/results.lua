local module = {};

function module:init(private)
    return function(printfn)
        printfn = printfn or private.print;
        if not printfn then
            error("printfn was not found! add print for function arg to fix this");
        end

        
    end
end

return module;