local waitForEnter = require "qtest.libs.waitForEnter"
local logger = require "qtest.libs.logger"
local module = {};

function module:init(testProfile)
    local private = {
        testProfile = testProfile; -- this test name
        testNow = nil; -- now test thing
        it = nil; -- now test
        nowStatus = nil; -- now status (thing)
        status = {}; -- status table
        global = {}; -- global date store
        --waitForEnter = require("waitForEnter"):init(io,print); -- wait for enter module
        --termColor = require("termColor"); -- terminal color module
    };
    --private.logger = require("logger"):init(private);

    return {
        util = require("util");
        global = private.global;
        waitForEnter = waitForEnter;

        thing = (require("thing"):init(private));

        it = (require("it"):init(private));
        test = (require("test"):init(private));

        results = (require("results"):init(private));
        run = (require("run"):init(private));
    };
end

return module;
