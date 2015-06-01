package.path = package.path .. ";./object/?.lua" -- Some stupid path shit because modules can't have dependancies otherwise.

require "camera"
map = require "maps.standard map"
require "load_graphics"
require "alias"
emitter = require "emitter_class"
require "dialog"
require "sfx"
require "object.objects"


function love.load(arg)
  
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Debugging module from zerobrane
  
  love.window.setMode(1300,800,{fullscreen=false,vsync=false,resizable=false})
  love.graphics.setBackgroundColor(30,200,255)
  
  camera.load() -- Always call load function after setting screen rez so camera can resize apropriately

  
  t = {}
    t.dt = 0
    t.step_time = 1/60
  
  hero = {}
  hero.x = 300
  hero.y = 300
  hero.xd = 0
  hero.yd = 0
  hero.ds = 1
  hero.max_speed = 2
  hero.friction = .25
  hero.emitter = emitter.new(hero.x,hero.y)
  hero.emitter:setScale(.25)
  hero.emitter:setColor(255,0,0,255)
  hero.emitter:setSpeed(1)
  hero.emitter:setAngle(math.rad(270))
  hero.emitter:setSpread(10)
  hero.emitter:setLifeTime(15)
  hero.emitter:setEmitterDelta(0)
  hero.emitter:setParticlesPerStep(1)
  hero.emitter:setMinSpeed(.2)
  hero.emitter:setAccelAngle(math.rad(270))
  hero.emitter:setAccelSpeed(.01)
  
  camera.follow(hero)
end

function love.update(dt)
  t.dt = t.dt + dt
  
  while t.dt > t.step_time do
    hero.emitter:update()
    
    handleKeys()
    move(hero)
    doFriction(hero)
    hero.emitter.x = hero.x+15
    hero.emitter.y = hero.y+6
    camera.update()
    dialog.update()
    
    t.dt = t.dt - t.step_time
    
  end
  
end

function love.resize()
    camera.load()
    camera.follow(hero)
  end
  
  function love.draw()
    
    drawMap(map)
    love.graphics.scale(2,2)
    love.graphics.draw(graphics.candle, hero.x-camera.floor_x, hero.y-camera.floor_y)
    emitter.part_batch:clear()
    hero.emitter:draw()
    emitter:drawAll()
    dialog.draw()
    lg.print(tostring(love.timer.getFPS()),30,30)
  end
  
  
  function handleKeys()
    if love.keyboard.isDown("w") then
      hero.yd = hero.yd - hero.ds
    end
    if love.keyboard.isDown("s") then
      hero.yd = hero.yd + hero.ds
    end
    if love.keyboard.isDown("a") then
      hero.xd = hero.xd - hero.ds
    end
    if love.keyboard.isDown("d") then
      hero.xd = hero.xd + hero.ds
    end
    if love.keyboard.isDown("escape") then love.event.quit() end
    
  end
  
function love.keypressed(key, isrepeat)
    if key == " " then
      dialog.display({dialog.rnd_text()})
    end
end
    
  function move(obj)
    if obj.xd > obj.max_speed then obj.xd = obj.max_speed end
    if obj.xd < -obj.max_speed then obj.xd = -obj.max_speed end
    if obj.yd > obj.max_speed then obj.yd = obj.max_speed end
    if obj.yd < -obj.max_speed then obj.yd = -obj.max_speed end
    obj.x = obj.x + obj.xd
    obj.y = obj.y + obj.yd
  end
  
  function doFriction(obj)
    local xd_norm = obj.xd / math.abs(obj.xd)
    local yd_norm = obj.yd / math.abs(obj.yd)
    if obj.xd ~= 0 then obj.xd = obj.xd - xd_norm * obj.friction end
    if obj.yd ~= 0 then obj.yd = obj.yd - yd_norm * obj.friction end
  end
  
  function drawMap(map)
    local x, y, layer
    for layer = 1, 3 do
      for y = 1, map.height do
        for x = 1, map.width do
          if map.layers[layer].data[(y-1)*map.width+x] ~= 0 and camera.isPointOnCamera((x-1)*map.tilewidth-camera.floor_x,(y-1)*map.tileheight-50-camera.floor_y) then
            lg.draw (graphics.tile[map.layers[layer].data[(y-1)*map.width+x]],(x-1)*map.tilewidth-camera.floor_x*2,(y-1)*map.tileheight-50-camera.floor_y*2) -- remove 50 from the y for asthetic purposes.
          end
        end
      end
    end
  end
