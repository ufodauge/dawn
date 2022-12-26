---@param args {text: string?, font: love.Font?}
---@return ECS.Component
return function(args)
    return {
        text = args.text or '',
        font = args.font or love.graphics.getFont()
    }
end
