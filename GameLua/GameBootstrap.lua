local skynet = require "skynet.manager"
local snax = require "skynet.snax"
local Util = require "Util"
local GameObject = require "GameObject"

local function LOG_INFO(fmt, ...)
	local msg = string.format(fmt, ...)
	local info = debug.getinfo(2)
	if info then
		msg = string.format("[%s:%d] %s", info.short_src, info.currentline, msg)
	end
	skynet.send("log", "lua", "info", SERVICE_NAME, msg)
end

skynet.start(function()
    print("helloworld")

    skynet.newservice("debug_console",skynet.getenv("debug_console_port"))

    local uServerMgrSrv = snax.uniqueservice("UServerMgrSrv")
    Util.print_lua_table(uServerMgrSrv.req)
    Util.print_lua_table({a = 1111})
    uServerMgrSrv.req.HelloWorld("edward")

    local gameObject = GameObject.New()

    ---
    local redispool = skynet.uniqueservice("redispool")
    skynet.call(redispool,"lua","start")

    local log = skynet.uniqueservice("log")
    skynet.call(log,"lua","start")

    LOG_INFO("helloworld")

end)