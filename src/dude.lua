local dude_mt = {}
dude = {}

function dude.new(x, y, world)
	self = setmetatable({},{__index=dude_mt})
	self.anim = anim.new("images/run.png",32,32,20)
	self.x = x
	self.y = y
	self.world = world
	self.dx = 0
	self.dy = 0
	self.speed = 2000
	self.gravity = 1000
	self.friction = 10
	return self
end

function dude_mt.update(self, dt)
	if love.keyboard.isDown("up") and not self.jumped then
		self.dy= -600
		self.dx = self.dx *2
		self.jumped = true
	end
	if love.keyboard.isDown("left") then
		self.dx = self.dx-self.speed*dt
	end
	if love.keyboard.isDown("right") then
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
		self.x = self.x - self.dx*dt
		self.dx = -self.dx/3
		self.dy = self.dy/4
	end

	self.dy = self.dy - (self.dy*self.friction/4)*dt
	self.dy = self.dy + self.gravity*dt
	self.y = self.y + self.dy*dt
	if self.world:check(self.x, self.y)==1 then
		if self.dy >0 then 
			self.jumped = false
		end
		self.y = self.y - self.dy*dt
		self.dy = 0
	end

	if math.abs(self.dx)<10 or self.jumped then
		self.anim.currentAnim = 2
	else
		self.anim.currentAnim = 1
	end

	self.anim:update(dt)
end


function dude_mt.draw(self)
	self.anim:draw(math.floor(self.x),math.floor(self.y),self.dx>0)
end
