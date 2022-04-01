-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local widjet = require("widget")
json = require("json")

r = {}
character = display.newGroup()
item = display.newGroup()
ob = display.newGroup() 

function saveNow()
  fileName = "saveFile.txt" 
  folderPath = system.DocumentsDirectory
  filePath = system.pathForFile(fileName, folderPath) 
  saveFile = io.open(filePath, "w") --'w' stands for write.
  saveObject = {}
  saveObject.highscore = 1000
  saveObject.myscore = 100 
  saveData = json.encode(saveObject) 
  saveFile:write(saveData)
  io.close(saveFile)
end


function loadNow()
  fileName = "saveFile.txt"
  folderPath = system.DocumentsDirectory
  filePath = system.pathForFile(fileName, folderPath)
  saveFile = io.open(filePath, "r") --'r' stands for read.
  if saveFile == nil then
    print("Saved file not found!")
  else
    saveData = saveFile:read("*a") -- '*a' stands for all. 
    saveObject = json.decode(saveData)
    print(saveObject.highscore)
    end
end 
loadNow() 


function game()
--background--
bg1 = display.newImage("bg1.jpg",240,90) 
bg1.xScale = 0.25
bg1.yScale = 0.25
bg1:toBack()

bg2 = display.newImage("bg2.jpg",240 - bg1.width*bg1.xScale,90)
bg2.xScale = 0.25
bg2.yScale = 0.25
bg2:toBack()

--Misc.-- 
gravity = 1
score = 0
health = 5
jump = 0
count = 0 
sp = 80
over = false 
run = "start" 

--Text--
stext = display.newText("Score: " .. score, 60, 270)
stext.xScale = 2
stext.yScale = 2

htext = display.newText("Health: " .. health, 60, 290)
htext.xScale = 2
htext.yScale = 2
--BGM--
music = audio.loadSound("bgm.mp3")
musicSettings = {}
musicSettings.loops = -1
musicChannel = audio.play(music, musicSettings)

--SFX--
hurt = audio.loadSound("hurt.wav")
get = audio.loadSound("coin.wav") 
gameover = audio.loadSound("gameover.mp3")
jumping = audio.loadSound("jump.wav")
click = audio.loadSound("click.wav")
--sprite + animation-- 
sizes = {}
sizes.width = 64
sizes.height = 74
sizes.numFrames = 103

gsizes = {}
gsizes.width = 60
gsizes.height = 60
gsizes.numFrames = 30

chara = graphics.newImageSheet("hi.png", sizes)
box = graphics.newImageSheet("crystal.png", gsizes) 

animation = {}
animation.name = "idle"
animation.start = 1
animation.count = 9
animation.loopCount = 0 
animation.time = 1000

animation2 = {} 
animation2.name = "walk"
animation2.start = 13
animation2.count = 4
animation2.loopCount = 0 
animation2.time = 250

animation3 = {} 
animation3.name = "knockback"
animation3.start = 49
animation3.count = 3
animation3.loopCount = 1
animation3.time = 300

animation4 = {}
animation4.name = "death"
animation4.start = 97
animation4.count = 6
animation4.loopCount = 1
animation4.time = 600

animation5 = {}
animation5.name = "itemspin"
animation5.start = 1
animation5.count = 30
animation5.loopCount = 0
animation5.time = 50

animations = {}
animations[1] = animation 
animations[2] = animation2
animations[3] = animation3 
animations[4] = animation4 
animations[5] = animation5 

--character sprite-- 
mikelle = display.newSprite(chara, animations) 
mikelle:setSequence("walk") 
mikelle:play()
mikelle.x = 390
mikelle.y = 290
mikelle.xScale = 0.9
mikelle.yScale = 1
mikelle.ySpeed = 0
mikelle.yAccel = 1
mikelle:toFront()
character:insert(mikelle) 
end 

function newGame()
  score = 0
  health = 5
--Others
  sp = 80
  jump = 0
  count = 0 
  over = false
  run = "start"
end

function reset(event)
  if event.phase == "began" then
    audio.play(click) -- button sound
    for index2 = ob.numChildren, 1, -1  do
      pillar = ob[index2]
      removePillar(index2)
    end
    for index3 = item.numChildren,1 , -1 do
      coin = item[index3]
      removeitem()
    end
    newGame()
    run = "start"
    mikelle:setSequence("walk") 
    mikelle:play()
    print("newgame")
  end
end
game() 

--Collision Making--
function checkCollision(black, white,h,w)
  if black.x > white.x - (white.width*white.xScale/2)*w and
  black.x < white.x + (white.width*white.xScale/2)*w and
  black.y > white.y - (white.height*white.yScale/2)*h and
  black.y < white.y + (white.height*white.yScale/2)*h then
    return true
  else
    return false
  end
end 

  function checkCollision_doublecircle(object1, object2,s1,s2)
    xDistance = object2.x - object1.x
    yDistance = object2.y - object1.y
    distanceA = math.sqrt(xDistance^2 + yDistance^2)
    distanceB = ((((object1.width * object1.xScale)/2) + ((object1.height * object1.yScale)/2))/2)/s1
    distanceC = ((((object2.width * object2.xScale)/2) + ((object2.height * object2.yScale)/2))/2)/s2
    if distanceA <= distanceB + distanceC then
      return true
    else
      return false
    end
  end
  
--obstacles--
function summonPillar(x, height, y)
  pillar = display.newImage("pillar.png", x, y)
  pillar.xScale = height
  pillar.yScale = height
  ob:insert(pillar)
end

function animatePillar()
  pillar.x = pillar.x + 5
end

function removePillar()
  pillar:removeSelf()
  pillar = nil
end

--item sprite--  
function generateitem(one,two) 
  coin = display.newSprite(box, animations) 
  coin.xScale = 1 
  coin.yScale = 1
  coin.x = one
  coin.y = two
  coin:setSequence("flip")
  coin:play()
  item:insert(coin) 
end 

function animateitem()
  coin.x = coin.x + 5
end

function removeitem()
  coin:removeSelf()
  coin = nil
end 

--Sequences
function Se1() 
  generateitem(120, 230)
  generateitem(80, 190)
  generateitem(40, 150)
  generateitem(20, 230)
  summonPillar(100, 0.2, 280)
end

function Se2()
  generateitem(100, 200)
  generateitem(50, 200)
  generateitem(0, 200)
   if math.random(1, 2) == 1 then
    summonPillar(60, 0.2, 280)
    end 
end

function Se3()
  generateitem(100, 220)
  generateitem(50, 170)
  generateitem(0, 220)
  summonPillar(70, 0.2, 280)
end

function Se4() 
  generateitem(120, 240)
  generateitem(80, 200)
  generateitem(40, 160)
  random = math.random(1, 2)
  if random == 1 then
    summonPillar(30, 0.2, 280)
  end

  if random == 2 then
    summonPillar(40, 0.2, 280)
  end
end

function Se5() 
  generateitem(120, 180)
  generateitem(80, 140)
  generateitem(40, 180)
  generateitem(0, 140)
  summonPillar(0, 0.2, 280)
end

function Se6()
  generateitem(120, 180)
  generateitem(80, 140)
  generateitem(40, 120)
  generateitem(0, 180)
  summonPillar(30, 0.4, 270) 
  summonPillar(85, 0.4, 270)
end

--moving background--
function bg(event)
  bg1.x = bg1.x + 1
  bg2.x = bg2.x + 1
  if bg2.x >= 240 then
    bg1.x = bg2.x - bg1.width*bg1.xScale
  end

  if bg1.x >= 240 then
    bg2.x = bg1.x - bg2.width*bg2.xScale 
  end 
  
    if health == 0 then
    bg1.x = bg1.x - 1
    bg2.x = bg2.x - 1
  end 
end 
Runtime:addEventListener("enterFrame", bg)

--Collision Set Up-- 
function Collision1()
  for index = character.numChildren, 1, -1 do
    mikelle = character[index]
    for index2 = ob.numChildren, 1, -1 do
      pillar = ob[index2]
      if checkCollision(mikelle, pillar,0.2,0.2) == true then
        audio.play(hurt)
        mikelle:setSequence("knockback") 
        mikelle:play()
        health = health - 1
        count = 1 
        print("ouch!")
        removePillar(index2)
        over = true
        break
      end
    end
  end
end

function Collision2()
  for index = character.numChildren, 1, -1 do
    mikelle = character[index]
    for index3 = item.numChildren, 1, -1 do
      coin = item[index3]
      if checkCollision_doublecircle(mikelle,coin,1.1,1.1) == true then 
        audio.play(get)
        score = score + 1
        print("get!")
        removeitem(index3) 
        break
      end
    end
  end
end

--jumping / keyboard code-- 
function keyPressed(event)
  print(event.keyName)
  keyboard = event.keyName

  if keyboard == "space" and event.phase == "down" and run == "start" then
    if mikelle.y == 290 then
      mikelle:setSequence("idle")
      mikelle:play()
      mikelle.ySpeed = -13
      mikelle.yAccel = gravity
      audio.play(jumping)
      jump = 1 
    end
  end 

  if keyboard == "space" and jump == 1 and event.phase == "down" and run == "start" then
    if mikelle.y < 290 then
      mikelle.ySpeed = -13
      audio.play(jumping)
      jump = 2
    end
  end
end 
Runtime:addEventListener("key", keyPressed)

--Main Loop Mama Mia--
function mainLoop()
  --chara setup 
    if run == "start" then
    stext.text = "Score: " .. score
    htext.text = "Health: " .. health
    mikelle.y = mikelle.y + mikelle.ySpeed

    if mikelle.y < 290 then
      mikelle.ySpeed = mikelle.ySpeed + mikelle.yAccel
    end
    sp = sp - 1 

--jumping back to running
    if mikelle.y >= 290 and mikelle.ySpeed > 0 then
      mikelle.ySpeed = 0 
      mikelle.yAccel = 0
      mikelle.y = 290
      mikelle:setSequence("walk") 
      mikelle:play() 
    end 
    
    if count == 1 then
      count = 0 
      mikelle:setSequence("walk") 
      mikelle:play()
      end 

    if sp == 1 then
      sp = math.random(55, 85)
      random2 = math.random(1, 6)
      if random2 == 1 then
        Se1()
      end
      if random2 == 2 then
        Se2()
      end
      if random2 == 3 then
        Se3()
      end
      if random2 == 4 then
        Se4()
      end
      if random2 == 5 then
        Se5()
      end
      if random2 == 6 then
        Se6()
      end
    end 

--move pillar
    for index2 = ob.numChildren, 1, -1  do
      pillar = ob[index2]
      animatePillar()
      if pillar.x <= 150 then
        pillar.alpha = pillar.alpha + 0.03
      end
      if pillar.x <= 40 then
        removePillar(index2)
      end
    end

    --moveitem   
    for index3 = item.numChildren, 1 , -1 do
      coin = item[index3]
      animateitem()
      if coin.x <= -10 then
        removeitem()
      end
    end

    Collision1()
    Collision2()
    
    if health <= 0 then
      htext.text = "Health: " .. 0
      mikelle.y = 290 
      mikelle:setSequence("death") 
      mikelle:play()
      r.x = 240
      r.y = 180
      r.label = "TRY AGAIN?" 
      r.onEvent = reset 
      button = widjet.newButton(r)
      button.xScale = 2
      button.yScale = 2
      run = "stop" 
    end
    
    if run == "start" and button ~= nil then
      button.y = -100
    end 
  end 
end 
Runtime:addEventListener("enterFrame", mainLoop) 