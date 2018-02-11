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
local bees = require "bees"
local chickens = require "chickens"
local projectiles = require "projectiles"
local collisions = require "collisions"

score = 0
font = nil

background = { x = 0, speed = 100 }

function love.load(arg)
	background.img = love.graphics.newImage("assets/background.png")

	player.load()
	enemies.load()
	bees.load()
	chickens.load()

	fontBig = love.graphics.newFont("assets/font.ttf", 72)
	fontSmall = love.graphics.newFont("assets/font.ttf", 36)
	debugFont = love.graphics.newFont("assets/font.ttf", 20)
end

function love.update(dt)
	width, height = love.graphics.getDimensions()

	-- Background
	if player.health > 0 then
		background.x = background.x + (background.speed * dt)
		if background.x > width then
			background.x = 0
		end
	end

	-- Exit the game
	if love.keyboard.isDown("escape") then
		love.event.push("quit")
	end

	player.update(dt)
	enemies.update(dt)
	bees.update(dt)
	chickens.update(dt)
	projectiles.update(dt)
	collisions.update(dt)

	-- Endgame
	if player.health <= 0 and love.keyboard.isDown("r") then
		projectiles.list = {}
		enemies.list = {}
		bees.list = {}
		chickens.list = {}

		player.health = player.healthMax
		player.canShoot = true
		player.shootTimer = 0
		player.shootLimit = 0

		enemyTimer = enemyTimerMax
		beesTimer = beesTimerMax
		chickenTimer = chickenTimerMax

		player.x = playerXDefault
		player.y = playerYDefault

		score = 0
	end
end

function love.draw(dt)
	-- Background
	love.graphics.draw(background.img, 0 - background.x, 0)
	if background.x > 0 then
		love.graphics.draw(background.img, background.img:getWidth() - background.x, 0)
	end

	for i = 0, love.graphics.getWidth() / background.img:getWidth() - background.x do
		love.graphics.draw(background.img, i * background.img:getWidth() - background.x, background.img:getHeight())
    end

	-- Debug
	if debug then
		love.graphics.setFont(debugFont)
		love.graphics.printf(tostring(love.timer.getFPS()), 20, love.graphics.getHeight()-38, love.graphics.getWidth(), "left")
	end

	-- Score
	love.graphics.setFont(fontSmall)
	love.graphics.printf(score, 0, 10, love.graphics.getWidth() - 20, "right")

	-- Game
	if player.health > 0 then
		player.draw(dt)
		enemies.draw(dt)
		bees.draw(dt)
		chickens.draw(dt)
		projectiles.draw(dt)
	else
		love.graphics.setFont(fontBig)
		love.graphics.printf("Press 'R' to restart", 0, love.graphics:getHeight() / 3, love.graphics.getWidth(), "center")
	end
end
