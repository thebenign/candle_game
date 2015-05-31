spatial = {}
spatial.__index = spatial

function spatial.newHash(size)
  local hash = setmetatable({}, spatial)
  hash.size = size
  hash.w = math.ceil(world.w/size)
  hash.h = math.ceil(world.h/size)
  return hash
end

function spatial:populate(obj)
  local floor = function (x) return x-(x%1) end
  
  for i = 1, obj.enum do
    local bin = floor(obj[i].y/self.size)*self.w + floor(obj[i].x/self.size)+1
	if obj[i].bin ~= bin then
	  if not self[bin] then
	    self[bin] = {}
		self[bin].enum = 0
	  end
	  if obj[i].bin > 0 then
	    self[obj[i].bin][obj[i].sub_bin] = self[obj[i].bin][self[obj[i].bin].enum]
	    self[obj[i].bin].enum = self[obj[i].bin].enum - 1
	  end
	  
	  self[bin].enum = self[bin].enum + 1
	  local sub_bin = self[bin].enum
	  
	  self[bin][sub_bin] = obj[i]
	  
	  obj[i].bin = bin
	  obj[i].sub_bin = sub_bin
	  
	  populating = bin..":"..sub_bin
	end
  end
end

function spatial:clear()
 --self 
end

function flr (x)
  return x-x%1
end

function spatial.getBin(hash, obj)
  local floor = function (x) return x-(x%1) end
  local bin = floor(obj.y/hash.size)*hash.w + floor(obj.x/hash.size)+1
  if hash[bin] then local enum = hash[bin].enum
  else enum = 0
  end
  return bin, enum
end