local background = {}
local player = require "player"


background = { x1 = 0, x2 = 0, x3 = 0, speed1 = 33, speed2 = 66, speed3 = 99, img1 = nil, img2 = nil, img3 = nil }

function background.load()
    -- Solid color background
    love.graphics.setBackgroundColor(140, 155, 155)

    background.img1 = love.graphics.newImage("assets/cave1.png")
    background.img2 = love.graphics.newImage("assets/cave2.png")
    background.img3 = love.graphics.newImage("assets/cave3.png")
end

function background.update(dt)
    if player.health > 0 and not endGame then
		background.x1 = background.x1 + (background.speed1 * dt)
		background.x2 = background.x2 + (background.speed2 * dt)
		background.x3 = background.x3 + (background.speed3 * dt)
		if background.x1 > width then
			background.x1 = 0
        end
        if background.x2 > width then
            background.x2 = 0
        end
        if background.x3 > width then
            background.x3 = 0
        end

	end
end

function background.draw(dt)
    love.graphics.draw(background.img1, 0 - background.x1, 0)
	if background.x1 > 0 then
		love.graphics.draw(background.img1, background.img1:getWidth() - background.x1, 0)
    end
	for i = 0, width / background.img1:getWidth() - background.x1 do
		love.graphics.draw(background.img1, i * background.img1:getWidth() - background.x1, background.img1:getHeight())
    end

    love.graphics.draw(background.img2, 0 - background.x2, 0)
	if background.x2 > 0 then
		love.graphics.draw(background.img2, background.img2:getWidth() - background.x2, 0)
    end
	for i = 0, width / background.img2:getWidth() - background.x2 do
		love.graphics.draw(background.img2, i * background.img2:getWidth() - background.x2, background.img2:getHeight())
    end

    love.graphics.draw(background.img3, 0 - background.x3, 0)
	if background.x3 > 0 then
		love.graphics.draw(background.img3, background.img1:getWidth() - background.x3, 0)
    end
	for i = 0, width / background.img3:getWidth() - background.x3 do
		love.graphics.draw(background.img3, i * background.img3:getWidth() - background.x3, background.img3:getHeight())
    end
end

return background