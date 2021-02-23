
function filter(tbl, func)
    local t = {}
    for k, v in pairs(tbl) do
        if f(v) then
            t[k] = v
        end
    end
    return t
end

function find(tbl, func)
    for k, v in pairs(tbl) do
        if f(v) then
            return v
        end
    end
    return nil
end

function forEach(tbl, func)
    for k, v in pairs(tbl) do
        f(v)
    end
end

function map(tbl, func)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function reduce(tbl, initialValue, func)
    local rv = initialValue
    for k, v in pairs(tbl) do
        rv = f(rv, v)
    end
    return rv
end
