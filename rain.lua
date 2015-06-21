--rain--

rain = {}
rain.active = false
rain.drop = {}
rain.enum = 0
rain.density = 400
rain.speed = 8
rain.a = 2.09

function rain.init()
    rain.active = true
end

function rain.update()
  
  --for i = (rain.density - rain.enum), 1, -1 do
  while rain.enum < rain.density do
    rain.new()
  end
  
  for i = rain.enum, 1, -1 do
    rain.dropupdate(rain.drop[i])
  end
  
end

function rain.draw()
  
  if rain.active then
    for i = rain.enum, 1, -1 do
      lg.draw(graphics.raindrop, rain.drop[i].x-camera.x, rain.drop[i].y-camera.y)
    end
  end
  
end

  
function rain.new()
  rain.enum = rain.enum + 1
  local new_drop = {}
  new_drop.id = rain.enum
  new_drop.update = rain.dropupdate
  new_drop.kill = rain.dropkill
  new_drop.x = math.random(1,4000)
  new_drop.y = math.random(1,400)
  new_drop.a = math.random()*.5
  rain.drop[rain.enum] = new_drop
end


function rain.dropupdate(self)
  self.x = self.x + math.cos(rain.a+self.a)*rain.speed
  self.y = self.y + math.sin(rain.a+self.a)*rain.speed
  if self.y > 4000 then rain.dropkill(self) end
end

function rain.dropkill(self)
  --rain.drop[self.id] = rain.drop[rain.enum]
  --rain.enum = rain.enum - 1
    self.x = math.random(1,4000)
  self.y = math.random(1,0)
end
