local skynet = require "skynet"
local M = {}

function init()
    print("init func")
end

function exit()
    print("exit func")
end

function response.HelloWorld(...)
    print("helloworld----" , ...)
    return
end

function accept.HelloWorld111(...)

end

local function LoadAndInitServer()
    local path = skynet.getenv("root") .. "Common.json")

    local configFileFD = io.open(path)
    if not configFileFD then
        return false
    end
    local configData = configFileFD:read "a"
    configData:close()

    

end

function reponse.LoadAndInitServer()
    return LoadAndInitServer()
end