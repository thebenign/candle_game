local emitter = {}
emitter.__index = emitter
local part_img = love.graphics.newImage("graphics/particle02.tga")
emitter.part_batch = love.graphics.newSpriteBatch(part_img,4000,"static")

function emitter.new(...)
  local args = {...}
  local x, y = args[1] or 0, args[2] or 0
  local self = setmetatable({}, emitter)
  self.obj = {}
  self.enum = 0
  self.emit_dt = 0
  self.emit_t = 1
  self.part_t = 30
  self.pps = 1
  self.a = 0
  self.spread = 360
  self.s = 0
  self.acc_a = 0
  self.acc_s = 0
  self.tang_d = 0
  self.color = {255,255,255,255}
  self.diam = 8
  self.scale = 1
  self.min_s = 0
  self.fric = 0
  
  self.x, self.y = x, y
  return self
end

function emitter:update()
  local rand = math.random
  local cos, sin = math.cos, math.sin
  self.emit_dt = self.emit_dt + 1
  
  if self.emit_dt > self.emit_t then
    for i = 1, self.pps do
      self.enum = self.enum + 1
      self.emit_dt = 0
      self.obj[self.enum] = {}
      self.obj[self.enum].x = self.x
      self.obj[self.enum].y = self.y
      self.obj[self.enum].a = self.a + rand()*self.spread-(self.spread*.5)
      self.obj[self.enum].min_s = self.min_s
      self.obj[self.enum].s = self.min_s + rand()*(self.s-self.min_s)
      self.obj[self.enum].xd = cos(self.obj[self.enum].a)*self.obj[self.enum].s
      self.obj[self.enum].yd = sin(self.obj[self.enum].a)*self.obj[self.enum].s
      self.obj[self.enum].acc_a = self.acc_a
      self.obj[self.enum].acc_s = self.acc_s
      self.obj[self.enum].dt = 0
      self.obj[self.enum].t = self.part_t
      self.obj[self.enum].diam = self.diam
      self.obj[self.enum].scale = self.scale
      self.obj[self.enum].tang_d = self.tang_d
      self.obj[self.enum].color = {255,255,255,255}
      self.obj[self.enum].fric = self.fric
    end
  end
  
  local x, y
  
  for k = 1, self.enum do
    self.obj[k].dt = self.obj[k].dt + 1
    if self.obj[k].dt > self.obj[k].t then
      self.obj[k] = self.obj[self.enum]
      self.enum = self.enum - 1
    end
	
    self.obj[k].xd = self.obj[k].xd + cos(self.obj[k].acc_a)*self.obj[k].acc_s
    self.obj[k].yd = self.obj[k].yd + sin(self.obj[k].acc_a)*self.obj[k].acc_s
    self.obj[k].x = self.obj[k].x + self.obj[k].xd
	  self.obj[k].y = self.obj[k].y + self.obj[k].yd
	  addFriction(self.obj[k])
  end
  return self
end

function addFriction(obj)
  local mag = math.sqrt(obj.xd^2 + obj.yd^2)
  local a = math.atan2(obj.yd,obj.xd)
  if mag > .05 then
    obj.xd = obj.xd - math.cos(a) * obj.fric
    obj.yd = obj.yd - math.sin(a) * obj.fric
  else
    obj.xd = 0
	  obj.yd = 0
  end
end

function emitter:draw()
  local cx = camera.x
  local cy = camera.y
  local rr,rg,rb,ra = love.graphics.getColor()

  local c = self.color
  self.part_batch:setColor(c)

  for k = 1, self.enum do
	  self.id = emitter.part_batch:add(self.obj[k].x-cx, self.obj[k].y-cy,0,(1-self.obj[k].dt/self.obj[k].t)*self.obj[k].scale,(1-self.obj[k].dt/self.obj[k].t)*self.obj[k].scale,16,16)
  end
  
  love.graphics.setColor(rr,rg,rb,ra)
end


function emitter.drawAll()
  love.graphics.setBlendMode("additive")
  love.graphics.draw(emitter.part_batch,0,0)
  love.graphics.setBlendMode("alpha")
end
function emitter:burst()
  
end

function emitter:move(x,y)
  self.x = x
  self.y = y
end

function emitter:setParticlesPerStep(v)
  self.pps = v
end
function emitter:setEmitterDelta(v)
  self.emit_t = v
  self.emit_dt = v
end

function emitter:setLifeTime(v)
  self.part_t = v
end
function emitter:setAngle(v)
  self.a = v
end
function emitter:setSpread(v)
  self.spread = math.pi/180*v
end
function emitter:setSpeed(v)
  self.s = v
end
function emitter:setMinSpeed(v)
  self.min_s = v
end
function emitter:setAccelAngle(v)
  self.acc_a = v
end
function emitter:setAccelSpeed(v)
  self.acc_s = v
end
function emitter:setFric(v)
  self.fric = v
end
function emitter:setColor(r,g,b,a)
 self.color = {r,g,b,a}
end
function emitter:setScale(v)
  self.scale = v
end
function emitter:noAdd()
  self.add = nil
end
return emitter