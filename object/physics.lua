local phys = {}

phys.count = 0        --How many objects have physics
phys.list = {}        --List of references to objects that have physics

phys.g = .45           --Amount of speed to add for gravity per step
phys.f = .4            --Amount of friction to add per step
phys.a = math.pi/2    --Gravity angle in radians
phys.max_s = 16       --Max gravity speed

phys.global_gravity = true
phys.global_friction = true

phys.collision_map = {}

function phys:takeAStep(a,s)
  local cos,sin = math.cos,math.sin
  self.x = self.x + cos(a)*s
  self.y = self.y + sin(a)*s
end

function phys:addImpulse(a,s)
  local cos, sin = math.cos, math.sin
  self.dx = self.dx + cos(a)*s
  self.dy = self.dy + sin(a)*s
end

function phys:givePhysics()
  if not self.has[phys] then
    self.has[phys] = true
    self.hascap = true
    self.hasgravity = true
    self.hasfriction = true
    self.hascartcap = false
    self.solid = true
    self.colliding = {}
    
    self.dx = 0
    self.dy = 0
    self.max_s = phys.max_s
    self.grav = phys.g
    self.fric = phys.f
    self.grav_a = phys.a
    self.h_cap = 16
    self.v_cap = 16
    
    self.cells = {}
    self.cell_ind = {}
    phys.count = phys.count + 1
    phys.list[phys.count] = self
  end
end

function phys.update()
  local obj
  local cos,sin = math.cos,math.sin
  for i = 1, phys.count do
    obj = phys.list[i]
    if phys.global_gravity and obj.hasgravity then phys.addGravity(obj) end
    if obj.hascap then phys.capSpeed(obj) end
    if obj.hascartcap then phys.capCartSpeed(obj) end
    if phys.global_friction and obj.hasfriction then phys.addFriction(obj) end
    if obj.solid then phys.doCollisions(obj) end
    
    --map:add(obj)

    obj.x = obj.x + obj.dx
    obj.y = obj.y + obj.dy
  end
    
end

function phys:doCollisions()
  local function resolve_bottom(self,tile)
    self.dy = 0
    self.y = math.floor(tile/phys.collision_map.width)*phys.collision_map.tileheight-self.h+self.cy
  end
  local function resolve_left(self,tile)
    self.dx = 0
    self.x = math.floor(tile%phys.collision_map.width)*phys.collision_map.tilewidth-self.bb_x+self.cx
    end
    local function resolve_right(self,tile)
    self.dx = 0
    self.x = math.floor(tile%phys.collision_map.width)*phys.collision_map.tilewidth-phys.collision_map.tilewidth-self.bb_x+self.cx-self.bb_w-2
    end
  local check = phys.checkTile
  local vertical_checks = math.floor(self.bb_h / phys.collision_map.tileheight)+1
  local horizontal_checks = math.floor(self.bb_w / phys.collision_map.tilewidth)+1
  local colliding = {}
  local tile
  
  for i = 1, horizontal_checks do
    tile = check((self.x-self.cx+self.bb_x)+i*phys.collision_map.tilewidth-phys.collision_map.tilewidth,self.y-self.cy+self.h)
    if tile then
      colliding.bottom = true
      if self.dy > 0 then
      resolve_bottom(self,tile)
      end
    end
  end
  tile = check((self.x-self.cx+self.bb_x+self.bb_w),self.y-self.cy+self.h)
    if tile then
      colliding.bottom = true
      resolve_bottom(self,tile)
    end
    
  for i = 1, vertical_checks do
    tile = check((self.x-self.cx+self.bb_x-1),self.y-self.cy+self.bb_y+i*phys.collision_map.tilewidth-phys.collision_map.tilewidth)
    if tile then
      colliding.left = true
      resolve_left(self,tile)
    end
  end
  tile = check((self.x-self.cx+self.bb_x-1),self.y-self.cy+self.bb_y+self.bb_h-8)
    if tile then
      colliding.left = true
      resolve_left(self,tile)
    end
    
  for i = 1, vertical_checks do
    tile = check((self.x-self.cx+self.bb_x+self.bb_w+2),self.y-self.cy+self.bb_y+i*phys.collision_map.tilewidth-phys.collision_map.tilewidth)
    if tile then
      colliding.left = true
      resolve_right(self,tile)
    end
  end
  tile = check((self.x-self.cx+self.bb_x+self.bb_w+2),self.y-self.cy+self.bb_y+self.bb_h-8)
    if tile then
      colliding.left = true
      resolve_right(self,tile)
    end
  self.colliding = colliding
end

function phys.checkTile(x,y)
  y = y/phys.collision_map.tileheight
  x = x/phys.collision_map.tilewidth
  y = (y-y%1)*phys.collision_map.width
  x = 1+x-x%1
  if phys.collision_map[y+x] and phys.collision_map[y+x] > 0 then return x+y end
end
  
function phys:addGravity()
    self.dx = self.dx + math.cos(self.grav_a)*self.grav
    self.dy = self.dy + math.sin(self.grav_a)*self.grav
end

function phys:capSpeed()
  local vlen = math.sqrt(self.dx*self.dx + self.dy*self.dy)
  if vlen > self.max_s then
    self.dx = (self.dx/vlen)*self.max_s
    self.dy = (self.dy/vlen)*self.max_s
  end
end

function phys:capCartSpeed()
  if self.dx > self.h_cap then self.dx = self.h_cap end
  if self.dx < -self.h_cap then self.dx = -self.h_cap end
  if self.dy > self.v_cap then self.dy = self.v_cap end
  if self.dy < -self.v_cap then self.dy = -self.v_cap end
end

function phys:addFriction()
  local mag = math.sqrt(self.dx*self.dx + self.dy*self.dy)
  local a = math.atan2(self.dy,self.dx)
  if mag > 0 then
    self.dx = self.dx + math.cos(a+math.pi) * self.fric
    self.dy = self.dy + math.sin(a+math.pi) * self.fric
    if mag-self.fric <= 0 then
      self.dx, self.dy = 0,0
    end
  end
end

return phys