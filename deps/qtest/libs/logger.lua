local module = {};

local private,termColor,logfn;
function module:init(nprivate,nlogfn)
    private = nprivate;
    logfn = nlogfn;
    termColor = private.termColor;
    return self;
end

function module.errOnThingFn(thingName,msg)
    local red = termColor.new(termColor.names.red);
     red()

end


return module;