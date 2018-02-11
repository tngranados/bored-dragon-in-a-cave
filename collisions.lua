local collisions = {}
local player = require "player"
local enemies = require "enemies"
local projectiles = require "projectiles"

function collisions.update(dt)
    for i, enemy in ipairs(enemies.list) do
        for j, projectile in ipairs(projectiles.list) do
            if
                CheckCollision(
                    enemy.x,
                    enemy.y,
                    enemy.img:getWidth(),
                    enemy.img:getHeight(),
                    projectile.x,
                    projectile.y,
                    projectile.img:getWidth(),
                    projectile.img:getHeight()
                )
             then
                table.remove(enemies.list, i)
                table.remove(projectiles.list, j)
                score = score + 100
            end
        end

        if
            CheckCollision(
                enemy.x,
                enemy.y,
                enemy.img:getWidth(),
                enemy.img:getHeight(),
                player.x,
                player.y,
                player.img:getWidth(),
                player.img:getHeight()
            ) and player.isAlive
         then
            table.remove(enemies.list, i)
            player.isAlive = false
        end
    end
end

return collisions
