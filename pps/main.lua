-- use locals!
local Concord = require("concord")

local numberOfEntities = 0
local timeScale = 1

local alpha, beta, v, r, scope = 180, 17, 1.5, 6, 5

local step = 0

local colors = {}
colors["green"] = {0, 1, 0}
colors["yellow"] = {1, 1, 0}
colors["blue"] = {0, 0, 1}
colors["magenta"] = {1, 0, 1}
colors["brown"] = {0.514, 0.039, 0.047}

success = love.window.setFullscreen(false)

local screenWidth = love.graphics.getWidth()
local screenHeight  = love.graphics.getHeight()

local entityTable = {}

local Position = Concord.component(function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

local Orientation = Concord.component(function(c, a, L, R, N)
    c.a = a or 0
    c.L = L or 0
    c.R = R or 0
    c.N = N or 0
end)

local Size = Concord.component(function(c, radius)
    c.radius = radius or 0
end)

local Velocity = Concord.component(function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

local Drawable = Concord.component()

-- Defining Systems
local MoveSystem = Concord.system({Position})

local sign = function(x)
    return (x<0 and -1) or 1
end

local delthaPhi = function(a, b, R, L)
    return 180 + (17 * (L + R) * sign(R - L))
end

local round = function(n)
    return math.abs((n % 360))
end

function love.load()
    SpawnEntities(1000)
end

function Velocity:bounce(x, y)
    self.vel.x = x * self.vel.x
    self.vel.y = y * self.vel.y
end

function love.keypressed(key)
    if key == 'space' then
        SpawnEntities(20)
    end	
end

function MoveSystem:update(dt)
    for _, e in ipairs(self.pool) do
        local L, R, N  = 0, 0, 0
        for _, o in ipairs(self.pool) do
            if e ~= o then
                local spX = o[Position].x - e[Position].x 
                local spY = o[Position].y - e[Position].y 
                local spD = math.sqrt((spX*spX)+(spY*spY))
                if spD <= r * scope then
                    N = N + 1
                    local spA = math.atan2(spY, spX)
                    if round(spA - e[Orientation].a) < math.pi then
                        R = R + 1
                    else 
                        L = L + 1
                    end
                end
            end
        end
        local orientation = e[Orientation]
        orientation.L = L
        orientation.R = R
        orientation.N = N

        local position = e[Position]
        local angle, l, r = orientation.a, orientation.L, orientation.R

        angle = angle + delthaPhi(alpha, beta, l, r)
        angle = round(angle)
        orientation.a = angle
        position.x = position.x + v * math.cos(math.rad(angle))
        position.y = position.y + v * math.sin(math.rad(angle))
    end
end

local DrawSystem = Concord.system({Position, Drawable})

function DrawSystem:draw()
    for _, e in ipairs(self.pool) do
        local position = e[Position]
        local n = e[Orientation].N
        local right = e[Orientation].R
        local left = e[Orientation].L
        local c = colors["green"] 

        if n > 35 then 
            c = colors["yellow"]
        elseif n > 16 then
            c = colors["blue"]
     --   elseif n > 15 then
     --       c = colors["magenta"]
        elseif n > 12 then
            c = colors["brown"]
        end

        love.graphics.setColor(c)
        love.graphics.circle("fill", position.x, position.y, r)
       -- love.graphics.circle("line", position.x, position.y, r * scope)
       -- love.graphics.print("L : ".. left .. "\nR : "..right.."\nN : "..n , position.x, position.y)
    end
end

-- Create the World
local world = Concord.world()

-- Add the Systems
world:addSystems(MoveSystem, DrawSystem)

-- Create Particles
function SpawnEntities(entityCount)
    cWorld = Concord.entity
    for i=1,entityCount do 
        entityTable[i] = 
        cWorld(world):give(Position, love.math.random(0, screenWidth), love.math.random(0, screenHeight)) 
        :give(Size, circleRadius)
        :give(Orientation, love.math.random(0, 360), 0, 0, 0)
        :give(Drawable)
    end
    numberOfEntities = numberOfEntities + entityCount
end

-- Emit the events
function love.update(dt)
    world:emit("update", dt)
    love.mouse.setVisible(false)
    step = step + 1
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    world:emit("draw")
    love.graphics.setColor(1, 0, 0)

    love.graphics.print("Number of objects: ".. numberOfEntities .. "\n" .. "Current FPS: "..tostring(love.timer.getFPS()) .. "\nStep: " .. step) 
end
