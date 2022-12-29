---@class ECS.CircleComponent
---@field r number

---@param args {r: number}
---@return ECS.CircleComponent
return function(args)
    return {
        r = (args and args.r) and args.r or 1
    }
end
