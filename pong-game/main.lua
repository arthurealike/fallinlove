local gameNameText = "Pong game"
local pauseScreenText = "R : restart\nT : time\nQ : Quit"
local fWidth  

function love.load()
    Object = require "classic"
    require "conf" 
    require "game"
        -- love.graphics.getWidth()
        -- love.graphics.getHeight()
    font = love.graphics.newFont("fonts/Pixels.ttf",108)
    love.graphics.setFont(font)
    fWidth = font:getWidth(gameNameText)
        -- pad1 = Pad.new(0,0,10,10)
    game = Game()

end

function love.keypressed(key)
    if(key == "space" or key == "escape") then
        game:toggleGameState()
    elseif(key == "t") then
        timeScale = (timeScale + 1) % 3
        changeTimeScale(timeScale)
    end
end

function love.update(dt)
    if(Game.state ~= 0) then
        game:update(dt)
    end
end

function drawPauseScreen()
    love.graphics.printf(pauseScreenText, (screenWidth / 2) - (font:getWidth(pauseScreenText) / 2),  100, 600, ("left"))
    love.graphics.setColor(1,1,1, 0.2)
end

function love.draw()
    if(Game.state == 0) then
        drawPauseScreen()
    end
    --love.graphics.setColor(1,1,1,0.5)
    love.graphics.printf(gameNameText, (screenWidth / 2) - (fWidth / 2),  screenHeight - 100, 500, ("left"))
    love.graphics.printf("time:"..timeScale, 0, -20  , 500, ("left"))

    game:draw()

end

function getFont() return font end

