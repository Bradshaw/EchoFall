local level_mt = {}
level = {}

function level.new(xsize, ysize)
	local self = setmetatable({},{__index=level_mt})
	self:init(xsize, ysize)
	return self
end

function level.from(other)
	local self = level.new(other.xsize, other.ysize)
	other:doFor(function(i,j,t)
		self:set(i,j,t)
		end)

	return self
end

function level_mt.islands(self, skyland,d)
	if skyland then
		for i=1,self.xsize do
			self.data[i] = {}
			for j=1,self.ysize do
				local v = j/self.ysize
				for _=1,4 do
					v = (-math.cos(2*v*math.pi/2)+1)/2
				end
				--v = sel(v<0.5,0,1)
				self.data[i][j]=sel(math.random()<1*v,1,0)
			end
		end
	else
		for i=1,self.xsize do
			self.data[i] = {}
			for j=1,self.ysize do
				self.data[i][j]=sel(math.random()<0.025,1,0)
			end
		end
	end
	--self:set(10,10,1)
	local d = d or 3
	self:expand(d, true)
end

function level_mt.expand(self, d,flattop)
	
	for _=1,d do
		local temp = level.new(self.xsize, self.ysize)
		for i=1,self.xsize do
			for j=1,self.ysize do
				if self:get(i,j)==1 then
					temp:set(i,j,1)
					if math.random()<0.45 then
						temp:set(i+1,j,1)
					end
					if math.random()<0.45 then
						temp:set(i-1,j,1)
					end
					if math.random()<0.45 then
						temp:set(i,j+1,1)
					end
					if not flattop and math.random()<0.45 then
						temp:set(i,j-1,1)
					end
				end
			end
		end
		self.data = temp.data
	end
end

function level_mt.init(self, xsize, ysize )
	self.xsize = xsize or 100
	self.ysize = ysize or 100
	self.data = {}
	for i=1,self.xsize do
		self.data[i] = {}
		for j=1,self.ysize do
			self.data[i][j]=0
		end
	end
end

function level_mt.get(self, x, y )
	return self.data[x%self.xsize+1][y%self.ysize+1]
end

function level_mt.check(self, x, y, scale)
	local scale = scale or 24
	return self:get(math.floor(x/scale),math.floor(y/scale))
end

function level_mt.set( self, x, y, t )
	self.data[x%self.xsize+1][y%self.ysize+1] = t
end

function level_mt.doFor(self, f, x, y, w, h)
	local x = x or 1
	local y = y or 1
	local w = w or self.xsize
	local h = h or self.ysize
	for i=x,x+w-1 do
		for j=y,y+h-1 do
			f(i, j,self:get(i,j))
		end
	end
end