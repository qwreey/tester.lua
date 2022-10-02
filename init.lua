--[[
    write : qwreey
    var : Public release 1
]]

local module = {};

function module.init(testProfile)
    -- set finding path
    if testProfile.fixPath and package then
        package.path = package.path .. (
            package.config:sub(1,1) == "\\" and
            ".\\deps\\?.lua;.\\deps\\?\\init.lua;.\\deps\\QuaTest\\libs\\?.lua;.\\QuaTest\\libs\\?.lua;" or
            "./deps/?.lua;./deps/?/init.lua;/deps/QuaTest/libs/?.lua;./QuaTest/libs/?.lua;"
        );
    end
    -- require (for roblox's require system)
    if script then
        require = require(script.Parent.require) or require;
    end

    local private = {
        testProfile = testProfile.profileName; -- this test name
        nowThing = nil;
        nowIt = nil;
        status = {};
        totalItFail = 0; -- total it fail
        totalItPass = 0; -- total it pass
        totalThingFail = 0; -- total thing fail
        totalThingPass = 0; -- total thing pass

	--returnCode = 0;
        files = {};
        global = {};
        print = testProfile.print;
        isRunning = false;
        disableViewCode = testProfile.disableViewCode;
        waitForEnter = require("waitForEnter"):init(io,print); -- wait for enter module
        termColor = require("termColor");
        require = require;
    };
    --private.logger = require("logger"):init(private);

    local result = {
	getReturn = function()
		if private.totalItFail ~= 0 then
			return 1;
		end
		--return private.returnCode;
	end;
        global = private.global;
        waitForEnter = private.waitForEnter;

        run = (require("run"):init(private));
        context = (require("thing"):init(private));
        it = (require("it"):init(private));

        test = (require("test"):init(private));
        results = (require("results"):init(private));
    };
    local env = (require("makeenv"):init(private));
    result.env = env;

    if testProfile.func then
        env(testProfile.func)
    end
    return result;
end

return module;
