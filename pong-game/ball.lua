Ball = Object:extend()

local colorNum = 0
function Ball:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.speedX = 300
    self.speedY = 65
end

function Ball:update(dt)
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt

    colorNum = (colorNum + 1) 
  
    if self.x >=  screenWidth - self.radius+1 then
       self:bounce(-1, 0)
    end

    if  self.x <= 0 + self.radius-1 then
       self:bounce(1, 0)
    end

    if self.y >=  screenHeight - self.radius+1 then
        self:bounce(0, -1)
    end

    if self.y <= 0 + self.radius-1 then
        self:bounce(0, 1)
    end
end

function Ball:bounce(directionX, directionY)
    if(directionX ~= 0) then
        self.speedX = directionX * math.abs(self.speedX)
    end
    if(directionY ~=  0) then
        self.speedY = directionY * math.abs(self.speedY) 
    end
end

function Ball:gizmos(lineCount, color)
    love.graphics.setColor(color)
    for i=1,lineCount do
        love.graphics.line(self.x, self.y, self.x + self.speedX * 5, self.y + self.speedY * 5)
    end
    love.graphics.setColor(1,1,1)
end

function Ball:reset()
    self.x =  screenWidth / 2
    self.y =  screenHeight / 2
end

function Ball:draw()
--    love.graphics.setColor(Game.colors[colorNum % 3 + 1]) 
    love.graphics.circle("fill", self.x, self.y, self.radius)
    if(debugMode) then
        self:gizmos(1, {1,0,0})
    end
end
