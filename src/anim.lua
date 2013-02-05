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
	self.perframes = {}
	for i=1,self.animations do
		self.perframes[i] = {type="static",rate=1/framerate}
	end
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

function anim_mt.setAnimType(self, anim, type, min, max)
	self.perframes[anim].type = type
	self.perframes[anim].min = min
	self.perframes[anim].max = max
end

function anim_mt.update(self, dt)
	self.time = self.time+dt
	while self.time>0 do
		self.time = self.time-self.perframes[self.currentAnim].rate
		self.currentFrame = self.currentFrame+1
		if self.currentFrame>self.frames then
			self.currentFrame=1
			if self.perframes[self.currentAnim].type == "randomise" then
				self.perframes[self.currentAnim].rate = 1/math.random(self.perframes[self.currentAnim].min,self.perframes[self.currentAnim].max)
			end
		end
	end
end

function anim_mt.draw(self, x, y, flip )
	love.graphics.drawq(self.image, self.quads[self.currentAnim][self.currentFrame],x,y,0,sel(flip,-1,1),1,sel(flip,self.xsize,0),0)
end