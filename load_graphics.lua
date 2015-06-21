love.graphics.setDefaultFilter("nearest","nearest")

graphics = {}

graphics.tile = {}

graphics.candle = love.graphics.newImage("/graphics/candle.png")
graphics.raindrop = love.graphics.newImage("/graphics/raindrop.png")

for i, v in ipairs(map.tilesets[1].tiles) do
  graphics.tile[i] = love.graphics.newImage(v.image)
  
end