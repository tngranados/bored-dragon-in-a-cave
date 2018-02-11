local eyeBeast = {}
local player = require "player"
local enemies = require "enemies"
local bees = require "bees"
local chickens = require "chickens"

eyeBeast = {
    img = nil,
    xSpeed = 200,
    ySpeed = 300,
    healthMax = 25,
    health = 25,
    isAlive = false,
    direction = "",
    bombTimerMax = 1.2,
    bombTimer = 0.5,
    bombSpeed = 400,
    bombImg = nil,
}

eyeBeast.bombsList = {}

bossBattle = false
bossBattleScore = 8000

function eyeBeast.load()
    eyeBeast.img = love.graphics.newImage("assets/eyebeast.png")
    eyeBeast.bombImg = love.graphics.newImage("assets/ball.png")
end

function eyeBeast.update(dt)
    if score > bossBattleScore then
        bossBattle = true
        if #enemies.list + #bees.list + #chickens.list == 0 then
            if not eyeBeast.isAlive then
                -- Create eye beast
                rand = math.random(0, height - eyeBeast.img:getHeight())
                eyeBeast.x = width
                eyeBeast.y = rand
                eyeBeast.targetY = eyeBeast.y
                eyeBeast.isAlive = true
            end

            -- Bombs
            eyeBeast.bombTimer = eyeBeast.bombTimer - dt
            if eyeBeast.bombTimer <= 0 then -- Create bomb
                newBomb = {
                    x = eyeBeast.x - 20,
                    y = eyeBeast.y + eyeBeast.img:getHeight() / 2,
                    img = eyeBeast.bombImg
                }
                table.insert(eyeBeast.bombsList, newBomb)
                eyeBeast.bombTimer = eyeBeast.bombTimerMax
            end

            for i, bomb in ipairs(eyeBeast.bombsList) do
                bomb.x = bomb.x - (eyeBeast.bombSpeed * dt)

                if bomb.x > width then
                    table.remove(eyeBeast.bombsList, i)
                end
            end

            -- Health regen
            if eyeBeast.health < eyeBeast.healthMax then
                eyeBeast.health = eyeBeast.health + dt * 0.7
            end

            if eyeBeast.x > width - eyeBeast.img:getWidth() - 10 then
                eyeBeast.x = eyeBeast.x - (eyeBeast.xSpeed * dt)
            else
                -- Eye Beast random vertical movement
                -- If there is movement left, do it
                if eyeBeast.y <= 0 then
                    eyeBeast.y = 0
                end
                if eyeBeast.y >= height - eyeBeast.img:getHeight() then
                    eyeBeast.y = height - eyeBeast.img:getHeight()
                end

                if eyeBeast.direction == "down" and eyeBeast.targetY > eyeBeast.y then
                    eyeBeast.y = eyeBeast.y + (eyeBeast.ySpeed * dt)
                elseif eyeBeast.direction == "up" and eyeBeast.targetY < eyeBeast.y then
                    eyeBeast.y = eyeBeast.y - (eyeBeast.ySpeed * dt)
                else
                    -- If there is no movement currently, create one
                    upperSpace = eyeBeast.y
                    bottomSpace = height - eyeBeast.y - eyeBeast.img:getHeight()
                    if upperSpace > bottomSpace then
                        eyeBeast.direction = "up"
                        eyeBeast.targetY = math.random(eyeBeast.y, eyeBeast.y - upperSpace)
                    else
                        eyeBeast.direction = "down"
                        eyeBeast.targetY = math.random(eyeBeast.y, eyeBeast.y + bottomSpace)
                    end
                end
            end
        end
    end
end

function eyeBeast.draw(dt)
    if eyeBeast.isAlive then
        love.graphics.draw(eyeBeast.img, eyeBeast.x, eyeBeast.y)

        -- Health bar
        love.graphics.setColor(33, 39, 39)
        love.graphics.rectangle("fill", eyeBeast.x, eyeBeast.y - 20, eyeBeast.img:getWidth(), 10)
    
        if eyeBeast.health >= eyeBeast.healthMax / 2 then -- 50% to 100%
            love.graphics.setColor(153, 204, 51) -- green
        elseif eyeBeast.health >= eyeBeast.healthMax / 4 then -- 25% to 50%
            love.graphics.setColor(254, 203, 102) -- yellow
        else
            love.graphics.setColor(217, 25, 33) -- red
        end
        love.graphics.rectangle("fill", eyeBeast.x, eyeBeast.y - 20, eyeBeast.img:getWidth()/eyeBeast.healthMax*eyeBeast.health, 10)
        love.graphics.setColor(255,255,255) -- reset colors

        -- Bombs
        for i, bomb in ipairs(eyeBeast.bombsList) do
            love.graphics.draw(bomb.img, bomb.x, bomb.y)
        end
    end
end

return eyeBeast
