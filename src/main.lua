function sel(bool, val1, val2)
	if bool then
		return val1
	else
		return val2
	end
end

function hsv(H, S, V, A, div, max, ang)
	local max = max or 255
	local ang = ang or 360
	local ang6 = ang/6
	local r, g, b
	local div = div or 100
	local S = (S or div)/div
	local V = (V or div)/div
	local A = (A or div)/div * max
	local H = H%ang
	if H>=0 and H<=ang6 then
		r = 1
		g = H/ang6
		b = 0
	elseif H>ang6 and H<=2*ang6 then
		r = 1 - (H-ang6)/ang6
		g = 1
		b = 0
	elseif H>2*ang6 and H<=3*ang6 then
		r = 0
		g = 1
		b = (H-2*ang6)/ang6
	elseif H>180 and H <= 240 then
		r = 0
		g = 1- (H-3*ang6)/ang6
		b = 1
	elseif H>4*ang6 and H<= 5*ang6 then
		r = (H-4*ang6)/ang6
		g = 0
		b = 1
	else
		r = 1
		g = 0
		b = 1 - (H-5*ang6)/ang6
	end
	local top = (V*max)
	local bot = top - top*S
	local dif = top - bot
	r = bot + r*dif
	g = bot + g*dif
	b = bot + b*dif

	return r, g, b, A
end

function love.load(arg)
	elapsed = 0
	gstate = require("gamestate")
	game = require("game")
	require("anim")
	require("level")
	require("dude")
	require("swirlies")
	gstate.switch(game)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function love.keyreleased(key, uni)
	gstate.keyreleased(key, uni)
end

function love.update(dt)
	if love.keyboard.isDown("s") then
		elapsed = elapsed+0.04
		gstate.update(0.04)
	else
		elapsed = elapsed+math.min(dt,0.1)
		gstate.update(math.min(dt,0.1))
	end
end

function love.draw()
	gstate.draw()
end