local skynet = require "skynet.manager"
local snax = require "skynet.snax"
local Util = require "Util"
local GameObject = require "GameObject"

skynet.start(function()
    print("helloworld")

    skynet.newservice("debug_console",skynet.getenv("debug_console_port"))

    local uServerMgrSrv = snax.uniqueservice("UServerMgrSrv")
    Util.print_lua_table(uServerMgrSrv.req)
    Util.print_lua_table({a = 1111})
    uServerMgrSrv.req.HelloWorld("edward")

    local gameObject = GameObject.New()
end)