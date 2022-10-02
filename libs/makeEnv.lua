local module = {};

function module:init(private)
    return function (self,func)
        local env = getfenv(func);
        env.context = self.context;
        env.run = self.run;
        env.global = self.global;
        env.waitForEnter = self.waitForEnter;
        env.it = self.it;
        env.results = self.results;
        env.test = self.test;
        return func
    end;
end

return module;
