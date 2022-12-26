--------------------------------------------------------------
-- const
--------------------------------------------------------------
local PATH    = ... .. '.'
local SYSPATH = PATH:gsub('%.', '/')


--------------------------------------------------------------
-- shorthands
--------------------------------------------------------------
local lg = love.graphics
local lf = love.filesystem


--------------------------------------------------------------
-- libraries
--------------------------------------------------------------
local utils           = require(PATH .. 'lib.utils')
local PeformenceGraph = require(PATH .. 'lib.peformenceGraph')


--------------------------------------------------------------
-- systems
--------------------------------------------------------------
local font_debug = utils.imageFontLoader(SYSPATH .. 'res/font')


--------------------------------------------------------------
-- Class
--------------------------------------------------------------
local Director    = require(PATH .. 'class.director')
local DebugMenu   = require(PATH .. 'class.debugMenu')
local MessageArea = require(PATH .. 'class.messageArea')
local Camera      = require(PATH .. 'class.Camera')


--------------------------------------------------------------
-- LLDebug
--------------------------------------------------------------

---@class LLDebug
---@field active       boolean true if LLDebug is active
---@field graph_mem    DebugGraph
---@field graph_fps    DebugGraph
---@field debug_menu   DebugMenu
---@field flags        boolean[]
---@field message_area MessageArea
---@field camera       FreeCamera
local LLDebug = {}


---comment
function LLDebug:activate()
    self.active = true
end


---comment
---@param dt number
function LLDebug:update(dt)
    -- Activated Guard
    --------------------------------------------------------------
    if not self.active then
        return
    end


    -- Debug Menu
    --------------------------------------------------------------
    self.debug_menu:update(dt)


    -- Debug Graph
    --------------------------------------------------------------
    self.graph_mem:update(dt)
    self.graph_fps:update(dt)


    -- Free Camera
    --------------------------------------------------------------
    self.camera:update()
end


---comment
function LLDebug:draw()
    -- Activated Guard
    --------------------------------------------------------------
    if not self.active or not self.debug_menu.display then
        return
    end


    -- Render LLDebug
    --------------------------------------------------------------
    lg.setColor(1, 1, 1, 1)
    lg.setFont(font_debug)


    -- Debug Menu
    --------------------------------------------------------------
    self.debug_menu:draw()


    -- Message area
    --------------------------------------------------------------
    self.message_area:draw()


    -- Debug Graph
    --------------------------------------------------------------
    self.graph_mem:draw()
    self.graph_fps:draw()
end


---comment
---@param message string|function
function LLDebug:log(message)
    self.message_area:printMessage(message)
end


---comment
function LLDebug:clearLog()
    self.message_area:clear()
end


---comment
---@param name    string
---@param default boolean?
function LLDebug:addFlag(name, default)
    self.flags[name] = default or false
    self.debug_menu:addToggler(name, function()
        self.flags[name] = not self.flags[name]
    end)
end


---comment
---@param name string
---@return boolean
function LLDebug:getFlag(name)
    if self.flags[name] == nil then
        print(('unset flag %s has been called.'):format(name))
        return false
    end
    return self.flags[name]
end


---comment
---@param path string
function LLDebug:setScenePath(path)
    self.debug_menu:setScenePath(path)
end


---comment
---@param instance Roomy
function LLDebug:setRoomy(instance)
    self.debug_menu:setRoomy(instance)
end


---comment
---@return LLDebug
function LLDebug.new()
    local self = {}


    self.active = false -- activate flag
    self.flags = {}


    -- Director
    --------------------------------------------------------------
    self.director = Director.new() --[[@as Director]]


    -- Debug Menu
    --------------------------------------------------------------
    self.debug_menu = DebugMenu:getInstance() --[[@as DebugMenu]]
    self.debug_menu:setMainInstance(self)


    -- Debug Graph
    --------------------------------------------------------------
    self.graph_mem        = PeformenceGraph:new('mem')
    self.graph_mem.width  = 160
    self.graph_mem.height = 40
    self.graph_mem.x      = lg.getWidth() - self.graph_mem.width
    self.graph_mem.y      = lg.getHeight() - self.graph_mem.height * 2
    self.graph_mem.font   = font_debug

    self.graph_fps        = PeformenceGraph:new('fps')
    self.graph_fps.width  = 160
    self.graph_fps.height = 40
    self.graph_fps.x      = lg.getWidth() - self.graph_fps.width
    self.graph_fps.y      = lg.getHeight() - self.graph_fps.height
    self.graph_fps.font   = font_debug

    ---@diagnostic disable-next-line: unused-local
    self.director:register('resize', function(width, height)
        self.graph_mem.x = lg.getWidth() - self.graph_mem.width
        self.graph_mem.y = height - self.graph_mem.height * 2

        self.graph_fps.x = lg.getWidth() - self.graph_fps.width
        self.graph_fps.y = height - self.graph_fps.height
    end)

    self.debug_menu:addToggler('Memory Graph', function()
        self.graph_mem.display = not self.graph_mem.display
    end)

    self.debug_menu:addToggler('FPS Graph', function()
        self.graph_fps.display = not self.graph_fps.display
    end)


    -- Display area for debug message
    --------------------------------------------------------------
    self.message_area = MessageArea.new() --[[@as MessageArea]]
    self.message_area.w = 450
    self.message_area.h = 500
    self.message_area.x = 0
    self.message_area.y = lg.getHeight() - self.message_area.h


    self.director:register('resize', function(width, height)
        self.message_area.x = width - self.message_area.w
        self.message_area.y = height - self.message_area.h
    end)


    -- On Window Resize Callback
    --------------------------------------------------------------
    local _resize = love.resize or function() end
    function love.resize(width, height)
        _resize(width, height)
        self.director:notify('resize', width, height)
    end


    self.camera = Camera --[[@as FreeCamera]]

    self.debug_menu:addCommand('Camera Reset', function()
        self.camera:reset()
    end)


    return setmetatable(self, { __index = LLDebug })
end


--------------------------------------------------------------
-- Export
--------------------------------------------------------------
local Export = {}
local instance = nil


---get an instance
---@return LLDebug
function Export:getInstance()
    if instance == nil then
        instance = LLDebug.new()
    end

    return instance
end


return Export
