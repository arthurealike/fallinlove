Ball = Object:extend()

function Ball:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.speedX = 100
    self.speedY = 95
end

function Ball:update(dt)
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt

    print("ball pos= ".. self.x .. " and " .. self.y)
    if self.x > screenWidth - self.radius or self.x < 0 + self.radius then
        self.speedX = -(self.speedX)
    else if self.y > screenHeight - self.radius or self.y < 0 + self.radius then
        self.speedY = -(self.speedY)
    end
end
end

function Ball:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
