-- dialog module --

dialog = {}
dialog.timer = 2
dialog.dt = 0
dialog.active = false
dialog.field = 1

function dialog.rnd_text()
  return dialog.texts[math.random(1,#dialog.texts)]
end


function dialog.display(text)
  --[[
  Argument is a table of strings to display.
  Displays each string sequentially.
  Pressing a key advances the text to the next string.
  ]]
  dialog.text = text
  dialog.concat = ""
  dialog.active = true
  dialog.i = 0
  dialog.field = 1
  dialog.end_field = false
  
end

function dialog.update()
  if dialog.active then
    dialog.dt = dialog.dt + 1
    if dialog.dt > dialog.timer and not dialog.end_field then
      dialog.dt = 0
      dialog.i = dialog.i + 1
      dialog.concat = dialog.text[1]:sub(1,dialog.i)
      if dialog.concat:match("%w",dialog.i) then
        sfx.blip:rewind()
        sfx.blip:play()
      end
      
      if dialog.i == #dialog.text[dialog.field] then
        dialog.end_field = true
      end
    end
        
  end
end

function dialog.draw()
  if dialog.active then
    lg.setColor(80,80,80,120)
    love.graphics.rectangle("fill",16,284,616,100)
    lg.setColor(255,255,255,255)
    love.graphics.printf(dialog.concat, 32, 300, 600)
    
    if dialog.end_field then 
      love.graphics.print("(Press space to continue...)",448,365)
    end
    
  end
end

dialog.texts = 
  {
  "A war is just like unemployment.",
  "That boy, that being of sullied sanity, with his lantern and his hat.",
  "He was absolutely sure that crazy man was crying all day.",
  "I never wanted to be a mutant, but that's a lie.",
  "During a political crisis you definitely want to be a football player.",
  "There were three librarys, which made things a lot more complicated.",
  "A famine will be just like death - she always said that.",
  "I have a story about cruelty, unemployment, and an astronaut - and it's a story not worth telling.",
  "My life is just like the legend of Lemminkainen, except I'm a peasant.",
  "Around here, everyone has a story about cruelty and a detective.",
  "It was summer, the season of drug addiction.",
  "One space war can change your life, four however . . .",
  "His life is just like the story of Noah, only bloodier.",
  "My life is almost exactly like the story of Chicken Little.",
  "Her life is basically the story of Mohammed, only she was a chemist.",
  "That woman, always sleeping, always the lover of hope.",
  "Then came the dark gods.",
  "I've got my outfits - now I'm ready.",
  "He was just a man with a bottle.",
  "Science is a mad lady, but nobody knew that.",
  "The wind is breathing.",
  "She lived for evil, but would die for religion."
}