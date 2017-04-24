function drawFight()
	if currentFightState ~= fightStates.message then
		drawImg(fightBg, 0, 0)
		printTxt("Health: " .. health, 5, 4, 1)
		printTxt("Bulldozer: " .. bossHealth, 370, 4, 1)
	end

	if currentFightState == fightStates.wait then
		drawAnim(bossIdle, 240, 70)
		drawAnim(chWait, 110, pPosYBoss)

		if fightTime > 10 then
			drawImg(button, 215, 10)
		end
	elseif currentFightState == fightStates.start then
		drawAnim(bossIdle, 240, 70)
		drawAnim(chWait, 110, pPosYBoss)

		if delay > 1 then
			currentFightState = fightStates.attack
		end
	elseif currentFightState == fightStates.attack then
		if attackTime < 0.7 then
			drawAnim(bossAtck, 184, 70)
		else
			bossAtck:reset()
		end

		if dodged then
			drawAnim(chJump, 80, pPosYBoss)
		else
			love.graphics.setColor(200, 0, 0)
			drawAnim(chWait, 110, pPosYBoss)
			love.graphics.setColor(255, 255, 255)
		end
	elseif currentFightState == fightStates.message then
		drawImg(msgImg, 0, 0)
	end
end

function updateFight(dt)
	if mouse_col(bossArea, 305, 100) then
		cur = cur2
	end

	if bossHealth <= 0 then
		--enemy destroyed
		mapmx[selItem[1]][selItem[2]] = 5

		state = states.message
		msgImg = bg2
	end

	if health <= 0 then
		state = states.message
		msgImg = bg3
	end

	if currentFightState == fightStates.wait then
		fightTime = fightTime + dt * 2

		if fightTime > 10 then
			buttonTime = buttonTime + dt * 2

			if lk.isDown("space") then
				dodged = true
			end
		end

		if buttonTime > 1 then
			fightTime = 0
			buttonTime = 0
			currentFightState = fightStates.start
		end
	elseif currentFightState == fightStates.start then
		delay = delay + dt

		if delay > 1 then
			currentFightState = fightStates.attack
			delay = 0
		end
	elseif currentFightState == fightStates.attack then
		attackTime = attackTime + dt
		hitSnd:play()		

		if attackTime >= 0.7 then
			attackTime = 0
			currentFightState = fightStates.wait

			if not dodged then
				health = health - 20
			end

			dodged = false
		end

		if dodged then	
			jumpSnd:play()
			pPosYBoss = pPosYBoss - veloBoss * dt * SCALE
			veloBoss = veloBoss - dt * SCALE * 100
		end

		if pPosYBoss > 120 then
			pPosYBoss = 120
			veloBoss = 100
			chJump:reset()
		end
	elseif currentFightState == fightStates.message then
		if lk.isDown("space") then
			currentFightState = fightStates.wait
		end
	end

	bossIdle:update(dt)
	bossAtck:update(dt)
	chWait:update(dt)
end

function love.mousepressed(x, y, button, istouch)
	if currentFightState == fightStates.wait and mouse_col(bossArea, 305, 100) then
	   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
	      bossHealth = bossHealth - 1
	   end
   end
end