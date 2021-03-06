

filter = function(tbl, f)
    local t = Stream:createStream()
    for k, v in pairs(tbl) do
        if f(k, v) then
            t[k] = v
        end
    end
    return t
end

find = function(tbl, f)
    for k, v in pairs(tbl) do
        if f(k, v) then
            return v
        end
    end
    return nil
end

forEach = function(tbl, f)
    for k, v in pairs(tbl) do
        f(k, v)
    end
end

map = function(tbl, f)
    local t = Stream:createStream()
    for k, v in pairs(tbl) do
        t[k] = f(k, v)
    end
    return t
end

-- like map(), but f() is a multiple return for the new Key and Value
map2 = function(tbl, f)
    local t = Stream:createStream()
    for k, v in pairs(tbl) do
        local kn, vn = f(k, v)
        t[kn] = vn
    end
    return t
end

reduce = function(tbl, initialValue, f)
    local rv = initialValue
    for k, v in pairs(tbl) do
        rv = f(k, rv, v)
    end
    return rv
end

Stream =
{ Filter = filter
, Find = find
, ForEach = forEach
, Map = map
, Map2 = map2
, Reduce = reduce
}
Stream.__index = Stream

function Stream:createStream(obj)
    local newStream = obj or {}
    setmetatable(newStream, self)
    return newStream
end