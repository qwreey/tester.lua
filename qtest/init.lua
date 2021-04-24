local module = {};

function module:init(testProfile)
    local private = {
        testProfile = testProfile; -- 이 테스트의 이름
        testStack = {}; --테스팅중인 부분 stack 자료 (describe 가 콜 될 때 마다 스텍됨)
        testNow = nil; --지금 테스팅중인 부분 str (describe 에 따라 바뀜)
        it = nil;
        nowStatus = nil;
        status = {};
        global = {}; -- 테스트중 글로벌 데이터를 담을 곳
    };

    return {
        it = (require("it"):init(private));
        describe = (require("describe"):init(private));
        test = (require("test"):init(private));
        global = (require("global"):init(private));
        logger = (require("logger"):init(private));
        util = (require("util"):init(private));
        results = (require("results"):init(private));
        run = (require("run"):init(private));
    };
end

return module;
