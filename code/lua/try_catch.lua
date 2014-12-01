Exception = setmetatable({}, {
    __index = function(tab, key)
        return key
    end
})

function try(tryFunc, catchFunc)
    local status, ex = pcall(tryFunc)
    if not status then
        catchFunc(ex)
    end
end

try(function()
    print("1")
    error(Exception.TooManyFapottry)
    print("2")
end, function(ex)
    print("3")
    print(ex)
end)
