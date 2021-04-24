local qtest = require("qtest"):init("unnamed test");

qtest.thing("luvit",function ()
    qtest.it("has string library?",function ()
        qtest.test.isExist(string);
    end);

    qtest.it("has utf8 library?",function ()
        qtest.test.isExist(utf8);
    end);

    qtest.it("is jit?",function ()
        qtest.test.isExist(jit);
    end);
end);

qtest.results(print);