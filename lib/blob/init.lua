--------------------------------------------------------------
-- shorthands
--------------------------------------------------------------
local lp = love.physics
local lg = love.graphics
local lm = love.math


--------------------------------------------------------------
-- requires
--------------------------------------------------------------
local lume = require('lib.lume')


--------------------------------------------------------------
-- constants
--------------------------------------------------------------
local NODE_RADIUS = 8


---@class Blob
---@field kernel_body    love.Body
---@field kernel_fixture love.Fixture
---@field nodes {body: love.Body, fixture: love.Fixture, joint_to_kernel: love.Joint, joint_to_node: love.Joint}[]
---@field outer_points number[]
---@field line_width   number
---@field radius       number
---@field is_dissolved boolean
---@field node_radius  number
local Blob = {}


function Blob:update()
    local outer_points = {}
    for _, node in ipairs(self.nodes) do
        local x0, y0 = self.kernel_body:getPosition()
        local xn, yn = node.body:getPosition()
        local dist = lume.distance(x0, y0, xn, yn)
        local x = x0 - (x0 - xn) * (1 + NODE_RADIUS / dist)
        local y = y0 - (y0 - yn) * (1 + NODE_RADIUS / dist)

        table.insert(outer_points, x)
        table.insert(outer_points, y)
    end

    self.outer_points = outer_points
end


function Blob:drawDebug()
    local clr = { lg.getColor() }
    lg.setColor(0.2, 0.4, 0.2)
    for _, node in ipairs(self.nodes) do
        lg.circle(
            'line',
            node.body:getX(),
            node.body:getY(),
            self.node_radius)
    end
    lg.circle(
        'line',
        self.kernel_body:getX(),
        self.kernel_body:getY(),
        self.radius)
    lg.setColor(clr)
end


---@param category integer
function Blob:setCategory(category)
    self.kernel_fixture:setCategory(category)
    for i = 1, #self.nodes do
        self.nodes[i].fixture:setCategory(category)
    end
end


function Blob:fixPosition()
    self.kernel_body:setType('static')
end


---@param style? "line"|"fill"
function Blob:draw(style)
    style = style or 'fill'
    local line_style = lg.getLineStyle()
    lg.setLineStyle('smooth')
    lg.setLineWidth(self.line_width)
    if self.is_dissolved then
        for i = 1, #self.nodes do
            local x, y = self.nodes[i].body:getPosition()
            lg.circle(style, x, y, 10)
        end
        local x, y = self.kernel_body:getPosition()
        lg.circle(style, x, y, 10)
    else 
        lg.polygon(style, self.outer_points)
    end
    lg.setLineStyle(line_style)
end


function Blob:dissolve()
    if self.is_dissolved then
        return
    end
    self.is_dissolved = true
    for i = 1, #self.nodes do
        self.nodes[i].joint_to_kernel:destroy()
        self.nodes[i].joint_to_node:destroy()
    end
end


function Blob:destroy()
    for i = 1, #self.nodes do
        -- ? joint の破棄は勝手にされてた
        self.nodes[i].fixture:destroy()
        self.nodes[i].body:destroy()
    end
    self.kernel_fixture:destroy()
    self.kernel_body:destroy()
end


---@param world love.World
---@param x number
---@param y number
---@param r number radius
---@param nr number? node radius
function Blob.new(world, x, y, r, nr)
    nr = nr or NODE_RADIUS

    local obj = {}

    local kernel_body    = lp.newBody(world, x, y, 'dynamic')
    local kernel_shape   = lp.newCircleShape(r / 4)
    local kernel_fixture = lp.newFixture(kernel_body, kernel_shape)

    local node_shape = lp.newCircleShape(nr)
    local node_count = r

    local nodes = {}

    for i = 1, node_count do
        local angle = (2 * math.pi) * i / node_count

        local node_x = x + r * math.cos(angle)
        local node_y = y + r * math.sin(angle)

        local node_body = lp.newBody(world, node_x, node_y, 'dynamic')
        node_body:setAngularDamping(100)

        local node_fixture = lp.newFixture(node_body, node_shape)
        node_fixture:setFriction(30)
        node_fixture:setRestitution(0)

        local node_joint = lp.newDistanceJoint(
            kernel_body, node_body, node_x, node_y, node_x, node_y, false)
        node_joint:setDampingRatio(0.1)
        node_joint:setFrequency(12 * (20 / r))

        table.insert(nodes, {
            body            = node_body,
            fixture         = node_fixture,
            joint_to_kernel = node_joint,
        })
    end

    for i = 1, #nodes do
        local j = (i % #nodes) + 1

        local joint = lp.newDistanceJoint(
            nodes[i].body,
            nodes[j].body,
            nodes[i].body:getX(),
            nodes[i].body:getY(),
            nodes[j].body:getX(),
            nodes[j].body:getY(),
            false)
        nodes[i].joint_to_node = joint
    end

    obj.kernel_body = kernel_body
    obj.kernel_fixture = kernel_fixture
    obj.nodes = nodes

    obj.outer_points = {}
    for i = 1, node_count * 2 do
        obj.outer_points[i] = 0
    end

    obj.line_width   = 1
    obj.node_radius  = nr
    obj.radius       = r / 4
    obj.is_dissolved = false

    return setmetatable(obj, { __index = Blob })
end


return Blob
