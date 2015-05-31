local control = {}
control.__index = control
control.defaults = {count = 7,"up","down","left","right","a","s","d","return"}
control.list = {}
control.count = 0

function control.new(...)
  local args = {...}
  local ct = args[1] or control.defaults
  assert(type(ct) == "table","Control must be passed a table of keyboard constants.")
  local self = setmetatable(ct, control)
  self.control_function = {}
  self.control_release_function = {}
  self.isDown = {}
  return self
  
end


function control.update()
  for i = 1, control.count do
    local obj = control.list[i]
    for j = 1, obj.controller.count do
      if love.keyboard.isDown(obj.controller[j]) then
        obj.controller.isDown[obj.controller[j]] = true
        if obj.controller.control_function[j] then
          obj.controller.control_function[j](obj)
        end
      else
        obj.controller.isDown[obj.controller[j]] = false
      end
    end
  end
end

function control.getControlMethod()
  
end

function control:giveControls(control_obj)
  assert(getmetatable(control_obj)==control,"Not a valid controller object")
  if not self.has[control] then
    self.has[control] = true
    self.controller = control_obj
    control.count = control.count + 1
    control.list[control.count] = self
  end
  
end

function control.setup()
end
return control