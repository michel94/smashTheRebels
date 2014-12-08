
function getRaw(source, x, y, scale)
	local raw = {}
	raw.image = source
	raw.x = x
	raw.y = y
	raw.scale = scale

	function raw:draw()
		love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.scale(self.scale, self.scale)
		love.graphics.setColor(255,255,255)
		if self.image["frame"] then
			love.graphics.draw(self.image.frame)
		else
			love.graphics.draw(self.image)
		end

		love.graphics.pop()
	end

	function raw:update(dt)
		if self.image["updateAnimation"] then
			self.image:updateAnimation(dt)
		end
	end

	return raw

end