local bees = {}
local player = require "player"

beeTimerMax = 5
beeTimer = beeTimerMax
beeSpeed = 600
beeImg = nil

bees.list = {}

function bees.load()
    beeImg = love.graphics.newImage('assets/bee.png')
end

function bees.update(dt)
    beeTimer = beeTimer - dt
    if beeTimer <= 0 then
        beeTimer = beeTimerMax
        -- Creates new bee
        rand = math.random(0, height - enemyImg:getHeight())
        newbee = { x = width + beeImg:getWidth(), y = rand, img = beeImg}
        table.insert(bees.list, newbee)
    end

    for i, bee in ipairs(bees.list) do
        bee.x = bee.x - (beeSpeed * dt)
        if bee.x < 0 - bee.x then
            table.remove(bees.list, i)
            player.health = player.health - 1
        end
    end
end

function bees.draw(dt)
    for i, bee in ipairs(bees.list) do
        love.graphics.draw(bee.img, bee.x, bee.y)
    end
end

return bees
