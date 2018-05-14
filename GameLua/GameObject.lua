local skynet = require "skynet"
local Object = require "Object"
local Util = require "Util"
local BaseClass = require "class"

local GameObject,Super = BaseClass("GameObject", Object)

function GameObject:__init()
    print("in gameobject init")
    self.__comps__ = {}
end

function GameObject:AddComponent( componetName, component , ...)
    local comp = component.New(self,...)
    self.__comps__[componetName] = comp
    return comp
end

function GameObject:GetComponent( componentName )
    local comp = self.__comps__[componentName]

    return comp
end

function GameObject:RemoveComponent( componentName )
    if componentName then
        local component = self.__comps__[componentName]
        if component then
            self:__UnregEvent(component)
            self.__comps__[componetName] = nil
            component:CloseObj()
        end
    end
end

return GameObject