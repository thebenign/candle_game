love.graphics.setDefaultFilter("nearest","nearest")

graphics = {}

graphics.tile = {}

graphics.candle = love.graphics.newImage("/graphics/candle.png")

for i, v in ipairs(map.tilesets[1].tiles) do
  graphics.tile[i] = love.graphics.newImage(v.image)
  
end