--table 
table.size = function(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

table.empty = function(t)
    return not next(t)
end

table.indices = function(t)
    local result = {}
    for k,v in pairs(t) do
        table.insert(result , k)
    end
end

table.values = function(t)
    local result = {}
    for k,v in pairs(t) do
        table.insert(result,v)
    end
end

-- 下标运算
do
    local mt = getmetatable("")
    local _index = mt.__index
    mt.__index = function(s, ...)
        local k = ...
        if "number" == type(k) then
            return _index.sub(s,k,k)
        else
            return _index[k]
        end
    end
end

local a = "hello"
print("a[2]  = ", a[2])

--string.split = function(s, delim)
--    local split = {}
--    local pattern = "[^" .. delim .. "]+"
--    string.gsub(s, pattern, function(v) table.insert(split, v) end)
--    return split
--end

string.ltrim = function(s,c)
    local pattern = "^" .. (c or "%s") .. "+"
    return (string.gsub(s,pattern,""))
end

string.rtrim = function(s, c)
    local pattern = (c or "%s") .. "+" .. "$"
    return (string.gsub(s, pattern, ""))
end

string.trim = function(s, c)
    return string.rtrim(string.ltrim(s, c), c)
end

local function dump(obj)
    local getIndent, quoteStr, wrapKey, wrapVal, dumpObj
    getIndent = function(level)
        return string.rep("\t",level)
    end
    quoteStr = function(str)
        return '"' .. string.gsub(str,'"','\\"') .. '"'
    end
    wrapKey = function(val)
        if type(val) == "number" then
            return "[" .. val .. "]"
        elseif type(val) == "string" then
            return "[" .. quoteStr(val) .. "]"
        else
            return "[" .. tostring(val) .. "]"
        end
    end
    wrapVal = function(val,level)
        if type(val) == "table" then
            return dumpObj(val,level)
        elseif type(val) == "number" then
            return val
        elseif type(val) == "string" then
            return quoteStr(val)
        else
            return tostring(val)
        end
    end
    dumpObj = function(obj,level)
        if type(obj) ~= "table" then
            return wrapVal(obj)
        end
        level = level + 1
        local tokens = {}
        tokens[#tokens + 1] = "{"
        for k,v in pairs(obj) do
            tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v) .. ","
        end
        tokens[#tokens + 1] = getIndent(level - 1) .. "}"
        return table.concat(tokens,"\n")
    end
    return dumpObj(obj,0)
end

do
    local _tostring = tostring
    tostring = function(obj)
        if type(obj) == "table" then
            return dump(obj)
        else
            return _tostring(v)
        end
    end
end


-- lua 面向对象扩展
-- lua面向对象扩展
function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
            cls.ctor = function() end
        end

        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end

function iskindof(obj,className)
    local t = type(obj)
    local mt
    if t == "table" then
        mt = getmetatable(obj)
    elseif t == "userdata" then
        mt = tolua.getpeer(obj)
    end
    while mt do
        if mt.__cname == className then
            return true
        end
        mt = mt.super
    end
end


