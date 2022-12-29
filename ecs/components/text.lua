---@class ECS.TextComponent
---@field content string
---@field font love.Font


---@param args {content: string?, font: love.Font?}
---@return ECS.TextComponent
return function(args)
    return love.lume.merge({
        content = '',
        font    = love.graphics.getFont()
    }, args or {})
end
