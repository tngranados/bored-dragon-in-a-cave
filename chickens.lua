local chickens = {}
local player = require "player"

chickenTimerMax = 12
chickenTimer = chickenTimerMax
chickenSpeed = 200
chickenImg = nil

chickens.list = {}

function chickens.load()
    chickenImg = love.graphics.newImage('assets/chicken.png')
end

function chickens.update(dt)
    chickenTimer = chickenTimer - dt
    if chickenTimer <= 0 then
        chickenTimer = chickenTimerMax
        -- Creates new chicken
        rand = math.random(0, height - enemyImg:getHeight())
        newChicken = { x = width + chickenImg:getWidth(), y = rand, img = chickenImg}
        table.insert(chickens.list, newChicken)
    end

    for i, chicken in ipairs(chickens.list) do
        chicken.x = chicken.x - (chickenSpeed * dt)
        if chicken.x < 0 - chicken.x then
            table.remove(chickens.list, i)
        end
    end
end

function chickens.draw(dt)
    for i, chicken in ipairs(chickens.list) do
        love.graphics.draw(chicken.img, chicken.x, chicken.y)
    end
end

return chickens
