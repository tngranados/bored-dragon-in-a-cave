debug = true

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- Variables
playerXDefault = 70
playerYDefault = 270

player = { x = playerXDefault, y = playerYDefault, xSpeed = 700, ySpeed = 550, img = nil, canShoot = true, shootTimerMax = 0.2, shootTimer = 0, projectileImg = nil, projectileSpeed = 1000, isAlive = true}
score = 0
projectiles = {}

enemies = {}
enemyTimerMax = 0.7
enemyTimer = enemyTimerMax
enemySpeed = 300
enemyImg = nil

brackgroundImg = nil

font = nil


function love.load(arg)
  backgroundImg = love.graphics.newImage('assets/background.png')
  player.img = love.graphics.newImage('assets/dragon.png')
  player.projectileImg = love.graphics.newImage('assets/fireball.png')
  enemyImg = love.graphics.newImage('assets/bat.png')
  fontBig = love.graphics.newFont("assets/font.ttf", 72)
  fontSmall = love.graphics.newFont("assets/font.ttf", 36)
  love.graphics.setFont(fontSmall)

end

function love.update(deltaTime)
  width, height = love.graphics.getDimensions()

  -- Exit the game
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  -- Up and down movement
  if love.keyboard.isDown('up', 'w') then
    player.y = player.y - (player.ySpeed * deltaTime)
  end
  if love.keyboard.isDown('down', 's') then
    player.y = player.y + (player.ySpeed * deltaTime)
  end

  -- Left and right movement
  if love.keyboard.isDown('left', 'a') then
    player.x = player.x - (player.xSpeed * deltaTime)
  end
  if love.keyboard.isDown('right', 'd') then
    player.x = player.x + (player.xSpeed * deltaTime)
  end

  -- Don't allow player to move outside of the screen
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


  -- Projectiles
  player.shootTimer = player.shootTimer - deltaTime
  if player.shootTimer <= 0 then
    player.canShoot = true
  end

  if love.keyboard.isDown('space', 'rctrl', 'lctrl', 'ctrl') and player.canShoot then
    player.canShoot = false
    player.shootTimer = player.shootTimerMax

    newProjectile = { x = player.x + player.img:getWidth()/1.2, y = player.y + player.img:getHeight()/2.2, img = player.projectileImg }
  	table.insert(projectiles, newProjectile)
  end

  for i, projectile in ipairs(projectiles) do
	projectile.x = projectile.x + (player.projectileSpeed * deltaTime)

  	if projectile.x > width then
		table.remove(projectiles, i)
  	end
  end


-- Enemies
enemyTimer = enemyTimer - deltaTime
if enemyTimer <= 0 then
  enemyTimer = enemyTimerMax
  -- Create new enemy
  rand = math.random(0, height - enemyImg:getHeight())
  newEnemy = { x = width + enemyImg:getWidth(), y = rand, img = enemyImg}
  table.insert(enemies, newEnemy)
end

for i, enemy in ipairs(enemies) do
  enemy.x = enemy.x - (enemySpeed * deltaTime)
  if enemy.x < 0 - enemy.x then
    table.remove(enemies, i)
    player.isAlive = false
  end
end

-- Collisions
for i, enemy in ipairs(enemies) do
  for j, projectile in ipairs(projectiles) do
    if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), projectile.x, projectile.y, projectile.img:getWidth(), projectile.img:getHeight()) then
      table.remove(enemies, i)
      table.remove(projectiles, j)
      score = score + 100
    end
  end

  if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) and player.isAlive then
    table.remove(enemies, i)
    player.isAlive = false
  end
end

-- Endgame
if not player.isAlive and love.keyboard.isDown('r') then
  projectiles = {}
  enemies = {}

  player.isAlive = true
  player.canShoot = true
  player.shootTimer = player.shootTimerMax

  enemyTimer = enemyTimerMax

  player.x = playerXDefault
  player.y = playerYDefault

  score = 0
end


end

function love.draw(deltaTime)
  love.graphics.draw(backgroundImg, 0, 0)

  -- Score
  love.graphics.setFont(fontSmall)
  love.graphics.printf(score, 0, 10, love.graphics.getWidth() - 20, 'right')

  -- Game
  if player.isAlive then
    love.graphics.draw(player.img, player.x, player.y)

    for i, projectile in ipairs(projectiles) do
      love.graphics.draw(projectile.img, projectile.x, projectile.y)
    end

    for i, enemy in ipairs(enemies) do
      love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end

  else
    love.graphics.setFont(fontBig)
    love.graphics.printf("Press 'R' to restart", 0, love.graphics:getHeight()/3, love.graphics.getWidth(), 'center')
  end

end
