local state = gstate.new()

scale = 24

function state:init()
	cloudim = love.graphics.newImage("images/clouds.png")
	tileim = love.graphics.newImage("tile.png")
	l = level.new(100,100)
	l:islands(true)
	bg = level.from(l)
	bg:expand(3)
	d = dude.new(400,-400,l)
	xoff, yoff = 0,-600
	hue  = math.random(40, 160)
	fl = false
end


function state:enter()

end


function state:focus()

end


function state:mousepressed(x, y, btn)

end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if key=='escape' then
		love.event.push("quit")
	end
	if key==' ' then
		hue  = math.random(40, 160)
		l:init(100,100)
		l:islands(false,7)
		bg = level.from(l)
		bg:expand(4)
	end
	if key=='h' then
		hue  = math.random(40, 160)
	end
	if key=='f' then
		fl = not fl
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	d:update(dt)
	xoff,yoff = -d.x+400,-d.y+200
end


function state:draw()
	love.graphics.setBackgroundColor(hsv(hue+40, 20, 100))

	love.graphics.push()

	love.graphics.translate(math.floor(xoff), math.floor(yoff))
	love.graphics.setColor(hsv(hue+20, 20, 80))
	bg:doFor(function(x, y, t)
			if t==1 then
				love.graphics.draw(tileim, x*scale+12,y*scale+24)
			end
		end, math.floor(-xoff/scale-1), math.floor(-yoff/scale-1), love.graphics.getWidth()/scale+3, love.graphics.getHeight()/scale+3)
	love.graphics.setColor(hsv(hue, 40, 50))
	l:doFor(function(x, y, t)
			if t==1 then
				love.graphics.draw(tileim, x*scale+12,y*scale+24)
			end
		end, math.floor(-xoff/scale-1), math.floor(-yoff/scale-1), love.graphics.getWidth()/scale+3, love.graphics.getHeight()/scale+3)
	d:draw()
	love.graphics.pop()

	love.graphics.setColor(20,20,20)
	love.graphics.print("F/s: "..love.timer.getFPS(),10,10)
	love.graphics.print("Alti: "..math.floor(-d.y),10,20)
end

return state