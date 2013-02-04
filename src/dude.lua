local dude_mt = {}
dude = {}

function dude.new(x, y, world)
	self = setmetatable({},{__index=dude_mt})
	self.anim = anim.new("images/run.png",32,32,20)
	self.saveanim = anim.new("images/save.png",16,24,10)
	self.deathsnd = love.audio.newSource("audio/death.ogg")
	self.stepsnd = {}
	for i=1,11 do
		table.insert(self.stepsnd,love.audio.newSource("audio/step_Seq"..string.format("%02d",i)..".ogg"))
	end
	self.step = 1
	self.saved = false
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
	local lastanim = self.anim.currentFrame
	self.anim:update(dt)
	if self.invis then
		xoff = (-d.x+400)
		yoff = (-d.y+400)
	end
	self.saveanim:update(dt)
	self.rest = self.rest+dt
	if self.world:check(self.x, self.y+1)==1 then
		if math.abs(self.dx)>10 then
			self.anim.currentAnim = 1
		else
			self.anim.currentAnim = 2
		end
		if self.rest >= 0.5 and love.keyboard.isDown("down") then
			self.save = {x= self.x, y=self.y}
		end
		if self.intheair then
			self.steptime = self.steptime+0.15
			self.stepsnd[self.step]:rewind()
			self.stepsnd[self.step]:setPitch(2)
			self.stepsnd[self.step]:play()
		elseif lastanim~=self.anim.currentFrame and lastanim==4 and self.anim.currentAnim==1 then
			self.step = math.random(1,11)
			self.steptime = self.steptime+0.15
			self.stepsnd[self.step]:rewind()
			self.stepsnd[self.step]:setPitch(2)
			self.stepsnd[self.step]:play()
		end
		self.intheair = false
	else
		self.anim.currentAnim = 2
		self.intheair = true
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
			if self.jumped then
				--self.steptime = 0
				self.jumped = false
			end
			if math.abs(self.dx)>10 then
				--self.steptime=self.steptime-dt
			end
		end
		self.y = self.y - self.dy*dt
		self.dy = 0
		if not self.saved then
			self.saved = true
			self.save = {x= self.x, y=math.floor(self.y/scale+1)*scale+1}
		end 
	end

	while self.world:check(self.x, self.y)==1 do
		self.saved = false
		self.y = self.y + 2
	end
	if self.y>-yoff+450 then
		self.deathsnd:rewind()
		self.deathsnd:play()
		self.x = self.save.x
		self.y = self.save.y-3
		self.dx  = 0
		self.dy  = 0
		--self.invis = true
	end
end


function dude_mt.draw(self)
	if not self.invis then
		--print(xoff-self.save.x)
		love.graphics.setColor(hsv(skyhue,skysat, 100))
		if self.save.x<-xoff or self.save.x>-xoff+800 or self.save.y<-yoff or self.save.y>-yoff+400 then
			local sx, sy
			local dx = 0
			if dx>0 then
			
			end
			--love.graphics.rectangle("fill",)
		end
		love.graphics.setColor(hsv(skyhue,skysat, 100))
		self.saveanim:draw(self.save.x+8,self.save.y+4)
		love.graphics.setColor(hsv(fghue, fgsat, fgval))
		self.anim:draw(math.floor(self.x),math.floor(self.y),self.dx>0)
	end
end
