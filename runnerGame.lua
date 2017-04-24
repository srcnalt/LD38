function drawRunnerGame()
	drawImg(back1, rBack1, 0)
	drawImg(back2, rBack2, 0)
	drawImg(bar, 110, 10)
	drawImg(point, 115 + runTime, 7)

	printTxt("Health: " .. health, 5, 4, 1)

	for index, value in ipairs(rocks) do
		drawImg(value[1], value[2], 185)
	end

	if isChHit then
		love.graphics.setColor(200, 0, 0)
	end

	if chState == chStates.run then
		drawAnim(chRun, 20, pPosY)
	elseif chState == chStates.jump then
	    drawAnim(chJump, 20, pPosY)
	end

	love.graphics.setColor(255, 255, 255)
end

function updateRunnerGame(dt)
	if health <= 0 then
		state = states.message
		
		msgImg = bg1
	end

	rBack1 = rBack1 - dt * SCALE * 50
	rBack2 = rBack2 - dt * SCALE * 75

	if runTime < 270 then
		runTime = runTime + dt * SCALE * 3
	else
		runTime = 270
		state = states.fight
		currentFightState = fightStates.message

		msgImg = bg4
	end

	if math.random(30) == 1 and runTime < 250 then
		if #rocks == 0 then
			table.insert(rocks, {rock1, 600})
		elseif rocks[#rocks][2] < 200 then
			table.insert(rocks, {rock1, 600})
		end
	end

	for index, value in ipairs(rocks) do
		value[2] = value[2] - dt * SCALE * 75

		if value[2] < -100 then
			table.remove(rocks, index)
		end

		if isChHit == false and item_col({img = chRun, x = 20, y = pPosY}, {img = rock1, x = value[2], y = 185}) then
			isChHit = true
			hitTime = runTime
			health = health - 10
			hitSnd:play()
		end
	end

	if runTime > hitTime + 2 then
		isChHit = false
	end

	if rBack1 < -512 then
		rBack1 = 0
	end

	if rBack2 < -512 then
		rBack2 = 0
	end

	if chState == chStates.run then
		chRun:update(dt)
	elseif chState == chStates.jump then
	    chJump:update(dt)

		pPosY = pPosY - velo * dt * SCALE
		velo = velo - dt * SCALE * 100

		if pPosY > 113 then
			pPosY = 113
			velo = 100
			chState = chStates.run
			chJump:reset()
		end
	end
end