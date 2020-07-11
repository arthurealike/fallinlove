Ball = Object:extend()

local colorNum = 0
local directionX, directionY = 1, 1

function Ball:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.speedX = 150
    self.speedY = 0
    self.defaultSpeedX = 300
    self.defaultSpeedY = 65
end

local defaultFilter = function()
    return 'bounce'
end

function Ball:update(dt)
    local currentDirX, currentDirY = directionX, directionY

    local goalX, goalY = self.x + self.speedX * dt, self.y + self.speedY * dt
    local actualX, actualY, cols, len = world:move(ball, goalX, goalY, defaultFilter)
    
    self.x, self.y  = actualX, actualY

    -- Pad collision 
    if len > 0 then
        local col = cols[1]

        directionX = 1
        if col.touch.x > boundaries.maxX / 2 then
            directionX = -1
        end
        
        local distanceY = col.other.y + 65 / 2 - col.touch.y
        local dirY = -1

        if distanceY < 0 then dirY = 1 end
        distanceY = math.abs(distanceY)

        distanceY =  distanceY * dirY
        directionY = (distanceY / 5)

       self:bounce(directionX, directionY)
    end 
    colorNum = (colorNum + 1) 
  
  --[[
        Wall bounce
    ]]

    if self.x >= screenWidth - self.radius+1 then
       self:bounce(-math.abs(directionX), 0)
    end

    if  self.x <= 0 + self.radius-1 then
       self:bounce(math.abs(directionX), 0)
    end

    if self.y >= screenHeight - self.radius+1 then
        -- bottom wall
        self:bounce(0, -math.abs(directionY))
    end

    if self.y <= 0 + self.radius-1 then
        self:bounce(0, math.abs(directionY))
    end

end

function Ball:reset(scorer)
    directionX, directionY = 1, -1 

    local direction = scorer.pad.p == 0 and -1 or 1
    self.speedX = self.defaultSpeedX * direction

    self.speedY = 0 * math.random(-1, 1)
end

function Ball:bounce(directionX, directionY)
    if(directionX ~= 0) then
        self.speedX = directionX * self.defaultSpeedX
    end
    if directionY == nil then
        self.speedY = 0
    elseif(directionY ~=  0) then
        self.speedY = directionY * self.defaultSpeedY 
    end
end

function Ball:gizmos(lineCount, color)
    love.graphics.setColor(color)
    for i=1,lineCount do
        love.graphics.line(self.x, self.y, self.x + self.speedX * 5, self.y + self.speedY * 5)
    end
    love.graphics.setColor(1,1,1)
end


function Ball:draw()
--    love.graphics.setColor(Game.colors[colorNum % 3 + 1]) 
    love.graphics.circle("fill", self.x, self.y, self.radius)
    if(debugMode) then
        self:gizmos(1, {1,0,0})
    end
end
