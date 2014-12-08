require "helpers"
require "animation"
require "object"
require "rebelMob"
require "drawable"
require "health"
require "button"

function getBackground()
	return love.graphics.newImage(love.image.newImageData(love.window.getWidth(), love.window.getHeight() ))
end

function generateBackground()
	local data = background:getData()
	data:mapPixel(function(x,y,r,g,b,a) return math.random(30, 130), math.random(100, 200), math.random(10, 70), 255 end)
	background:refresh()
end

function updateBackground(R,G,B)
	local data = background:getData()
	data:mapPixel(function(x,y,r,g,b,a) return R,G,B, 255 end)
	background:refresh()
end

function love.load()
	love.window.setTitle("Smash the rebels!")

	love.window.setMode(900, 600, {})
	x = 0
	y = 0
	
	window = {}
	window.h = 180
	window.w = 250

	fontS = love.graphics.newFont("OpenSans-Bold.ttf", 12)
	font = love.graphics.newFont("OpenSans-Bold.ttf", 16)
	font2 = love.graphics.newFont("OpenSans-Bold.ttf", 32)
	fontXL = love.graphics.newFont("OpenSans-Bold.ttf", 50)
	love.graphics.setFont(font)

	images = {}

	images.fireAnim = {loadImage("fire1.png"),
					   loadImage("fire2.png"),
					   loadImage("fire3.png"),
					   loadImage("fire4.png")}

	images.fire = getAnimation(images.fireAnim, 0.06)
	images.farm = loadImage("farm.png")
	images.rebel = loadImage("rebel.png")

	images.campaign = loadImage("campaign.png")
	images.randomMode = loadImage("randomMode.png")
	images.exit = loadImage("exit.png")
	images.next = loadImage("next.png")
	images.menu = loadImage("menu.png")

	buttons = {}

	buttons.campaign = getButton(images.campaign, "center", 200)
	buttons.randomMode = getButton(images.randomMode, "center", 300)
	buttons.exit = getButton(images.exit, "center", 400)

	buttons.next = getButton(images.next, "center", 200)
	buttons.menu = getButton(images.menu, "center", 300)
	
	startingTime = love.timer.getTime()

	running = false
	menu = true
	nextLevel = false
	speed = 2

	feedback = ""
end

function startLevel()
	background = getBackground()
	generateBackground()

	farms = {}
	rebelMobs = {}

	mobElapsedTime = 0
	mobTime = 3
	startingTime = love.timer.getTime()

	maxRebelMobs = 15

end

function loadlevel0()
	startLevel()

	for i=1,6 do
		farms[i] = getFarm(math.random(1,love.window.getWidth() - images.farm:getWidth()/2 ) ,math.random(1,love.window.getHeight() - images.farm:getHeight()/2)-50 )
	end

	dificulty = 0.03
	instructions = "Destroy the rebels that are attacking your farms, by clicking when they\nare inside your frame. The longer you survive, the better."

	spawnArea = {x1 = 200, x2 = 500, y1 = 100, y2 = 600}

	gameTime = 1
	maxRebelMobs = 1000

end

function loadlevel1()
	-- 70 seconds without losing, with 4 farms
	startLevel()

	farms[1] = getFarm(100, 100)
	farms[2] = getFarm(150, 200)
	farms[3] = getFarm(800, 500)
	farms[4] = getFarm(300, 500)

	dificulty = 0.04
	instructions = "Destroy the rebels that are attacking your farms, by clicking when they\nare inside your frame. At least one of them must survive until the end of the time."

	spawnArea = {x1 = 200, x2 = 500, y1 = 100, y2 = 600}

	gameTime = 60
	maxRebelMobs = 20

end

function loadlevel2()
	-- 80 seconds without losing, with 2 farms
	startLevel()

	farms[1] = getFarm(100, 100)
	farms[3] = getFarm(800, 500)

	dificulty = 0.06
	instructions = "Destroy the rebels that are attacking your farms, by clicking when they\nare inside your frame. At least one of them must survive until the end of the time."

	spawnArea = {x1 = 0, x2 = love.window.getWidth(), y1 = 50, y2 = love.window.getHeight()}

	maxRebelMobs = 15
	gameTime = 65
end

function loadlevel3()
	-- 120 seconds without losing, with 6 farms
	startLevel()

	farms[1] = getFarm(100, 250)
	farms[2] = getFarm(200, 150)
	farms[3] = getFarm(300, 250)
	farms[4] = getFarm(400, 150)
	farms[5] = getFarm(500, 250)
	farms[6] = getFarm(600, 150)

	maxRebelMobs = 20
	dificulty = 0.05
	instructions = "Destroy the rebels that are attacking your farms, by clicking when they\nare inside your frame. At least one of them must survive until the end of the time."

	spawnArea = {x1 = 0, x2 = love.window.getWidth(), y1 = 50, y2 = love.window.getHeight()}

	gameTime = 120
end


function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	end
	if k == 'e' then
		updateBackground()
	end
	if k == 'p' and not menu then
		running = not running
		if not running then
			waitTime = love.timer.getTime()
		else
			startingTime = startingTime + love.timer.getTime() - waitTime
		end
	end
end

function drawBlood(data, x, y, p)
	local c = 19/20
	if x >= data:getWidth() or x < 0 or y >= data:getHeight() or y < 0 then
		return
	end

	r = data:getPixel(x, y)
	if r > 150 then
		return
	end

	local red = 190 + math.random(-60, 60)
	if red > 255 then
		red = 255
	end
	if red < 130 then
		red = 130
	end

	data:setPixel(x, y, red, math.random(3, 30), math.random(3, 30), 255)
	if math.random() < p then
		drawBlood(data, x+1, y, p*c)
		drawBlood(data, x-1, y, p*c)
		drawBlood(data, x, y+1, p*c)
		drawBlood(data, x, y-1, p*c)
	end
end

function love.mousepressed(mx, my, button)
	if menu then
		if buttons.campaign:checkClick(x, y) then
			menu = false
			running = true
			level = 1
			loadlevel1()
		elseif buttons.randomMode:checkClick(x, y) then
			menu = false
			running = true
			level = 0
			loadlevel0()
		elseif buttons.exit:checkClick(x, y) then
			print("Bye")
			love.event.quit()
		end
	elseif nextLevel then
		if buttons.next:checkClick(x, y) then
			nextLevel = false
			running = true
			level = level + 1
			if level == 2 then
				loadlevel2()
			elseif level == 3 then
				loadlevel3()
			elseif level == 4 then
				menu = true
				feedback = "Congratulations, you crushed the rebelion!"
				running = false
			end
		elseif buttons.menu:checkClick(x, y) then
			nextLevel = false
			menu = true
		end
	elseif lostmenu then
		if buttons.menu:checkClick(x, y) then
			lostmenu = false
			running = false
			menu = true
		end
	elseif running then
		if button == 'l' then
			window.x = x-window.w/2
			window.y = y-window.h/2

			for i, f in pairs(farms) do
				if intersects(window, f) then
					f:setHealth(f.health - 5)
					if f.health <= 0 then
						farms[i] = nil
					end
				end
			end

			for i, rm in pairs(rebelMobs) do
				if intersects(window, rm) then
					rebels = rebelMobs[i]:getRebels()
					for ind, rebel in pairs(rebels) do
						r = {}
						r.x = rm.x + rebel.x
						r.y = rm.y + rebel.y
						r.w = rebel.w
						r.h = rebel.h
						if intersects(window, r) then
							local data = background:getData()
							drawBlood(data, r.x+9, r.y+9, 1)
						    rebels[ind] = nil
						end
					end
					if length(rebels) == 0 then
						rebelMobs[i] = nil
					end

				end
			end
			background:refresh()
		end
	end
	
end

function createMob(dt)
	mobElapsedTime = mobElapsedTime + dt
	if mobElapsedTime > mobTime and length(rebelMobs) < maxRebelMobs then
		mobElapsedTime = 0
		rebelMobs[#rebelMobs + 1] = getRebelMob(math.random(spawnArea.x1, spawnArea.x2),
												math.random(spawnArea.y1, spawnArea.y2), 10, farms)
	end
end

function love.update(dt)
	x,y = love.mouse.getPosition()

	if menu then
		
	elseif nextLevel then

	elseif lostmenu then

	elseif running then

		createMob(dt)

		for i, r in pairs(rebelMobs) do
			r:update(dt*speed)
		end

		if mobTime > 0.1 then
			mobTime = mobTime - dt*dificulty
		end

		if length(farms) == 0 then
			running = false
			lostmenu = true
		end
	end
end

function drawCover()
	love.graphics.setColor(0,0,0)
	w = love.graphics.getWidth()
	h = love.graphics.getHeight()
	
	love.graphics.rectangle("fill", 0, 0, w, y-window.h/2)
	love.graphics.rectangle("fill", 0, y+window.h/2, w, h)
	love.graphics.rectangle("fill", 0, y-window.h/2, x-window.w/2, h)
	love.graphics.rectangle("fill", x+window.w/2, y-window.h/2, w, h)

	love.graphics.setColor(255,255,255)

	local time = math.floor(love.timer.getTime() - startingTime)

	if level > 0 then
		time = gameTime - time
	end
	
	if time < 0 then
		running = false
		nextLevel = true
	end

	local min = math.floor(time / 60)
	local sec = mod(time, 60)
	if sec < 10 then
		sec = 0 .. sec
	else
		sec = "" .. sec
	end

	if min < 10 then
		min = 0 .. min
	else
		min = "" .. min
	end

	love.graphics.setFont(font)
	love.graphics.print(min .. ":" .. sec, love.window.getWidth() - 150, 20)
	love.graphics.print("Remaining Farms: " .. length(farms), 30, 20)

	love.graphics.setFont(fontS)
	if instructions ~= nil then
		love.graphics.print(instructions, 230, 20)
	end

	love.graphics.setFont(font)
	love.graphics.setColor(255,255,255)
end

function getFarm(x, y)
	local farm = getObject(x, y)
	farm.scale = 1
	farm.health = 100

	local rawFarm = getRaw(images.farm, 0, 0, 1)
	farm:add(rawFarm)
	local h = getHealthBar(70)
	h:setHealth(100)
	h.y = -10
	farm:add(h)
	farm.objects[2]:setHealth(100)
	farm.w = images.farm:getWidth()
	farm.h = images.farm:getHeight()

	function farm:setHealth(h)
		self.health = h
		self.objects[2]:setHealth(h)
	end

	return farm
end

function pauseMenu()
	love.graphics.setFont(font2)
	love.graphics.print("Paused", 400, 250)
	love.graphics.setFont(font)	
end

function love.draw()
	--love.graphics.setBackgroundColor(255,255,255,255)
	if menu then
		love.graphics.setFont(fontXL)
		love.graphics.print("Smash the Rebels!", 225, 60)
		love.graphics.setFont(font)
		buttons.campaign:draw()
		buttons.randomMode:draw()
		buttons.exit:draw()
		love.graphics.setColor(5, 103, 28, 255)
		love.graphics.setFont(font2)
		love.graphics.print(feedback, 150, 500)
		love.graphics.setColor(255,255,255, 255)
		love.graphics.setFont(font)
		info = "Made by michel94 for Ludum Dare 31"
		love.graphics.print(info, love.window.getWidth() - font:getWidth(info), love.window.getHeight() - font:getHeight())
	elseif nextLevel then
		love.graphics.setColor(5, 103, 28, 255)
		love.graphics.setFont(font2)
		love.graphics.print("The rebels have been crushed, for now.", 130, 100)
		love.graphics.setColor(255,255,255, 255)
		buttons.next:draw()
		buttons.menu:draw()
	elseif lostmenu then
		love.graphics.setFont(font2)
		love.graphics.setColor(201, 38, 6, 255)
		love.graphics.print("The rebels burned all your farms!", 150, 100)
		love.graphics.setColor(255, 255, 255, 255)
		buttons.menu:draw()
	elseif running then
		love.graphics.draw(background, 0, 0)

		for i, f in pairs(farms) do
			farms[i]:draw()
		end

		for i, r in pairs(rebelMobs) do
			r:draw()
		end
		
		drawCover()
	else
		pauseMenu()
	end

end
