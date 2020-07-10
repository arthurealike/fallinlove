require "player"
local bump = require 'bump'
world = bump.newWorld()

Game = Object:extend()
local time = timeScale
local scoreBoard = { player1 = 0, player2 = 0}

--pads,ball
local gameObjects = {}
--static variable
Game.colors = {}
Game.colors[1] = {0.937, 0.341, 0.466} --   {1, 0, 0}
Game.colors[2] = {0.235, 0.250, 0.776} -- {0, 0, 1}
Game.colors[3] = {0.058, 0.737, 0.976} --  {0, 1, 0}
Game.colors[4] = {1, 0.752, 0.282}
Game.colors[5] = {0.043, 0.909, 0.505}
Game.colors[6] = {0.203, 0.905, 0.894}
Game.colors[7] = {0.882, 0.203, 0.905}
Game.colors[8] = {1, 0, 0}
Game.colors[9] = {0, 0, 1}
Game.colors[10] = {0, 1, 0}
Game.colors[11] = {0.976, 0.517, 0.023}
Game.colors["player0"] = {1,0,0}
Game.colors["player1"] = {0,0,1}

local timer = 0 
local timeToChangeLineNum = 1
local lineNum = 0

local delta = love.timer.getDelta()

local scoreBoardText
local sTextWidth

local isBallEnabled = true

boundaries = {}
boundaries.minX=0
boundaries.maxX=screenWidth
boundaries.minY=0
boundaries.maxY=screenHeight

Game.state = 0
local c = 0

function Game:new(scoreLimit)
   require "pad"
   require "ball"

   self.scoreLimit = scoreLimit

   pad0 = Pad(0, 100, screenHeight/2,10,65)
   pad1 = Pad(1, screenWidth - 100, screenHeight/2,10,65)

   table.insert(gameObjects,pad0)
   table.insert(gameObjects,pad1)
   
   player0 = Player(pad0,"w","s")
   player1 = Player(pad1, "up","down")

   table.insert(gameObjects,player0)
   table.insert(gameObjects,player1)
   ball = Ball( screenHeight / 2,  screenHeight / 2, 5)

   table.insert(gameObjects,ball) 
   scoreBoardText = tostring(scoreBoard.player1 .."   ".. scoreBoard.player2)
   sTextWidth = fonth1:getWidth(scoreBoardText)
   
    world:add(pad0, pad0.x, pad0.y, pad0.w, pad0.h)
    world:add(pad1,pad1.x, pad1.y, pad1.w, pad1.h)
    world:add(ball, ball.x, ball.y, ball.radius, ball.radius)
end

function Game:reset()
    timeScale = 1
    time = 1
    pad0.x = 100
    pad0.y = boundaries.maxY / 2
    pad1.x = boundaries.maxX - 100
    pad1.y = boundaries.maxY / 2

    ball.x = boundaries.maxX / 2 
    ball.y = boundaries.maxY / 2
    ball:reset()

    player0.score = 0
    player1.score = 0
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

    for i, go in ipairs(gameObjects) do
        go:update(dt)
    end

    world:update(pad0, pad0.x, pad0.y, pad0.w, pad0.h)
    world:update(pad1,pad1.x, pad1.y, pad1.w, pad1.h)
    world:update(ball, ball.x, ball.y, ball.radius, ball.radius)

    
    -- collision pad bt ball
   -- if ball.x > pad0.x - ball.radius and ball.y <= pad0.y + pad0.h and ball.y >= pad0.y - ball.radius then
   --    -- ball.gX -> midP x 
   --    -- ball.gY -> midP y
   --    -- ball.gX + (ball.w / 2) -> topP X
   --    -- ball.gY + (ball.h / 2) -> topP Y
   --    -- ball.
   --     c = c + 1
   --     print("bounced")
   -- end

    timer = timer + timer * dt      
end

function Game:drawScoreLines(pad0, pad1)
    love.graphics.setColor(1,1,1,0.4)
    love.graphics.line(pad0.x + pad0.w / 2, boundaries.maxY, pad0.x + pad0.w / 2, boundaries.minY)
    love.graphics.line(pad1.x + pad1.w / 2, boundaries.maxY, pad1.x + pad1.w / 2, boundaries.minY)
    love.graphics.setColor(1,1,1,1)

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

function spawnParticles()
    for i=1, #Game.colors do            
        love.graphics.circle("fill", math.random(boundaries.minX, boundaries.maxX), math.random(boundaries.minY, boundaries.maxY), 5)
    end
end

function Game:score() 
    if ball.x < pad0.x + pad0.w / 2 then
        if isBallEnabled == true then
            player1.score = player1.score + 1 
            if player1.score >= self.scoreLimit and endlessMode ~= true then
                print("player right won")
            end
            isBallEnabled = false
        end
    elseif ball.x > pad1.x + pad1.w / 2 then
        if isBallEnabled == true then
            player0.score = player0.score + 1 
            if player1.score >= self.scoreLimit and endlessMode ~= true  then
                print("player left won")
            end
            isBallEnabled = false
        end
    else isBallEnabled = true

    scoreBoardText = tostring(player0.score .. "   " .. player1.score ..  "   ")
    end
end

function Game:translate()
    love.graphics.rectangle("fill", 0, boundaries.maxX, 0, boundaries.maxY)
    love.graphics.rectangle("fill", 0, boundaries.maxX, 0, boundaries.maxY)
end

function Game:drawScoreBoard()
    love.graphics.printf(scoreBoardText, screenWidth/2 - fonth1:getWidth(scoreBoardText) / 2, 10, fonth1:getWidth(scoreBoardText), "center")
end

function Game:draw()
    self:drawScoreBoard()
    self:drawScoreLines(pad0,pad1)

    for i, go in ipairs(gameObjects) do
        go:draw()
    end
 
    self:score()

    local t = love.timer.getTime()
    t = 0 and 1

    drawMidLine(lineNum)
    
    love.graphics.setColor(1,1,1)
end

