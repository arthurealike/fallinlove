Game = Object:extend()
local time = timeScale
local scoreBoard = { player1 = 0, player2 = 0}
--static variable
Game.colors = {}
Game.colors[1] = {1, 0, 0}
Game.colors[2] = {0, 0, 1}
Game.colors[3] = {0, 1, 0}

local timer = 0 
local timeToChangeLineNum = 1
local lineNum = 0

local delta = love.timer.getDelta()
function Game:new()
   require "pad"
   require "ball"

   pad0 = Pad(100,screenHeight/2,10,65)
   pad1 = Pad(screenWidth - 100,screenHeight/2,10,65)

   ball = Ball(screenHeight / 2, screenHeight / 2, 5)
   print("Game instance is initiated")

end

function changeTimeScale(newT)
    time = newT
end

function Game:update(dt)
    dt = dt * time
    timer = timer + dt
    print(timer)

    if timer > timeToChangeLineNum then
        timer = timer - timeToChangeLineNum
        lineNum = (lineNum + 1) % #Game.colors -- put this line without timer and see the magic
    end
    ball:update(dt)


    timer = timer + timer * dt      
    pad0:update(dt) 
end

function drawMidLine(num) 
    print("num = ".. num)
    for i=1,50 do
        local c = ((i + num) % #Game.colors) + 1
        if(colorfulMode) then
            love.graphics.setColor(Game.colors[c])
        end
        love.graphics.rectangle("fill", screenWidth / 2, i * 30 - 50, 2, 10)
    end
end

function Game:draw()
    local t = love.timer.getTime()
    t = 0 and 1
    
    drawMidLine(lineNum)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(tostring(scoreBoard.player1), screenWidth / 2 - 100, 0, 0)
    love.graphics.printf(tostring(scoreBoard.player2), screenWidth / 2 + 100, 0, 0)
    ball:draw()
    pad0:draw()
    pad1:draw()
end

