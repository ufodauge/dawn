---@class ECS.CircleComponent
---@field r number

---@param args {r: number, ry: number}
---@return ECS.CircleComponent
return function(args)
    return {
        r  = args.r or 1
    }
end
