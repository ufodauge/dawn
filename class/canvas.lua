local lg = love.graphics


---@class Canvas
local Canvas = {}
Canvas.__index = Canvas

---@type table<string, {canvas: love.Canvas, z_index: integer, name: string, track_speed: number}>
local canvases = {}


---@param canvas_name string
---@param z_index integer
---@param track_speed number
function Canvas:register(canvas_name, z_index, track_speed)
    for _, tbl in ipairs(canvases) do
        assert(
            tbl.name ~= canvas_name,
            ('canvas %s is already registered.'):format(canvas_name))
    end

    local w, h = love.window.getMode()
    canvases[#canvases + 1] = {
        canvas      = lg.newCanvas(w, h),
        z_index     = z_index or (#canvases + 1),
        name        = canvas_name,
        track_speed = track_speed or 1
    }

    table.sort(canvases, function(a, b)
        return a.z_index < b.z_index
    end)
end


---@param canvas_name string
function Canvas:release(canvas_name)
    for i, canvas in ipairs(canvases) do
        if canvas.name == canvas_name then
            canvas.canvas:release()
            table.remove(canvases, i)
            return
        end
    end
end


function Canvas:setCanvasSize(w, h)
    for _, canvas in ipairs(canvases) do
        canvas.canvas = lg.newCanvas(w, h)
    end
end


function Canvas:releaseAll()
    for i = #canvases, 1, -1 do
        canvases[i].canvas:release()
        table.remove(canvases, i)
    end
end


---@param canvas_name string
---@return love.Canvas
function Canvas:get(canvas_name)
    for _, canvas in ipairs(canvases) do
        if canvas.name == canvas_name then
            return canvas.canvas
        end
    end
    error(('cavas %s does not exist.'):format(canvas_name))
end


function Canvas:clear()
    for i = 1, #canvases do
        lg.setColor(1, 1, 1, 1)
        lg.setCanvas(canvases[i].canvas)
        lg.clear()
    end
    lg.setCanvas()
end


---@param l number
---@param t number
---@param w number
---@param h number
function Canvas:draw(l, t, w, h)
    lg.setColor(1, 1, 1, 1)
    for i = 1, #canvases do
        local speed = canvases[i].track_speed
        lg.draw(canvases[i].canvas, l * (-speed + 1), t * (-speed + 1))
    end
end


return Canvas
