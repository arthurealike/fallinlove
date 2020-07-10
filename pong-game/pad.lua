Pad = Object:extend()
local rainbowColorIndex
--direction

function Pad:new(p, x, y, w, h)
    self.p = p
    self.x = x
    self.y = y
    self.w = w 
    self.h = h
    self.gX = self.x + self.w / 2
    self.gY = self.y + self.h / 2
    self.speedX = 0
    self.speedY = 0
    self.color = Game.colors["player0"]
    self.direction = -1
    if p ~= 0 then
        self.direction = 1
        self.color = Game.colors["player1"]
    end
end

function Pad:update(dt)
    self.gX = self.x + self.w / 2
    self.gY = self.y + self.h / 2
    if love.keyboard.isDown(self.downKey) and self.y + self.h < boundaries.maxY  then 
        self.speedY = 200 
    elseif love.keyboard.isDown(self.upKey) and self.y  > boundaries.minY then 
        self.speedY = -200
    else self.speedY = 0
    end
 
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function Pad:assignKeys(upKey, downKey)
    self.upKey = upKey
    self.downKey = downKey
end

function Pad:drawTriangle()
    love.graphics.setColor(self.color)
    love.graphics.polygon("line", self.gX + 10 * self.direction, self.gY, self.gX + 20 * self.direction, self.gY + 10, self.gX + 20 * self.direction, self.gY -10)
    love.graphics.setColor(1,1,1)
end

function Pad:draw()
    self:drawTriangle()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    if(debugMode) then
        self:gizmos(8, self.color)
    end
end

function Pad:rainbowMode(enabled)
    setColor()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end
    
--It is for debug mode
function Pad:gizmos(sliceCount, color)
    love.graphics.setColor(color)

    love.graphics.setPointSize(10)
    love.graphics.points(self.gX, self.gY)

    for i=1,sliceCount do
        love.graphics.rectangle("line", self.x, self.y + (i - 1) * self.h / sliceCount, self.w, self.h / sliceCount) 
    end
end
