
function mod(a, b)
	return a - math.floor(a/b)*b
end

function length(t)
	count = 0
	for index, value in pairs(t) do
	  count = count + 1
	end
	return count
end

function loadImage(name)
	im = love.graphics.newImage(name)
	im:setFilter("nearest", "nearest")
	return im
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function p2(a)
	return a*a
end

function distance2(x1, y1, x2, y2)
	return p2(x1-x2) + p2(y1-y2)
end

function intersects(r1, r2)
	return (r1.x + r1.w >= r2.x and r2.x + r2.w >= r1.x) and (r1.y + r1.h >= r2.y and r2.y + r2.h >= r1.y)
end
