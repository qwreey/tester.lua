local module = {};

function module:init(private)
    return function(print)
        print = print or private.print;
        if not print then
            error("printfn was not found! add print for function arg to fix this");
        end

        print("Test End! +++++++++++++++++++++ ");
        print(("Total thing pass : %d"):format(private.totalThingPass));
        print(("Total thing fail : %d"):format(private.totalThingFail));
        print("-----------------------------------------------");

    end
end

return module;