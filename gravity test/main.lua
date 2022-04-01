-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

bg = display.newImage("bg.jpg",160,220)
bg:toBack()

music = audio.loadSound("arkhē.mp3")
musicSettings = {}
musicSettings.loops = -1
musicChannel = audio.play(music, musicSettings)

chara = display.newImage("idle.png")
chara.x = 160
chara.y = 360
chara.ySpeed = 0
chara.yAccel = 0 

newFill = {}
newFill.type = "image"
newFill.filename = "jump.png"

newFill2 = {}
newFill2.type = "image"
newFill2.filename = "idle.png"

g = display.newText("Gravity:",160,10) 
gravity = 1


function keyPressed(event)
  print(event.keyName)
  keyboard = event.keyName
  g.text = "Gravity: " .. gravity .. "G" 

  if keyboard == "space" then
    if chara.y == 360 then
    chara.fill = newFill
    chara.ySpeed = -10
    chara.yAccel = gravity
    end
  end

    if keyboard == "up" then
    gravity = gravity + 0.1
    chara.yAccel = gravity
  end

  if keyboard == "down" then
    gravity = gravity - 0.1
    chara.yAccel = gravity
  end 
end

function mainLoop()
  chara.y = chara.y + chara.ySpeed
  chara.ySpeed = chara.ySpeed + chara.yAccel 

  if chara.y >= 360 then
    chara.y = 360
    chara.fill = newFill2 
  end 
end
Runtime:addEventListener("key", keyPressed)
Runtime:addEventListener("enterFrame", mainLoop) 