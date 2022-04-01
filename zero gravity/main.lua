--Code--

smokes = display.newGroup()

bg = display.newImage("fantasy.jpg",160,320)
bg.xScale = 3
bg.yScale = 3
bg:toBack()

yes = display.newImage("yes.png",1280,800) 
yes.xScale = 0.2
yes.yScale = 0.2
yes.xSpeed = 0
yes.ySpeed = 0
yes.rotation = 0

music = audio.loadSound("lol.mp3")
musicSettings = {}
musicSettings.loops = -1
musicChannel = audio.play(music, musicSettings)


function Smoke(index)
  smoke = display.newImage("smoke.png",yes.x,yes.y)
  smoke.alpha = 1
  smoke.xScale = 0.9
  smoke.yScale = 0.9
  smoke.xSpeed = 0
  smoke.ySpeed = 0 
  smoke.blendMode = "screen"
  smokes:insert(smoke)
end 

function animateSmoke() 
  smoke.xScale = smoke.xScale + 0.4
  smoke.yScale = smoke.yScale + 0.4
  smoke.alpha = smoke.alpha - 0.25
  smoke.rotation = smoke.rotation + 1.5 
end 

function destroySmoke(index)
  if smoke.alpha <= 0 then
    smoke:removeSelf()
    smoke = nil
  end 
end 

function keyPressed(event)
  print(event.keyName)
  keyboard = event.keyName

  if keyboard == "up" then
    yes.ySpeed = yes.ySpeed + 1
    yes.rotation = yes.rotation + 25
    Smoke(index)
  end

  if keyboard == "down" then
    yes.ySpeed = yes.ySpeed - 1
    yes.rotation = yes.rotation + 25
    Smoke(index)
  end

  if keyboard == "left" then
    yes.xSpeed = yes.xSpeed - 1 
    yes.rotation = yes.rotation + 25
    Smoke(index)
  end

  if keyboard == "right" then
    yes.xSpeed = yes.xSpeed + 1
    yes.rotation = yes.rotation + 25
    Smoke(index)
  end
end

  
function mainLoop()
  yes.x = yes.x + yes.xSpeed
  yes.y = yes.y - yes.ySpeed
  
  for index = smokes.numChildren, 1, -1 do
    smoke = smokes[index]
    animateSmoke()
    if smoke.alpha <= 0 then
      destroySmoke(index)
    end 
  end 
end

Runtime:addEventListener("key", keyPressed)
Runtime:addEventListener("enterFrame", mainLoop) 
