local swirly_mt = {}
local swirlies_mt = {}

swirlies = {}

function swirlies.newSwirl(x, y)
	local self = setmetatable({},{__index=swirly_mt})
	self.x = x
	self.y = y
	self.life = 2+math.random()*5
	local a = math.random()*math.pi*2
	self.dx = 0
	self.dy = 0
	self.anim = anim.new("images/swirly.png", 3, 3, math.random(1,40))

	return self
end

function swirly_mt.update(self, dt)
	--self.life = self.life - dt
	self.x = self.x + (self.dx*self.life)+math.random(-100,100)*dt
	self.y = self.y + (self.dy*self.life)+math.random(-100,100)*dt

	if self.life <= 0 then
		--self.purge = true
	end
	if self.x<-xoff or self.x>-xoff+800 or self.y<-yoff or self.y>-yoff+400 then
		self.purge = true
	end
	self.anim:update(dt)
end

function swirly_mt.draw(self)
	self.anim:draw(math.floor(self.x),math.floor(self.y))
end

function swirlies.new()
	local self = setmetatable({},{__index=swirlies_mt})
	self.data = {}


	return self
end

function swirlies_mt.add(self,x,y)
	table.insert(self.data,swirlies.newSwirl(x,y))
end

function swirlies_mt.update( self, dt )
	local i = 1
	while #self.data<30 do
		self:add(-xoff+math.random(2,799),-yoff+2)
		self:add(-xoff+math.random(2,799),-yoff+399)
		self:add(-xoff+2,-yoff+math.random(1,399))
		self:add(-xoff+799,-yoff+math.random(1,399))
		self:add(d.save.x+12,d.save.y+24)
	end
	while i<=#self.data do
		v = self.data[i]
		if v.purge then
			table.remove(self.data,i)
		else
			v:update(dt)
			i=i+1
		end
	end
end

function swirlies_mt.draw( self )
	for i,v in ipairs(self.data) do
		v:draw()
	end
end