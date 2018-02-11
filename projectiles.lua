local projectiles = {}
local player = require "player"

projectiles.list = {}

function projectiles.update(dt)
    player.shootTimer = player.shootTimer - dt
    if player.shootTimer <= 0 then
        player.canShoot = true
    end

    if love.keyboard.isDown("space", "rctrl", "lctrl", "ctrl") and player.canShoot then
        player.canShoot = false
        player.shootTimer = player.shootTimerMax

        newProjectile = {
            x = player.x + player.img:getWidth() / 1.2,
            y = player.y + player.img:getHeight() / 2.2,
            img = player.projectileImg
        }
        table.insert(projectiles.list, newProjectile)
    end

    for i, projectile in ipairs(projectiles.list) do
        projectile.x = projectile.x + (player.projectileSpeed * dt)

        if projectile.x > width then
            table.remove(projectiles.list, i)
        end
    end
end

function projectiles.draw(dt)
    for i, projectile in ipairs(projectiles.list) do
        love.graphics.draw(projectile.img, projectile.x, projectile.y)
    end
end

return projectiles
