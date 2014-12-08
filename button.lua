function getButton(img, x, y)
	local button = {}
	if x == "center" then
		button.x = love.graphics.getWidth()/2 - img:getWidth()/2
	else
		button.x = x
	end

	button.y = y
	button.w = img:getWidth()
	button.h = img:getHeight()
	button.img = img

	function button:draw()
		love.graphics.draw(self.img, self.x, self.y)
	end

	function button:checkClick(x, y)
		return x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h
	end

	return button

end