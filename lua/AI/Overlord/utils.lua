
append = function(tbl1, tbl2)
    local t = Stream:createStream()
    local i = 1
    for k, v in pairs(tbl1) do
        t[i] = v
        i = i + 1
    end
    for k, v in pairs(tbl2) do
        t[i] = v
        i = i + 1
    end
    return t
end

concatHashToArray = function(t1, t2)
    for i,v in pairs(t2) do
        if v != nil then
            t1[table.getn(t1)+1] = v
        end
    end
    return t1
end

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

join = function(tbl1, tbl2, f)
    local t = Stream:createStream()
    for k, v in pairs(tbl1) do
        t[k] = v
    end
    for k, v in pairs(tbl2) do
        if not t[k] then
            t[k] = v
        else
            t[k] = f(k, t[k], v)
        end
    end
    return t
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
{ ConcatHashToArray = concatHashToArray
, Filter = filter
, Find = find
, ForEach = forEach
, Join = join
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

function pipe( ... )
    local filters = arg
    return function( input, output )
        for data in input do
            local current = data
            for _, filter in ipairs( filters ) do
                current = filter( current )
            end
            output( current )
        end
    end
end

