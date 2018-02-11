debug = true

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Variables
local player = require "player"
local enemies = require "enemies"
local projectiles = require "projectiles"
local collisions = require "collisions"

score = 0

brackgroundImg = nil

font = nil

function love.load(arg)
	backgroundImg = love.graphics.newImage("assets/background.png")

	player.load()
	enemies.load()

	fontBig = love.graphics.newFont("assets/font.ttf", 72)
	fontSmall = love.graphics.newFont("assets/font.ttf", 36)
	debugFont = love.graphics.newFont("assets/font.ttf", 20)
end

function love.update(dt)
	width, height = love.graphics.getDimensions()

	-- Exit the game
	if love.keyboard.isDown("escape") then
		love.event.push("quit")
	end

	player.update(dt)
	enemies.update(dt)
	projectiles.update(dt)
	collisions.update(dt)

	-- Endgame
	if not player.isAlive and love.keyboard.isDown("r") then
		projectiles.list = {}
		enemies.list = {}

		player.isAlive = true
		player.canShoot = true
		player.shootTimer = player.shootTimerMax

		enemyTimer = enemyTimerMax

		player.x = playerXDefault
		player.y = playerYDefault

		score = 0
	end
end

function love.draw(dt)
	love.graphics.draw(backgroundImg, 0, 0)

	-- Debug
	if debug then
		love.graphics.setFont(debugFont)
		love.graphics.printf(tostring(love.timer.getFPS()), 20, 10, love.graphics.getWidth(), "left")
	end

	-- Score
	love.graphics.setFont(fontSmall)
	love.graphics.printf(score, 0, 10, love.graphics.getWidth() - 20, "right")

	-- Game
	if player.isAlive then
		player.draw(dt)
		enemies.draw(dt)
		projectiles.draw(dt)
	else
		love.graphics.setFont(fontBig)
		love.graphics.printf("Press 'R' to restart", 0, love.graphics:getHeight() / 3, love.graphics.getWidth(), "center")
	end
end
