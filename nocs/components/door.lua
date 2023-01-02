---@class ECS.DoorComponent
---@field level            integer
---@field orbital_radius   integer
---@field satellite_radius integer

---@param args table?
---@return ECS.DoorComponent
return function(args)
    assert(type(args) == 'table')

    return {
        level            = (args and args.level) and args.level or 1,
        orbital_radius   = 50,
        satellite_radius = 5,
    }
end
