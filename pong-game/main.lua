local gameNameText = "Pong game"
local fWidth  

function love.load()
    Object = require "classic"
    require "conf" 
    require "game"
        -- love.graphics.getWidth()
        -- love.graphics.getHeight()
    local pixelFont1 = love.graphics.newFont("fonts/Pixels.ttf",108)
    love.graphics.setFont(pixelFont1)
    fWidth = pixelFont1:getWidth(gameNameText)
        -- pad1 = Pad.new(0,0,10,10)
    game = Game()
    changeTimeScale(5)
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    love.graphics.printf(gameNameText, (screenWidth / 2) - (fWidth / 2), screenHeight - 100, 300, ("left"))
    game:draw()
end
