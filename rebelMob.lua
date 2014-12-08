require "helpers"
require "drawable"
require "math"
math.randomseed( os.time() )

function getRebelMob(x, y, n, farms)
	local rebelMob = getObject()
	rebelMob.updateParent = rebelMob.update
	rebelMob.x = x
	rebelMob.y = y
	rebelMob.w = 50
	rebelMob.h = 50
	rebelMob.farms = farms

	for i=1,n do
		x = math.random(0,rebelMob.w)
		y = math.random(0,rebelMob.h)
		rebelMob:add(getRebel(x, y))
		--print(rebelMob.rebels[i].x .. " " .. rebelMob.rebels[i].y)
	end

	function rebelMob:update(dt)
		rebelMob:updateParent(dt)

		if self.cl ~= -1 and farms[self.cl] == nil then
			self.cl = self:findClosest()
		end

		if self.cl ~= -1 then
			local dx = self.x - self.farms[self.cl].x
			local dy = self.y - self.farms[self.cl].y
			local ang = math.atan2(dy, dx)
			self.x = self.x + -20 * dt * math.cos(ang)
			self.y = self.y + -20 * dt * math.sin(ang)

			if distance2(self.x, self.y, farms[self.cl].x , farms[self.cl].y) < 300 then
				farms[self.cl]:setHealth(farms[self.cl].health - (#self.objects/10) * 6 * dt)
				if farms[self.cl].health < 0 then
					farms[self.cl] = nil
				end
			end

		end
	end

	function rebelMob:findClosest()
		local bestd, best = 1000000, -1
		for i, v in pairs(self.farms) do
			local d = distance2(self.x, self.y, v.x, v.y)
			if d < bestd then
				bestd = d
				best = i
			end
		end
		return best
	end

	function rebelMob:getRebels()
		return self.objects
	end

	rebelMob.cl = rebelMob:findClosest()

	return rebelMob

end

function getRebel(x, y)
	rebel = getObject(x, y)
	rebel.scale = 0.5
	rawRebel = getRaw(images.rebel, 0, 0, 2)
	rawFire = getRaw(images.fire:newInstance(), 0, 0, 0.5)
	rebel:add(rawRebel)
	rebel:add(rawFire)
	-- TODO: getWidth/getHeight
	rebel.w = images.rebel:getWidth() * 2
	rebel.h = images.rebel:getHeight() * 2

	return rebel
end