-----------------------------------------------------------------------------
-- Lua Class Lib
--
-- Author: Robert Ray <louirobert@gmail.com> @ 2011
-- Home Page: http://code.google.com/p/lua-class-lib/
-- Licence: MIT
-- Version: 0.1
--
-----------------------------------------------------------------------------

module(..., package.seeall)

local function parseName(str)
    local _begin, _end, cls = assert(str:find('%s*([a-zA-Z][a-zA-Z0-9_]*)%s*%:?'))
    if not str:find(':', _end) then
        return cls, {}
    end
    local bases = {}
    while true do
        local base
        _begin, _end, base = str:find('%s*([a-zA-Z][a-zA-Z0-9_]*)%s*%,?', _end + 1)
        if base then
            table.insert(bases, base)
        else
            break
        end
    end
    return cls, bases
end

local function create(t, ...)
    local o = {}
    if t.__init__ then
        t.__init__(o, ...)
    end
    return setmetatable(o, {__index = t, __class__ = t})
end

function class(name)
    local env = getfenv(2)
    local clsName, bases = parseName(name)
    for i, v in ipairs(bases) do
        bases[i] = env[v]   --Replace string name with class table
    end

    return function (t)
        local meta = {__call = create, __bases__ = bases}
        meta.__index = function(nouse, key)
            for _, cls in ipairs(meta.__bases__) do
                local val = cls[key]    --Do a recursive search on each cls
                if val ~= nil then
                    return val
                end
            end
        end
        env[clsName] = setmetatable(t, meta)
    end
end

function getClass(o)
    local meta = assert(getmetatable(o))
    return meta.__class__
end

function getBaseClasses(c)
    local meta = assert(getmetatable(c))
    return meta.__bases__
end

local function upTraverse(cls)
    coroutine.yield(cls)
    local bases = getmetatable(cls).__bases__
    for _, v in ipairs(bases) do
        upTraverse(v)
    end
end

function upClasses(cls)
    return coroutine.wrap(function() upTraverse(cls) end)
end

function isInstanceOf(o, c)
    local cls = assert(getClass(o))
    for one in upClasses(cls) do
        if one == c then
            return true
        end
    end
    return false
end

_G.class = class
_G.isInstanceOf = isInstanceOf
