local enemies = {}
local player = require "player"

enemyTimerMax = 0.7
enemyTimer = enemyTimerMax
enemySpeed = 300
enemyImg = nil

enemies.list = {}

function enemies.load()
    enemyImg = love.graphics.newImage('assets/bat.png')
end

function enemies.update(dt)
    enemyTimer = enemyTimer - dt
    if enemyTimer <= 0 then
    enemyTimer = enemyTimerMax
    -- Create new enemy
    rand = math.random(0, height - enemyImg:getHeight())
    newEnemy = { x = width + enemyImg:getWidth(), y = rand, img = enemyImg}
    table.insert(enemies.list, newEnemy)
    end

    for i, enemy in ipairs(enemies.list) do
        enemy.x = enemy.x - (enemySpeed * dt)
        if enemy.x < 0 - enemy.x then
            table.remove(enemies.list, i)
            player.isAlive = false
        end
    end
end

function enemies.draw(dt)
    for i, enemy in ipairs(enemies.list) do
        love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end
end

return enemies
