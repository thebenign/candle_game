local draw = {}
--draw.__index = draw
draw.count = 0
draw.list = {}

draw.not_drawn = love.graphics.newImage("empty_box.png")

function draw:giveVisible(i,z) -- imageData
  if not self.has[visible] then
    self.has[visible] = true
    self.img = i
    self.cx = 0
    self.cy = 0
    self.z = z or 1000
    self.isvisible = true
    
    local new_list,mark = draw.addOrderedListItem(draw.list, self)
    self.olid = mark
    
    draw.count = draw.count + 1
    draw.list = new_list
  end
end

function draw.display()
  local obj
  local floor = math.floor
  for i = 1, draw.count do
    obj = draw.list[i]
    if obj:isOnCamera() then
      local img = obj.img
      love.graphics.draw(img,floor(obj.x)-camera.x,floor(obj.y)-camera.y,obj.rot,obj.facing,1,obj.cx,obj.cy)
      love.graphics.print(tostring(obj.colliding.left),obj.x-camera.x,obj.y-64-camera.y)
    end
  end
end

function draw.addOrderedListItem(list, obj)
  local new_list = {}
  local mark = nil
  for i = 1, draw.count do
    if obj.z < list[i].z then
      new_list[i] = obj
      mark = i
      break
    else
      new_list[i] = list[i]
    end
  end
  if not mark then
    new_list[visible.count+1] = obj
    mark = visible.count+1
  else
    for i = mark, visible.count do
      new_list[i+1] = list[i]
      list[i].olid = list[i].olid + 1
    end
  end
  return new_list,mark
end

function draw.removeOrderedListItem(obj)
  local new_list = {}
  local list = draw.list
  for i = 1, obj.olid-1 do
    new_list[i] = list[i]
  end
  for i = obj.olid, draw.count-1 do
    new_list[i] = list[i+1]
    list[i+1].olid = list[i+1].olid - 1
  end
  draw.list = new_list
  draw.count = draw.count - 1
end

function draw:removeVisible()
  if self.has[visible] then
    self.has[visible] = false
    draw.removeOrderedListItem(self)
  end
end

function draw.getVisibleObjectAt(x,y,...) --[number] x, [number] y|, [boolean] When true, check for invisible rather than visible.
  local arg = {...}
  local negate = arg[1] or false
  local obj = draw.list
  for i = draw.count, 1, -1 do
    if (obj[i].isvisible == not negate) and math.sqrt((obj[i].x-x)*(obj[i].x-x) + (obj[i].y-y)*(obj[i].y-y)) < obj[i].w/2 then
      return obj[i]
    end
  end
end
return draw