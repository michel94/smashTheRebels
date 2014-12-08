require "helpers"
require "animation"
require "drawable"

function getObject(x, y)
	local object = {}

	object.objects = {}
	object.scale = 1
	object.x = 0
	object.y = 0
	if x then
		object.x = x
	end
	if y then
		object.y = y
	end	

	function object:move(x, y)
		self.x = x
		self.y = y
	end

	function object:add(raw)
		self.objects[#self.objects + 1] = raw
	end

	function object:update(dt)
		for index, obj in pairs(self.objects) do
			obj:update(dt)
		end
	end

	function object:draw()
		love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.scale(self.scale)
		for index, obj in pairs(self.objects) do
			obj:draw()
		end
		love.graphics.pop()
	end

	return object

end