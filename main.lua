require("settings")
require("anim")
require("selectFight")
require("runnerGame")
require("bossFight")

states = {
	menu 		= 0,
	select		= 1,
	runner 		= 2,
	fight       = 3,
	message		= 4,
	endgame		= 5,
	nextday		= 6
}

chStates = {
	run		= 0,
	jump	= 1,
	wait 	= 2
}

function  love.load()
	la.stop()
	
	mapmx = {
		{3, 2, 5, 1, 1, 1, 4},
		{3, 1, 5, 1, 2, 5, 4},
		{3, 2, 1, 5, 5, 1, 4},
		{3, 5, 1, 1, 2, 1, 4},
		{3, 2, 1, 5, 5, 1, 4},
	}

	timetb = {
		{0, 2, 0, 1, 1, 1, 0},
		{0, 1, 0, 1, 2, 0, 0},
		{0, 2, 1, 0, 0, 1, 0},
		{0, 0, 1, 1, 2, 1, 0},
		{0, 2, 1, 0, 0, 1, 0},
	}

	bg1 =	lg.newImage("img/bg1.png")
	bg2 = 	lg.newImage("img/bg2.png")
	bg3 =  	lg.newImage("img/bg3.png")
	bg4 = 	lg.newImage("img/bg4.png")
	bg5 =	lg.newImage("img/bg5.png")
	bg6 =	lg.newImage("img/bg6.png")
	bg7 =	lg.newImage("img/bg7.png")

	msgImg = bg1

	state = states.menu
	chState = chStates.run
	selItem = 0
	daysPassed = 1
	numForests = 12
	numVillage = 5
	numEnemy   = 5
	isChHit = false
	hitTime = 0
	prevAnim = nil
	health = 100

	globalMessage = ""

	cur1 = lg.newImage("img/cursor_1.png")
	cur2 = lg.newImage("img/cursor_2.png")
	cur = cur1

	--menu
	menu  = lg.newImage("img/menu.png")
	start = newAnimation(lg.newImage("img/start.png"), 264, 22, 0.5 ,2)
	menuSnd = la.newSource("snd/menu.mp3", "stream")
	gameSnd = la.newSource("snd/game.mp3", "stream")
	hitSnd  = la.newSource("snd/hit.wav", "static")
	jumpSnd = la.newSource("snd/jump.wav", "static")

	--select
	map   = lg.newImage("img/mapimg.png")
	sel   = lg.newImage("img/selected.png")
	isSel = false
	nextdayTime = 0
	icons = {
			 	lg.newImage("img/tile_forest.png"),
			 	lg.newImage("img/tile_mountain.png"),
			 	lg.newImage("img/tile_village.png"),
			 	lg.newImage("img/tile_bulldoser.png"),
				lg.newImage("img/tile_empty.png")
			}

	--runner
	back1 = lg.newImage("img/slide_back.png")
	back2 = lg.newImage("img/slide_1.png")
	bar   = lg.newImage("img/bar.png")
	point = lg.newImage("img/point.png")
	rock1 = lg.newImage("img/rock_1.png")
	chRun = newAnimation(lg.newImage("img/run.png"), 110, 110, 0.1 ,8)
	chJump = newAnimation(lg.newImage("img/jump.png"), 110, 110, 0.3 ,3)
	chHit  = newAnimation(lg.newImage("img/hit.png"), 110, 110, 0.3 ,3)
	rBack1 = 0
	rBack2 = 0
	pPosY  = 113
	velo   = 100
	runTime = 0
	rocks = {}

	--boss fight
	fightBg  = lg.newImage("img/battle_scene.png")
	button   = lg.newImage("img/button.png")
	bossArea = lg.newImage("img/bossArea.png")
	bossIdle = newAnimation(lg.newImage("img/boss_1_idle.png"), 239, 156, 0.1, 4)
	bossAtck = newAnimation(lg.newImage("img/boss_1_attack.png"), 295, 155, 0.1, 8)
	chWait   = newAnimation(lg.newImage("img/fight_fist.png"), 51, 103, 0.2, 4)
	fightTime = 0
	buttonTime = 0
	attackTime = 0
	delay = 0
	dodged = false
	pPosYBoss  = 120
	veloBoss   = 100
	bossHealth = 100

	fightStates = { message = 4, wait = 0, start = 1, attack = 2}
	currentFightState = fightStates.message

	msgImg = bg4

	menuSnd:play()
end

function love.update(dt)
	cur = cur1

	if state == states.menu then
		if love.keyboard.isDown("space") then
			state = states.select
		end

		if love.keyboard.isDown("s") then
			if SCALE == 3 then
				SCALE = 1
			else
				SCALE = SCALE + 1
			end

			screen.w = 512 * SCALE
			screen.h = 256 * SCALE
			love.window.setMode(screen.w, screen.h, {fullscreen = false, centered = true})
			love.load()
		end

		start:update(dt)
	elseif state == states.select then
		if isSel and lm.isDown(1) then
			state = states.runner
			la.stop()
			gameSnd:play()
		end

		if numForests == 0 or numEnemy == 0 then
			state = states.endgame
		end
	elseif state == states.runner then
		updateRunnerGame(dt)
	elseif state == states.fight then 
		updateFight(dt)
	elseif state == states.message then
		if lk.isDown("space") then
			state = states.nextday
			la.stop()
			menuSnd:play()
		end
	elseif state == states.nextday then
		nextdayTime = nextdayTime + dt

		if nextdayTime > 1 then
			state = states.select
			nextDay()
		end
	elseif state == states.endgame then
		if lk.isDown("space") then
			state = states.menu
			love.load()
		end
	end
end

function love.draw()
	if state == states.menu then
		drawImg(menu, 0, 0)
		drawAnim(start, 125, 210)
	elseif state == states.select then
		drawSelect()
	elseif state == states.runner then
		drawRunnerGame()
	elseif state == states.fight then 
		drawFight()
	elseif state == states.message then
		drawImg(msgImg, 0, 0)
	elseif state == states.nextday then
		drawSelect()
	elseif state == states.endgame then
		drawImg(msgImg, 0, 0)
	end

	x, y = lm.getPosition()
	drawImg(cur, x / SCALE, y / SCALE)
end

function love.keypressed(key)
    if state == states.menu then

	elseif state == states.select then
		if key == "n" then
			nextDay()
		end
	elseif state == states.runner then
		if key == "space" then
			chState = chStates.jump
			jumpSnd:play()
		end
	elseif states == states.fight then 
		
	elseif states == states.endgame then

	end
end