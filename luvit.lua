local qtest = require("qtest"):init("unnamed test")

qtest.describe("luvit",function ()
    qtest.it("it has string library?",function ()
        qtest.test.isExist(string);
    end)
end)

qtest.results(print);