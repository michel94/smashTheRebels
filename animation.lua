require "helpers"

function getAnimation(frames, speed)
	local animation = {}
	animation.frames = {}
	for i, v in pairs(frames) do
		animation.frames[i] = v
	end
	animation.nframe = 1
	animation.speed = speed
	animation.time = 0
	animation.frame = animation.frames[1]

	function animation:updateAnimation(dt)
		self.time = self.time + dt
		if self.time < self.speed then
			return
		end

		self.time = 0
		self.nframe = mod(self.nframe, #self.frames) + 1
		self.frame = self.frames[self.nframe]	
	end

	function animation:newInstance()
		t = {}
		for i, v in pairs(self) do
			t[i] = v
		end
		return t
	end

	return animation
end

