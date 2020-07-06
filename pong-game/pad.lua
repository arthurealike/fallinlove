Pad = Object:extend()

local defX

function Pad:new(x, y, w, h)
    self.x = x
    self.defX = x
    self.y = y
    self.w = w 
    self.h = h
    self.speedX = 0
    self.speedY = 0
end

function Pad:getDamage(damageInt)
    self.x = self.x - damageInt
end

function Pad:changeSpeed(speedFactor)
    
end

function Pad:update(dt)
    if love.keyboard.isDown("down") then 
        self.speedY = 200 
    elseif love.keyboard.isDown("up") then 
        self.speedY = -200
    else self.speedY = 0
    end
    
    if love.keyboard.isDown("space") then 
       self:getDamage(2)
       print("Damage received")
       else self.x = self.defX
   end
 
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function Pad:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

