local _ = require("QuaTest"):init({
    profileName = "unnamed test";
    fixPath = true;
    disableViewCode = false;
    print = nil;
});
_.run();

_.thing("luvit",function ()
    _.it("has string library?",function ()
        _.test.isExist(string);
    end);

    _.it("has utf8 library?",function ()
        _.test.isExist(utf8);
    end);

    _.it("is jit?",function ()
        _.test.isExist(jit); ---@diagnostic disable-line:undefined-global
    end);

    _.it("is py?",function ()
        _.test.isExist(nil);
    end)

    _.thing("table lib",function ()
        _.thing("test",function ()
            _.it("fail",function ()
                _.test.isExist(nil);
            end);
        end);
        _.it("has remove?",function ()
            _.test.isExist(table.remove);
            _.global.hello = "Hello"; -- you can use global table
        end);
        _.it("fail",function ()
            _.test.isExist(nil):failMsg("test say");
        end);
        --error("asdf");
    end);
end);

_.thing("just a test",function ()
    _.it("asdf",function ()
        _.test.nop();
    end);
end);

_.results();
os.exit(_.getReturn());
