local dude_mt = {}
dude = {}

function dude.new(x, y, world)
	self = setmetatable({},{__index=dude_mt})
	self.anim = anim.new("images/run.png",32,32,20)
	self.saveanim = anim.new("images/save.png",16,24,30)
	self.deathsnd = love.audio.newSource("audio/death.ogg")
	self.stepsnd = {}
	for i=1,11 do
		table.insert(self.stepsnd,love.audio.newSource("audio/step_Seq"..string.format("%02d",i)..".ogg"))
	end
	self.step = 1
	self.steptime = 0
	self.invis = true
	self.x = x
	self.y = y
	self.world = world
	self.dx = 0
	self.dy = 0
	self.speed = 2000
	self.gravity = 1000
	self.friction = 10
	self.rest = 0
	self.save = {x= self.x, y=self.y}
	return self
end

function dude_mt.update(self, dt)
	self.rest = self.rest+dt
	if self.rest >= 0.5 and love.keyboard.isDown("down") then
		self.save = {x= self.x, y=self.y}
	end
	if love.keyboard.isDown("up") and not self.jumped then
		self.rest = 0
		self.dy= -600
		self.dx = self.dx *2
		self.jumped = true
	end
	if love.keyboard.isDown("left") then
		self.rest = 0
		self.dx = self.dx-self.speed*dt
	end
	if love.keyboard.isDown("right") then
		self.rest = 0
		self.dx = self.dx+self.speed*dt
	end
	if self.jumped then
		self.dx = self.dx - (self.dx*self.friction)*dt
	else
		self.dx = self.dx - (self.dx*self.friction)*dt
	end
	self.x = self.x + self.dx*dt
	if self.world:check(self.x, self.y)==1 then
		self.jumped = false
		self.invis = false
		self.x = self.x - self.dx*dt
		self.dx = -self.dx/3
		self.dy = self.dy/4
	end

	self.dy = self.dy - (self.dy*self.friction/4)*dt
	self.dy = self.dy + self.gravity*dt
	self.y = self.y + self.dy*dt
	if self.world:check(self.x, self.y)==1 then
		self.invis = false
		if self.dy >0 then 
			self.jumped = false
			if math.abs(self.dx)>10 then
				self.steptime=self.steptime-dt
			end
		end
		self.y = self.y - self.dy*dt
		self.dy = 0
	end
	if self.steptime<=0 then
		self.step = self.step+1
		self.steptime = 0.25
		if self.step>11 then
			self.step=1
		end
		self.stepsnd[self.step]:rewind()
		self.stepsnd[self.step]:setPitch(2)
		self.stepsnd[self.step]:play()
	end

	if (math.abs(self.dx)<10 or self.jumped) then
		self.anim.currentAnim = 2
	else
		self.anim.currentAnim = 1
	end
	while self.world:check(self.x, self.y)==1 do
		self.y = self.y + 2
	end
	if self.y>-yoff+450 then
		self.deathsnd:rewind()
		self.deathsnd:play()
		self.x = self.save.x
		self.y = self.save.y-3
		self.dx  = 0
		self.dy  = 0
	end
	self.anim:update(dt)
end


function dude_mt.draw(self)
	love.graphics.setColor(hsv(skyhue,skysat, 100))
	self.saveanim:draw(self.save.x+8,self.save.y+4)
	if not self.invis then
		love.graphics.setColor(hsv(fghue, fgsat, fgval))
		self.anim:draw(math.floor(self.x),math.floor(self.y),self.dx>0)
	end
end
