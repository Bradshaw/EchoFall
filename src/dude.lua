local dude_mt = {}

local dudestates = {
	standing=0,
	walking=1,
	inAir=2,
	jumped=3,
	onWall=4
}

require("speedtable")

dude = {}

dtab = {}

function dude.new(x, y, world)
	self = setmetatable({},{__index=dude_mt})
	self.anim = anim.new("images/run.png",32,32,20)
	self.anim:setAnimType(2, "randomise", 6, 12)
	self.saveanim = anim.new("images/save.png",16,24,10)
	self.deathsnd = love.audio.newSource("audio/death.ogg")
	self.stepsnd = {}
	for i=1,11 do
		table.insert(self.stepsnd,love.audio.newSource("audio/step_Seq"..string.format("%02d",i)..".ogg"))
	end
	self.state = dudestates.standing
	self.direction = 0
	self.walling = 0
	self.step = 1
	self.saved = false
	self.steptime = 0
	self.simtime = 0
	self.invis = true
	self.x = x
	self.y = y
	self.visx = self.x
	self.visy = self.y
	self.timestep = 1/100
	self.world = world
	self.dx = 0
	self.dy = 0
	self.speed = 2000
	self.gravity = 1000
	self.friction = 10
	self.rest = 0
	self.save = {x= self.x, y=self.y}
	self.actions = {}
	self.actions.runleft = false
	self.actions.runright = false
	self.actions.jump = false
	return self
end

function dude_mt.keypressed(self, key, uni)
	if key=="d" or key =="right" then
		self.actions.runright = true
	end
	if key=="q" or key=="a" or key =="left" then
		self.actions.runleft = true
	end
	if key==" " or key =="up" then
		self.actions.jump = true
	end
	if key=="down" or key=="s" then
		if self.rest >= 0.5 then
			self.save = {x= self.x, y=self.y}
		end
	end
	if key=="return" then
		self.deathsnd:rewind()
		self.deathsnd:play()
		self.x = self.save.x
		self.y = self.save.y-3
		self.dx  = 0
		self.dy  = 0
		--self.invis = true
	end
end

function dude_mt.keyreleased(self, key, uni)
	if key=="d" or key =="right" then
		self.actions.runright = false
	end
	if key=="q" or key=="a" or key =="left" then
		self.actions.runleft = false
	end
	if key==" " or key =="up" then
		self.actions.jump = false
	end
end

function dude_mt.update(self, dt)
	steps = 0
	self.visx = self.visx + self.dx*dt
	self.visy = self.visy + self.dy*dt
	self.simtime = self.simtime+dt
	if love.keyboard.isDown("u") then
		--ms:setPitch(-0.5)
		while self.simtime>self.timestep and #dtab>0 do
			self.simtime = self.simtime - (self.timestep)
			print(#dtab)
			for k,v in pairs(dtab[#dtab]) do
				self[k] = v
			end
			self.anim.currentFrame = self.anfr.currentFrame
			self.anim.currentAnim = self.anfr.currentAnim
			self.anfr = nil
			self.visx = self.x
			self.visy = self.y
			table.remove(dtab, #dtab)
			--table.remove(dtab[#dtab])
		end
	else
		--ms:setPitch(1)
		while self.invis or self.simtime>self.timestep do
			table.insert(dtab,{
				x = self.x,
				y = self.y,
				dx = self.dx,
				dy = self.dy,
				rest = self.rest,
				save = {x = self.save.x, y=self.save.y},
				invis = self.invis,
				intheair = self.intheair,
				jumped = self.jumped,
				anfr = {currentAnim = self.anim.currentAnim, currentFrame= self.anim.currentFrame}
				})
			if #dtab > 3000 then
				table.remove(dtab, 1)
			end
			steps = steps + 1
			local dt = self.timestep
			self.simtime = self.simtime - self.timestep
			self.walling = self.walling - dt
			local lastanim = self.anim.currentFrame
			self.anim:update(dt)
			if self.invis then
				xoff = (-d.x+400)
				yoff = (-d.y+400)
			end
			self.saveanim:update(dt)
			self.rest = self.rest+dt
			if self.world:check(self.x, self.y+1)==1 then
				if math.abs(self.dx)>20 then
					if math.abs(self.dx)<120 then
						if self.actions.runleft or self.actions.runright then
							self.anim.currentAnim = 3
						else
							self.anim.currentAnim = 5
						end
					else
						self.anim.currentAnim = 1
					end
				else
					self.anim.currentAnim = 2
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
				if self.dy<0 then
					self.anim.currentAnim=3
				elseif self.dy<150 then
					self.anim.currentAnim=1
				else
					self.anim.currentAnim=4
				end
				self.intheair = true
			end
			if self.actions.jump and not self.jumped then
				self.rest = 0
				self.dy= -600
				--self.dx = self.dx
				self.jumped = true
			end
			if self.actions.runleft then
				self.rest = 0
				self.dx = self.dx-self.speed*dt
			end
			if self.actions.runright then
				self.rest = 0
				self.dx = self.dx+self.speed*dt
			end
			if self.jumped then
				self.dx = self.dx - (self.dx*self.friction)*dt
			else
				self.dx = self.dx - (self.dx*self.friction)*dt
			end
			self.x = self.x + self.dx*dt
			if self.world:check(self.x, self.y)==1 or self.world:check(self.x, self.y-15)==1 then
				self.walling = 0.1
				self.jumped = false
				self.invis = false
				self.x = self.x - self.dx*dt
				self.dx = -self.dx/3
				self.dy = self.dy/4
			end

			self.dy = self.dy - (self.dy*self.friction/4)*dt
			self.dy = self.dy + self.gravity*dt
			self.y = self.y + self.dy*dt
			if self.world:check(self.x, self.y)==1 or self.world:check(self.x, self.y-15)==1 then
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
			if self.y>-yoff+425 then
				self.deathsnd:rewind()
				self.deathsnd:play()
				self.x = self.save.x
				self.y = self.save.y-3
				self.dx  = 0
				self.dy  = 0
				--self.invis = true
			end

			while self.world:check(self.x, self.y)==1 or self.world:check(self.x, self.y-15)==1 do
				self.saved = false
				self.y = self.y - 24
			end
			self.visx = self.x
			self.visy = self.y
		end
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
		self.anim:draw(math.floor(self.visx),math.floor(self.visy),self.dx>0)
	end
end
