---@class ECS.AnimationComponent
---@field timer    number
---@field duration number
---@field loop     boolean
---@field result   number
---@field percent  number
---@field easing   string?


---@param args table?
---@return ECS.AnimationComponent
return function(args)
    return {
        timer      = args and args.timer or 0,
        duration   = args and args.duration or 1,
        loop       = args and args.loop or true,
        easing     = args and args.easing or 'quadinout',
        percent    = 0,
        result     = 0
    }
end
