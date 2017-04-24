function nextDay()
	daysPassed = daysPassed + 1
	numForests = 0
	numVillage = 0
	numEnemy   = 0
	health = 100
	bossHealth = 100 + daysPassed * 25
	runTime = 0
	nextdayTime = 0
	isChHit = false
	rocks = {}

	hitSnd:play()

	for i = 0, 4 do
		for j = 0, 6 do
			if mapmx[i + 1][j + 1] == 4 then
				if timetb[i + 1][j + 1] == 0 then
					mapmx[i + 1][j + 1] = 5
					mapmx[i + 1][j] = 4
				else
					timetb[i + 1][j + 1] = timetb[i + 1][j + 1] - 1
				end

				numEnemy = numEnemy + 1
			end
		end
	end

	for i = 0, 4 do
		for j = 0, 6 do
			if mapmx[i + 1][j + 1] == 1 then
				numForests = numForests + 1
			elseif mapmx[i + 1][j + 1] == 3 then
				numVillage = numVillage + 1 
			end
		end
	end

	if numVillage < 5 then
		state = states.endgame
		msgImg = bg7
	end

	if numForests == 0 or numEnemy == 0 then
		state = states.endgame

		if numForests == 0 then
			msgImg = bg5
		end

		if numEnemy == 0 then
			msgImg = bg6
		end
	end
end

function drawSelect()
	drawImg(map, 0, 0)
	printTxt("Day: "..daysPassed, 380, 10, 2)
	printTxt("Forests : "..numForests, 380, 70, 1)
	printTxt("Villages: "..numVillage, 380, 90, 1)

	isSel = false
	
	for i = 0, 4 do
		for j = 0, 6 do
			item = mapmx[i + 1][j + 1]
			img = icons[item]

			drawImg(img, 30 + j * 36, 24 + i * 40)

			if mouse_col(img, 30 + j * 36, 24 + i * 40) then
				drawImg(sel, 30 + j * 36, 24 + i * 40)

				if item == 4 then
					isSel = true
					cur = cur2
					
					--the bulldoser we attacked
					selItem = {i + 1, j + 1}
				end
			end
		end
	end
end