createStream = function()
    newStream =
    { Filter = filter
    , Find = find
    , ForEach = forEach
    , Map = map
    , Reduce = reduce
    }
    return newStream
end

filter = function(tbl, f)
    local t = createStream()
    for k, v in pairs(tbl) do
        if f(v) then
            t[k] = v
        end
    end
    return t
end

find = function(tbl, f)
    for k, v in pairs(tbl) do
        if f(v) then
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
    local t = createStream()
    for k, v in pairs(tbl) do
        t[k] = f(k, v)
    end
    return t
end

reduce = function(tbl, initialValue, f)
    local rv = initialValue
    for k, v in pairs(tbl) do
        rv = f(rv, v)
    end
    return rv
end

