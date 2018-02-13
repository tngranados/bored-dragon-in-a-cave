local collisions = {}
local player = require "player"
local enemies = require "enemies"
local bees = require "bees"
local eyeBeast = require "eyebeast"
local chickens = require "chickens"
local projectiles = require "projectiles"

function collisions.update(dt)
    -- Enemies
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
            ) and player.health > 0
         then
            table.remove(enemies.list, i)
            player.health = player.health - 1
        end
    end

    -- Bees
    for i, bee in ipairs(bees.list) do
        for j, projectile in ipairs(projectiles.list) do
            if
                CheckCollision(
                    bee.x,
                    bee.y,
                    bee.img:getWidth(),
                    bee.img:getHeight(),
                    projectile.x,
                    projectile.y,
                    projectile.img:getWidth(),
                    projectile.img:getHeight()
                )
             then
                table.remove(bees.list, i)
                table.remove(projectiles.list, j)
                score = score + 500
            end
        end

        if
            CheckCollision(
                bee.x,
                bee.y,
                bee.img:getWidth(),
                bee.img:getHeight(),
                player.x,
                player.y,
                player.img:getWidth(),
                player.img:getHeight()
            ) and player.health > 0
         then
            table.remove(bees.list, i)
            player.health = player.health - 1
        end
    end

    -- EyeBeast
    if eyeBeast.isAlive then
        for j, projectile in ipairs(projectiles.list) do
            if
                CheckCollision(
                    eyeBeast.x,
                    eyeBeast.y,
                    eyeBeast.img:getWidth(),
                    eyeBeast.img:getHeight(),
                    projectile.x,
                    projectile.y,
                    projectile.img:getWidth(),
                    projectile.img:getHeight()
                )
            then
                eyeBeast.health = eyeBeast.health - 1
                if eyeBeast.health <= 0 then
                    score = score + 5000
                    score = score + 1000 * (player.health - 1)
                    endGame = true
                end
                table.remove(projectiles.list, j)
            end
        end

        for j, bomb in ipairs(eyeBeast.bombsList) do
            if
                CheckCollision(
                    player.x,
                    player.y,
                    player.img:getWidth(),
                    player.img:getHeight(),
                    bomb.x,
                    bomb.y,
                    bomb.img:getWidth(),
                    bomb.img:getHeight()
                )
            then
                player.health = player.health - 1
                table.remove(eyeBeast.bombsList, j)
            end
        end

        if
            CheckCollision(
                eyeBeast.x,
                eyeBeast.y,
                eyeBeast.img:getWidth(),
                eyeBeast.img:getHeight(),
                player.x,
                player.y,
                player.img:getWidth(),
                player.img:getHeight()
            ) and player.health > 0
        then
            player.health = 0
        end
    end


    -- Chickens
    for i, chicken in ipairs(chickens.list) do
        for j, projectile in ipairs(projectiles.list) do
            if
                CheckCollision(
                    chicken.x,
                    chicken.y,
                    chicken.img:getWidth(),
                    chicken.img:getHeight(),
                    projectile.x,
                    projectile.y,
                    projectile.img:getWidth(),
                    projectile.img:getHeight()
                )
             then
                table.remove(chickens.list, i)
                table.remove(projectiles.list, j)
            end
        end

        if
            CheckCollision(
                chicken.x,
                chicken.y,
                chicken.img:getWidth(),
                chicken.img:getHeight(),
                player.x,
                player.y,
                player.img:getWidth(),
                player.img:getHeight()
            )
         then
            table.remove(chickens.list, i)
            if player.health < player.healthMax then
                player.health = player.health + 1
            end
            score = score + 1000
            player.shootLimit = 0
        end
    end
end

return collisions
