local skynet = require "skynet"
local mc = require "skynet.multicast"
local channel

function task()
	local i = 0
	while(i < 100) do
		skynet.sleep(100)
		channel:publish("data" .. i) -- 推送数据
		i = i + 1
	end
	channel:delete()
	skynet.exit()
end

local command = {}

function command.GetChannelId()
	return channel.channel
end


skynet.start(function()
	channel = mc.new() -- 创建一个频道
	skynet.error("new channel id",channel.channel)

	skynet.dispatch("lua",function(session,address,cmd, ...)
		local f = command[cmd]
		if f then
			skynet.ret(skynet.pack(f(...)))
		end
	end)

	skynet.fork(task)
end)