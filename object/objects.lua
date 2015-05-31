-------------------------------------------
--[[ Super Generic Game Object Library ]]--
-------------------------------------------

visible = require "draw"
phys = require "physics"
collider = require "collidoscope"
controller = require "controls"

function camera:isOnCamera()
  if self.x+self.w > camera.x and self.x < camera.x+camera.w and self.y+self.h > camera.y and self.y < camera.y+camera.h then return true end
end
function camera.isPointOnCamera(x,y)
  if x > camera.x-100 and x < camera.x+camera.w+100 and y > camera.y-200 and y < camera.y+camera.h+100 then return true end
end

local object = {}
object.__index = object
object.count = 0

object.graphics = visible
object.physics = phys

object.isOnCamera = camera.isOnCamera
object.takeAStep = phys.takeAStep
object.addImpulse = phys.addImpulse

object.giveVisible = visible.giveVisible
object.removeVisible = visible.removeVisible

object.givePhysics = phys.givePhysics

object.giveControls = controller.giveControls

--object.getCellsFor = collider.getCellsFor
--object.calculateCell = collider.calculateCell

setmetatable(object, {
  __call = function (_, ...)
  return object.new(...)
  end
})

function object.new()
local self = setmetatable({},object)

self.is_a = {[object]=true}
self.has = {}
self.t = 60
self.dt = 0
self.timer_start = false
self.timer_loop = false

  self.x = 0
  self.y = 0
  self.z = 0
  self.a = 0
  self.s = 0
  self.w = 32
  self.h = 32
  self.rot = 0
  self.scale = 1
  self.facing = 1
  self.update = function() end
  self.updateListener = function()
    if self.timer_start then
      self.dt = self.dt + 1
    end
    if self.dt > self.t then
      self.timerListener()
      self.timerFunction()
    end
  end
  self.timerFunction = function() end
  self.timerListener = function()
    self.dt = 0
    if not self.timer_loop then
      self.timer_start = false
    end
    
  end
  
object.count = object.count + 1
self.id = object.count
object[object.count] = self
return self
end

function object.update()
  for i = 1, object.count do
    object[i].updateListener(object[i])
    object[i].update(object[i])
  end
end

function object:startTimer()
  self.timer_start = true
end

function object:AngleToPoint(x,y)
  return math.atan2(y-self.y,x-self.x)
end

function object:remove()
  object.list[self.id] = object.list[object.count]
  object.count = object.count - 1
  self = nil
end


function object.getObjectAt(x,y)
  local obj = object.list
  for i = object.count, 1, -1 do
    if math.sqrt((obj[i].x-x)*(obj[i].x-x) + (obj[i].y-y)*(obj[i].y-y)) < obj[i].w/2 then
      return obj[i]
    end
  end
end

return object