package.path = package.path .. "?;../libs/?.lua;../libs/lovetoys-0.3.2/?.lua"

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

local lovetoys = require('lovetoys')

lovetoys.initialize({globals = true, debug = true})

local fps, numOfParticles = 60, 1
local particleList = {}

local alpha, beta, velocity = 180, 17, 0.67

local tick = 0

alpha = math.rad(alpha)
beta = math.rad(beta)

function love.load()
    -- Define a Component class.
    local Position = Component.create("position", {"x", "y"}, {x = 0, y = 0})
    local Velocity = Component.create("velocity", {"vx", "vy"})
    local Orientation = Component.create("orientation", {"a", "b", "L", "R",}, {a = 180, b = 17, L = 0, R = 0})

    local Size = Component.create("radius", {"r"}, {r = 0})

    for i=1, numOfParticles do
        local particle = Entity()
        particle:initialize()
        particle:add(Position(screenWidth / 2, screenHeight / 2))
        particle:add(Velocity(0.67, 0.67))
        particle:add(Size(20)) 
        particle:add(Orientation(alpha, beta, 0, 0))
        table.insert(particleList, particle)
    end

    -- Create a System class as lovetoys.System subclass.
    local MoveSystem = class("MoveSystem", System)

    function sign(x)
        print("sign : ".. tostring((x<0 and -1) or 1))
        return (x<0 and -1) or 1
    end

    local delthaPhi = function(a, b, R, L) 
        return a + b * (L + R) * sign(R - L)
    end

    local scope = function(angle) 
        while angle > 2*math.pi do 
            angle = angle - (2*math.pi)
        end
        while angle < 0 do 
            angle = angle + (2*math.pi)
        end
            return angle
    end

    -- Define this System's requirements.
    function MoveSystem:requires()
        return {"position", "velocity"}
    end

    function MoveSystem:update(dt)
        for _, entity in pairs(self.targets) do
            local position = entity:get("position")
            local velocity = entity:get("velocity")
            local angle, b, L, R = entity:get("orientation").a, entity:get("orientation").b, entity:get("orientation").L, entity:get("orientation").R
            
            angle = angle + delthaPhi(angle,17,5,0) 

            newAngle = angle;
                
            while newAngle <= -180 do newAngle = newAngle + 360 end
            while newAngle > 180 do newAngle = newAngle - 360 end

            angle = newAngle

            position.x = position.x + math.cos(math.rad(angle)) * velocity.vx * dt
            position.y = position.y + math.sin(math.rad(angle)) * velocity.vy * dt

            print("dP = ".. delthaPhi(angle,17, 0, 0))
            print("angle = ".. angle)
            print("x = ".. position.x)
            print("y = ".. position.y)
            tick = tick + 1 
        end
    end
    -- Create a draw System.
    local DrawSystem = class("DrawSystem", System)

    -- Define this System requirements.
    function DrawSystem:requires()
        return {"position" , "radius"}
    end

    function DrawSystem:draw()
        love.graphics.setColor(0, 1, 0)
        for _, entity in pairs(self.targets) do
            local p = entity:get("position")
            local v = entity:get("velocity")
            local o = entity:get("orientation")
            local posX, posY, velX, velY = p.x, p.y, v.vx, v.vy
            local radius = entity:get("radius").r

            love.graphics.circle("fill", posX, posY, radius)
            love.graphics.circle("line", posX, posY, radius * 10)
            love.graphics.print("L = ".. o.L, posX, posY + 10)
            love.graphics.print("R = ".. o.R, posX, posY + 10)
            love.graphics.setColor(1, 0, 0)
            love.graphics.line(posX, posY, posX + velX * radius * 10, posY + velY * radius * 10)
            love.graphics.setPointSize(5)
            love.graphics.points(posX, posY)
        end
    end

    engine = Engine()

    for _, p in pairs(particleList) do
        engine:addEntity(p)
    end
    engine:addSystem(MoveSystem())
    engine:addSystem(DrawSystem(), "draw")
end

function love.update(dt)
    engine:update(dt)
    fps = love.timer.getFPS()
    print(fps)
end

function love.draw()
    love.graphics.print("FPS : " ..fps, screenWidth - 150, 10)
    love.graphics.print("Particle count : " ..numOfParticles, screenWidth - 150, 40)
    love.graphics.print("tick count : " ..tick, screenWidth - 150, 60)
    engine:draw()
end
