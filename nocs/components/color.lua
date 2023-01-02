---@class ECS.ColorComponent
---@field r number
---@field g number
---@field b number
---@field a number

---@param args {r: number, g: number, b: number, a: number?}|number[]
---@return ECS.ColorComponent
return function(args)
    setmetatable(args, {
        __index = function(self, index)
            if index == 'r' then
                return self[1]
            elseif index == 'g' then
                return self[2]
            elseif index == 'b' then
                return self[3]
            elseif index == 'a' then
                return self[4]
            end
            error('unreachable')
        end
    })

    return {
        r = args.r or 1,
        g = args.g or 1,
        b = args.b or 1,
        a = args.a or 1,
    }
end
