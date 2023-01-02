---@class ECS.ShadowBodyComponent

---@param args {w: number, h: number, a: number}
---@return ECS.ShadowBodyComponent
return function(args)
    return {
        w    = args and args.w or nil,
        h    = args and args.h or nil,
        a    = args and args.a or nil,
        body = nil
    }
end
