local Wait = {}
local finishedEvent = {}
local waitCo = {}
local _SRV_READY_EVENT_NAME = "_SRV_READY_EVENT_NAME"
local coroutine = require "skynet.coroutine"
local skynet = require "skynet"

-- 等待某个事件完成再继续执行。
function Wait.WaitEvent( eventName )
    if finishedEvent[eventName] then
        return
    end
    local co = coroutine.running()
    local cos = waitCo[eventName]
    if not cos then
        cos = {}
        waitCo[eventName] = cos
    end
    cos[co] = true
    skynet.wait(co)
end

--完成某个事件了，给个消息
function Wait.FinishEvent( eventName )
    finishedEvent[eventName] = true
    local cos = waitCo[eventName]
    if cos then
        waitCo[eventName] = nil
        for co in pairs(cos) do
            skynet.wakeup(co)
        end
    end
end