local state = gstate.new()

scale = 24

function makeWorld()
	l:init(1000,1000)
	l:islands(false,7)
	bg = level.from(l)
	--bg:init(100,1000)
	--bg:islands(false,7)
	bg:expand(4)
	d.invis = true
	yoff = d.y
end
function makeColour()
	hue  = math.random(40, 160)
	sat = math.random()
	val = math.random()
	skyhue, skysat, skyval = hue+40, 60*sat, 20+70*val
	bghue, bgsat, bgval = hue+20, 40*sat, 20+30*val
	fghue, fgsat, fgval = hue, 80*sat, 50*val
end

function state:init()
	cloudim = love.graphics.newImage("images/clouds.png")
	tileim = love.graphics.newImage("tile.png")
	vig = love.graphics.newImage("images/vignette.png")
	sw = swirlies.new()
	l = level.new(10,10)
	bg = level.from(l)
	d = dude.new(1000,1000,l)
	xoff = 0
	yoff = 0
	makeWorld()
	makeColour()
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
		makeWorld()
	end
	if key=='h' then
		makeColour()
	end
	if key=='f' then
		fl = not fl
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	sw:update(dt)
	d:update(dt)
	xoff = xoff - (xoff+d.x-400)*dt
	yoff = yoff - (yoff+d.y-200)*dt
end


function state:draw()
	love.graphics.setBackgroundColor(hsv(skyhue,skysat,skyval))

	love.graphics.push()

	love.graphics.translate(math.floor(xoff), math.floor(yoff))
	love.graphics.setColor(hsv(hue+20, 40*sat, 20+30*val))
	bg:doFor(function(x, y, t)
			if t==1 then
				love.graphics.draw(tileim, x*scale+12,y*scale+24)
			end
		end, math.floor(-xoff/scale-1), math.floor(-yoff/scale-2), love.graphics.getWidth()/scale+3, love.graphics.getHeight()/scale+3)
	d:draw()
	love.graphics.setColor(hsv(hue, 80*sat, 50*val))
	l:doFor(function(x, y, t)
			if t==1 then
				love.graphics.draw(tileim, x*scale+12,y*scale+24)
			end
		end, math.floor(-xoff/scale-1), math.floor(-yoff/scale-2), love.graphics.getWidth()/scale+3, love.graphics.getHeight()/scale+3)
	--love.graphics.setColor(hsv(hue+40, 30, 70))
	sw:draw()
	love.graphics.pop()
	love.graphics.setColor(20,20,20,127)
	love.graphics.draw(vig,0,0)
	--love.graphics.setColor(20,20,20)
	--love.graphics.print("F/s: "..love.timer.getFPS(),10,10)
	--love.graphics.print("Alti: "..math.floor(-d.y),10,20)
	if love.keyboard.isDown("s") then
		if not ss then
			ss = {}
		end
		table.insert(ss,love.graphics.newScreenshot())
	else
		if ss then
			for i,v in ipairs(ss) do
				print(string.format("%04d",i)..'.png')
				v:encode(string.format("%04d",i)..'.png')
			end
			ss = {}
		end
	end
end

return state