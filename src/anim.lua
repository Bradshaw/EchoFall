local anim_mt = {}
local files = {}
local quads = {}
anim = {}

function anim.new(filename, xsize, ysize, framerate)
	local self = setmetatable({},{__index=anim_mt})
	if not files[filename] then
		files[filename]=love.graphics.newImage(filename)
	end
	self.image = files[filename]
	self.xsize = xsize
	self.ysize = ysize
	self.frames = math.floor(self.image:getWidth()/self.xsize)
	self.animations = math.floor(self.image:getHeight()/self.ysize)
	self.currentFrame = 1
	self.currentAnim = 1
	self.time = 0
	self.perframe = 1/framerate
	if not quads[filename] then
		quads[filename] = {}
		for i=0,self.animations-1 do
			quads[filename][i+1] = {}
			for j=0,self.frames-1 do
				quads[filename][i+1][j+1] = love.graphics.newQuad(j*self.xsize,i*self.ysize,self.xsize,self.ysize,self.image:getWidth(),self.image:getHeight())
			end
		end
	end

	self.quads = quads[filename]

	return self
end

function anim_mt.update(self, dt)
	self.time = self.time+dt
	while self.time>0 do
		self.time = self.time-self.perframe
		self.currentFrame = self.currentFrame+1
		if self.currentFrame>self.frames then
			self.currentFrame=1
		end
	end
end

function anim_mt.draw(self, x, y, flip )
	love.graphics.drawq(self.image, self.quads[self.currentAnim][self.currentFrame],x,y,0,sel(flip,-1,1),1,sel(flip,self.xsize,0),0)
end