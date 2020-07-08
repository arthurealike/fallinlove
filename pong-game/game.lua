require "player"
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
local scoreBoardText
local sTextWidth

boundaries = {}
boundaries.minX=0
boundaries.maxX=screenWidth
boundaries.minY=0
boundaries.maxY=screenHeight

Game.state = 0
local c = 0

function Game:new()
   require "pad"
   require "ball"

   pad0 = Pad(100, screenHeight/2,10,65)
   pad1 = Pad( screenWidth - 100, screenHeight/2,10,65)

   player0 = Player(pad0,"w","s")
   player1 = Player(pad1, "up","down")

   ball = Ball( screenHeight / 2,  screenHeight / 2, 5)
   scoreBoardText = tostring(scoreBoard.player1 .. "   " .. scoreBoard.player2)
   sTextWidth = fonth1:getWidth(scoreBoardText)
end

function Game:reset()
    pad0.x = 100
    pad0.y = boundaries.maxY / 2
    pad1.x = boundaries.maxX - 100
    pad1.y = boundaries.maxY / 2

    ball.x = boundaries.maxX / 2 
    ball.y = boundaries.maxY / 2
    ball:reset()
end

function Game:toggleGameState()
    if(Game.state == 1) then
        Game.state = 0
    else
        Game.state = 1
    end
end

function changeTimeScale(newT)
    time = newT
end

function Game:update(dt)
    dt = dt * time
    timer = timer + dt

    if timer > timeToChangeLineNum then
        timer = timer - timeToChangeLineNum
        lineNum = (lineNum + 1) % #Game.colors -- put this line without timer and see the magic
    end
    
    ball:update(dt)

    player0:update(dt)
    player1:update(dt)

    if ball.x > pad0.x - ball.radius and ball.y <= pad0.y + pad0.h and ball.y >= pad0.y - ball.radius then
        c = c + 1
    end

    timer = timer + timer * dt      
end

function drawMidLine(num) 
    for i=1,50 do
        local c = ((i + num) % #Game.colors) + 1
        if(colorfulMode) then
            love.graphics.setColor(Game.colors[c])
        end
        love.graphics.rectangle("fill",  screenWidth / 2, i * 30 - 50, 2, 10)
    end
end

function Game:drawScoreBoard()
    love.graphics.printf(scoreBoardText,  screenWidth/2 - (sTextWidth / 2), 10, 300, ("left"))
end

function Game:draw()
    --pad0:draw()
    --pad1:draw()
    player0:draw()
    player1:draw()
    
    self:drawScoreBoard()
    local t = love.timer.getTime()
    t = 0 and 1

    drawMidLine(lineNum)
    
    love.graphics.setColor(1,1,1)
    --love.graphics.setColor(1, 1, 1)
    
    ball:draw()

end
