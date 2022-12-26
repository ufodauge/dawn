local transform = require('ecs.components.transform')
local text      = require('ecs.components.text')

---@param args table<string, any>
---@return ECS.Entity
return function(args)
    return {
        transform = transform(args.transform),
        text      = text(args.text)
    }
end
