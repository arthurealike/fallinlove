Player = Object:extend()

function Player:new(pad,upKey,downKey)
    self.pad = pad
    self.upKey = upKey
    self.downKey = downKey
    self.pad:assignKeys(upKey, downKey)
    self.score = 0
end

function Player:update(dt)
    self.pad:update(dt)
end

function Player:draw()
    self.pad:draw()
end
