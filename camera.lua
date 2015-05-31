camera = {}



function camera.load()
  camera.x = 0
  camera.y = 0
  camera.floor_x = 0
  camera.floor_y = 0
  camera.w = love.graphics.getWidth()
  camera.h = love.graphics.getHeight()
end

function camera.move(x,y)
  camera.x = x
  camera.y = y
  
end

function camera.follow(obj)
  camera.target = obj
  camera.x_off = love.graphics.getWidth() / 4
  camera.y_off = love.graphics.getHeight() / 4
end

function camera.update()
  --camera.x = camera.target.x  - camera.x_off
  --local xd_norm = 0
  local y_dist = (camera.target.y -camera.y_off- camera.y) 
  local x_dist = (camera.target.x -camera.x_off- camera.x) 

    camera.x = camera.x + x_dist/20
    camera.y = camera.y + y_dist/20
  
  --camera.y = camera.target.y - camera.y_off

  
  if camera.x < 0 then camera.x = 0 end
  if camera.y < 0 then camera.y = 0 end
  
  camera.floor_x = math.floor(camera.x)
  camera.floor_y = math.floor(camera.y)
end

  