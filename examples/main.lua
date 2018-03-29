local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 64

skynet.start(function()
	skynet.error("Server start")
	skynet.uniqueservice("protoloader")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)
	skynet.newservice("simpledb")
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 8888)

	local service_pub = skynet.newservice("multicastpub")
	local channelId = skynet.call(service_pub , "lua" , "GetChannelId")
	print("channelId",channelId)
	skynet.newservice("multicastsub" , channelId)
	skynet.newservice("multicastsub" , channelId)
	skynet.newservice("multicastsub" , channelId)

	skynet.exit()
end)
