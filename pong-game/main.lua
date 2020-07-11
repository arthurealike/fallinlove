local gameNameText = "Press space"
local pauseScreenText = "R : restart\nT : time\nQ : Quit"
local pixelFontPath = "fonts/Pixels.ttf"
local gameNameTextWidth 

function love.load()
    Object = require "classic"
    require "conf" 
    require "game"

    fonth1 = love.graphics.newFont(pixelFontPath, 108)
    fonth2 = love.graphics.newFont(pixelFontPath, 72)
    fonth3 = love.graphics.newFont(pixelFontPath, 54)
    
    gameNameTextWidth = fonth1:getWidth(gameNameText)
    game = Game(5)
end

function love.keypressed(key)
    if key == "space" or key == "escape" then
        game:toggleGameState()
    if Game.state ~= 1 then
        return nil
    end
    elseif key == "t" and Game.state == 0 then
        timeScale = (timeScale + 1) % timeScaleUpperLimit
        if timeScale == 0 then timeScale = 1 end
        changeTimeScale(timeScale)
    elseif key == "q" and Game.state == 0 then
        love.event.quit()
    elseif key == "r" and Game.state == 0 then
            game:reset()
    end
end

function love.update(dt)
    if(Game.state ~= 0) then
        game:update(dt)
    end
end

function drawPauseScreen()
    love.graphics.printf(pauseScreenText, (screenWidth / 2) - (fonth1:getWidth(pauseScreenText) / 2),  100, 600, ("left"))
    love.graphics.setColor(1,1,1, 0.15)
end

function love.draw()
    love.graphics.setFont(fonth1)

    love.graphics.printf(gameNameText, (screenWidth / 2) - (gameNameTextWidth / 2),  screenHeight - 100, 1000, ("left"))
    love.graphics.setFont(fonth2)
    love.graphics.printf("time:"..timeScale, 20, 0  , 500, ("left"))
    love.graphics.setFont(fonth1)
    game:draw()

    if(Game.state == 0) then
        drawPauseScreen()
    end
end

function getFont() return font end

