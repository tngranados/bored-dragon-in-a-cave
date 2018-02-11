playerXDefault = 70
playerYDefault = 270

local player = {
    x = playerXDefault,
    y = playerYDefault,
    xSpeed = 700,
    ySpeed = 550,
    img = nil,
    canShoot = true,
    shootTimerMax = 0.2,
    shootTimer = 0,
    projectileImg = nil,
    projectileSpeed = 1000,
    isAlive = true
}

function player.load()
    player.img = love.graphics.newImage("assets/dragon.png")
    player.projectileImg = love.graphics.newImage("assets/fireball.png")
end

function player.update(dt)
    -- Up and down movement
    if love.keyboard.isDown("up", "w") then
        player.y = player.y - (player.ySpeed * dt)
    end
    if love.keyboard.isDown("down", "s") then
        player.y = player.y + (player.ySpeed * dt)
    end

    -- Left and right movement
    if love.keyboard.isDown("left", "a") then
        player.x = player.x - (player.xSpeed * dt)
    end
    if love.keyboard.isDown("right", "d") then
        player.x = player.x + (player.xSpeed * dt)
    end

    -- Screen limits
    if player.x < 0 then
        player.x = 0
    end
    if player.x > width - player.img:getWidth() then
        player.x = width - player.img:getWidth()
    end
    if player.y < 0 then
        player.y = 0
    end
    if player.y > height - player.img:getHeight() then
        player.y = height - player.img:getHeight()
    end
end

function player.draw(dt)
    love.graphics.draw(player.img, player.x, player.y)
end

return player
