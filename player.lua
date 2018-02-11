playerXDefault = 70
playerYDefault = 270

local player = {
    x = playerXDefault,
    y = playerYDefault,
    healthMax = 3,
    health = 3,
    xSpeed = 700,
    ySpeed = 550,
    img = nil,
    canShoot = true,
    shootTimerMax = 0.2,
    shootTimer = 0,
    shootLimitMax = 10,
    shootLimit = 0,
    shootLimitTimerMax = 0.6,
    shootLimitTimer = 0,
    projectileImg = nil,
    projectileSpeed = 1500,
    healthImg = nil,
    healthBWImg = nil,
}

function player.load()
    player.img = love.graphics.newImage("assets/dragon.png")
    player.projectileImg = love.graphics.newImage("assets/fireball.png")

    player.healthImg = love.graphics.newImage("assets/health.png")
    player.healthBWImg = love.graphics.newImage("assets/health_bw.png")
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
    
    love.graphics.setColor(33, 39, 39)
    love.graphics.rectangle("fill", player.x, player.y - 20, player.img:getWidth(), 10)

    if player.shootLimitMax / 2 >= player.shootLimit then -- 0% to 50%
        love.graphics.setColor(153, 204, 51) -- green
    elseif player.shootLimitMax / 5 * 4 >= player.shootLimit then -- 50% to 80%
        love.graphics.setColor(254, 203, 102) -- yellow
    else
        love.graphics.setColor(217, 25, 33) -- red
    end
    love.graphics.rectangle("fill", player.x, player.y - 20, player.img:getWidth()/player.shootLimitMax*player.shootLimit, 10)
    love.graphics.setColor(255,255,255) -- reset colors

    -- Health
    for i = 1, player.healthMax, 1 do
        if i <= player.health then
            love.graphics.draw(player.healthImg, 20 + i * player.healthImg:getWidth(), 10)
        else
            love.graphics.draw(player.healthBWImg, 20 + i * player.healthBWImg:getWidth(), 10)
        end
    end
end

return player
