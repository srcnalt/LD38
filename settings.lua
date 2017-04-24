lg = love.graphics
lm = love.mouse
lk = love.keyboard
la = love.audio

SCALE = 3

lg.setBackgroundColor( 0, 0, 0 )
screen = {}
screen.w = 512 * SCALE
screen.h = 256 * SCALE
love.window.setMode(screen.w, screen.h, {fullscreen = false, centered = true})
lm.setCursor(cur1)
cur1 = lm.newCursor('img/cursor_1.png', 1, 1)
cur2 = lm.newCursor('img/cursor_2.png', 1, 1)

love.mouse.setVisible(false)

lg.setDefaultFilter('nearest', 'nearest')

brushaff = lg.newFont("Cutrims.otf", 16)
lg.setFont(brushaff);

function drawImg(img, x, y)
	lg.draw(img, x * SCALE, y * SCALE, 0, SCALE, SCALE)
end

function printTxt(text, x, y, s)
	lg.print(text, x * SCALE, y * SCALE, 0, SCALE * s, SCALE * s)
end

function drawAnim(anim, x, y, s)
	anim:draw(x * SCALE, y * SCALE, 0, SCALE, SCALE)
end

function item_col(itema, itemb)	
	return  itema.x + 15 * SCALE < itemb.x + itemb.img:getWidth() - 5 * SCALE
		and itemb.x + 15 * SCALE < itema.x + itema.img:getWidth() - 5 * SCALE
		and itema.y < itemb.y + itemb.img:getHeight()
		and itemb.y < itema.y + itema.img:getHeight()
end

function mouse_col(item, ix, iy)
	local x, y = lm.getPosition()

	return  x > ix * SCALE
		and x < (ix + item:getWidth()) * SCALE
		and y > iy * SCALE
		and y < (iy + item:getHeight()) * SCALE
end