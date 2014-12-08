require "object"

function getHealthBar(size)
	local healthBar = getObject()

	healthBar.health = 100
	healthBar.size = size
	healthBar.height = 12

	function healthBar:setHealth(h)
		self.health = h
	end

	function healthBar:draw()
		love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.scale(self.scale, self.scale)
		
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("fill", -1, -1, self.size+2, self.height+2)
		love.graphics.setColor(200, 5, 5, 255)
		love.graphics.rectangle("fill", 0, 0, self.size, self.height)
		love.graphics.setColor(5, 200, 5, 255)
		if self.health > 0 then
			love.graphics.rectangle("fill", 0, 0, self.size*self.health/100, self.height)
		end
		love.graphics.pop()
	end

	return healthBar
end