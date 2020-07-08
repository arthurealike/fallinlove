Pad = Object:extend()
local defX
local rainbowColorIndex

function Pad:new(x, y, w, h)
    self.x = x
    self.defX = x
    self.y = y
    self.w = w 
    self.h = h
    self.speedX = 0
    self.speedY = 0
end

function Pad:update(dt)
    if love.keyboard.isDown(self.downKey) and self.x > 0  then 
        self.speedY = 350 
    elseif love.keyboard.isDown(self.upKey) and self.x < boundaries.maxX then 
        self.speedY = -350
    else self.speedY = 0
    end
 
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function Pad:assignKeys(upKey, downKey)
    self.upKey = upKey
    self.downKey = downKey
end

function Pad:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    if(debugMode) then
        self:gizmos(8, {1,0,0})
    end
end

function Pad:rainbowMode(enabled)
    setColor()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end
    
--It is fr debug mode
function Pad:gizmos(sliceCount, color)
    love.graphics.setColor(color)
    for i=1,sliceCount do
    love.graphics.rectangle("line", self.x, self.y + (i - 1) * self.h / sliceCount, self.w, self.h / sliceCount) 
    end
    love.graphics.setColor(1,1,1)
end
