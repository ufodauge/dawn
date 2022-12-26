return {
    i = function(x)
        return x * x
    end,
    o = function(x)
        return 1 - (1 - x) * (1 - x)
    end,
    io = function(x)
        return x < 0.5
            and 2 * x * x
            or 1 - (-2 * x + 2) * (-2 * x + 2) / 2
    end,
}
