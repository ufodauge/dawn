---@class ECS.TransformComponent
---@field x number
---@field y number
---@field r number
---@field sx number
---@field sy number

---@param args {x: number?, y:number?, sx: number?, sy: number?, r: number?}?
---@return ECS.TransformComponent
return function(args)
    return {
        x  = args and args.x or 0,
        y  = args and args.y or 0,
        r  = args and args.r or 0,
        sx = args and args.sx or 1,
        sy = args and args.sy or 1
    }
end
