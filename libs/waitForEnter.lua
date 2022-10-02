local module = {};

function module:init(io,print)
    return function (q)
        print(q or "[Enter for continue or Ctrl+C for cancel ...] ");
        local readed = io.read();
        if not readed then
            local err,pretty = pcall(require,"pretty-print");
            if error then
                print("NO INPUT PROVIDER AVAILABLE");
                return;
            end
            local stdin = pretty.stdin;
            stdin:tty_set_mode(0);
            stdin:read_start(function(err,content)
               --if content == ""
            end);
        end
        return readed
    end;
end

return module;
