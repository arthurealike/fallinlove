--package.path = package.path .. ";fallinlöve/libs/?.lua"

--local Object = require("?;?.lua;/fallinlöve/libs/classic.lua")

package.path = package.path .. "?;../libs/?.lua"

Object = require("classic")

function love.load()

end

function love.update(dt)

    for i, file in pairs(love.filesystem.getDirectoryItems("..")) do
        print(i, file)
    end
end

function love.draw()

end

