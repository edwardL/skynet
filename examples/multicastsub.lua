local skynet = require "skynet"
local mc = require "skynet.multicast"
local channel
local channelId = ... -- 从启动参数获取channel id 
channelId = tonumber(channelId)

local function recvChannel(channel , source , msg, ...)
	skynet.error("channel id:", channel , "source:",skynet.address(source))
end

skynet.start(function()
	channel = mc.new {
		channel = channelId, -- 绑定上一个渠道
		dispatch = recvChannel, -- 设置这个渠道的消息处理函数
	}
	channel:subscribe()
	skynet.timeout(500,function() channel:unsubscribe() end) -- 5 秒后取消定义
end)