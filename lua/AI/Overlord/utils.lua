
filter = function(tbl, func)
    local t = {}
    for k, v in pairs(tbl) do
        if f(v) then
            t[k] = v
        end
    end
    return t
end

find = function(tbl, func)
    for k, v in pairs(tbl) do
        if f(v) then
            return v
        end
    end
    return nil
end

forEach = function(tbl, func)
    for k, v in pairs(tbl) do
        f(v)
    end
end

map = function(tbl, func)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

reduce = function(tbl, initialValue, func)
    local rv = initialValue
    for k, v in pairs(tbl) do
        rv = f(rv, v)
    end
    return rv
end
