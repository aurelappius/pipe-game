-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()


--global variables
local buttonPressed=1 --1=staight, 2=curve, 3=crossing
local pauseActive = false
local tutActive = false
local winValues = {0,0,0} --blue, red, yellow
local connected = {{},{},{}} --blue, red, yellow
local musicTrack2 = audio.loadStream( "music/game.wav")




--level parameters
local level = 1 --from composer
local world = 1
--save progress
local json = require("json")
local filePath = system.pathForFile("progess.json",system.DocumentsDirectory)
local progress = {0,0,0}


--global object handels

local N={}

local board = {}
for i=1,6 do
  board[i]={8,8,8,8,8,8,8,8}
end

local color = {}
for i=1,6 do
  color[i]={0,0,0,0,0,0,0,0}
end

local whereFromA = {}
local whereFromB = {}

local border = {}
for i=1,4 do
  border[i]={0,0,0,0,0,0,0,0}
end

local button = {}
local question
local tutscreen

local tiles = {}
for i=1,6 do
  tiles[i]={}
end

local blocked = {}
for i=1,6 do
  blocked[i]={false,false,false,false,false,false,false,false}
end

local numbers = {}
for i=1,4 do
  numbers[i]={}
end

local inputs ={}
for i=1,6 do
  inputs[i]={}
end

--load graphics and textures


local sheetOptions_A =
{
  frames=
  {
    {x=0  ,y=0,width=104,height=104},--horizontal grey
    {x=104,y=0,width=104,height=104},--vertikal grey
    {x=208,y=0,width=104,height=104},--up right grey
    {x=312,y=0,width=104,height=104},--down right grey
    {x=416,y=0,width=104,height=104},--down left grey
    {x=520,y=0,width=104,height=104}, --up left grey
    {x=0  ,y=104,width=104,height=104},--horizontal blue
    {x=104,y=104,width=104,height=104},--vertikal blue
    {x=208,y=104,width=104,height=104},--up right blue
    {x=312,y=104,width=104,height=104},--down right blue
    {x=416,y=104,width=104,height=104},--down left blue
    {x=520,y=104,width=104,height=104}, --up left blue
    {x=0  ,y=208,width=104,height=104},--horizontal red
    {x=104,y=208,width=104,height=104},--vertikal red
    {x=208,y=208,width=104,height=104},--up right red
    {x=312,y=208,width=104,height=104},--down right red
    {x=416,y=208,width=104,height=104},--down left red
    {x=520,y=208,width=104,height=104}, --up left red
    {x=0  ,y=312,width=104,height=104},--horizontal yellow
    {x=104,y=312,width=104,height=104},--vertikal yellow
    {x=208,y=312,width=104,height=104},--up right yellow
    {x=312,y=312,width=104,height=104},--down right yellow
    {x=416,y=312,width=104,height=104},--down left yellow
    {x=520,y=312,width=104,height=104}, --up left yellow
    {x=1040,y=0,width=104,height=104}, --empty
    {x=1040,y=104,width=104,height=104} --stone
  }
}
local sheetOptions_B=
{
  frames=
  {
    {x=624,y=0,width=104,height=104},-- grey - grey
    {x=728,y=0,width=104,height=104},-- grey - blue
    {x=832,y=0,width=104,height=104},-- grey - red
    {x=936,y=0,width=104,height=104},-- grey - yellow
    {x=624,y=104,width=104,height=104},-- blue - grey
    {x=728,y=104,width=104,height=104},-- blue - blue
    {x=832,y=104,width=104,height=104},-- blue - red
    {x=936,y=104,width=104,height=104},-- blue - yellow
    {x=624,y=208,width=104,height=104},-- red - grey
    {x=728,y=208,width=104,height=104},-- red - blue
    {x=832,y=208,width=104,height=104},-- red - red
    {x=936,y=208,width=104,height=104},-- red - yellow
    {x=624,y=312,width=104,height=104},-- yellow - grey
    {x=728,y=312,width=104,height=104},-- yellow - blue
    {x=832,y=312,width=104,height=104},-- yellow - yellow
    {x=936,y=312,width=104,height=104},-- yellow - red
  }
}
local sheetOptions_C=
{
  frames=
  {
    {x=0 ,y=0,width=208,height=104},-- straight not pressed
    {x=208,y=0,width=208,height=104},-- straight pressed
    {x=0,y=104,width=208,height=104},-- curve not pressed
    {x=208,y=104,width=208,height=104},-- curve pressed
    {x=0 ,y=208,width=208,height=104},-- crossing not pressed
    {x=208,y=208,width=208,height=104},-- crossing pressed
    {x=0,y=644,width=208,height=104},-- dynamite not pressed
    {x=208,y=644,width=208,height=104},-- dynamite pressed
    {x=0 ,y=312,width=208,height=104},-- clear not pressed
    {x=208  ,y=312,width=208,height=104},-- clear pressed
    {x=0  ,y=416,width=76,height=76},-- pause not pressed
    {x=152,y=416,width=76,height=76},-- pause pressed
    {x=76 ,y=416,width=76,height=76},-- reset not pressed
    {x=228,y=416,width=76,height=76},-- reset pressed
    {x=0,y=492,width=416,height=76},-- back to game
    {x=0,y=568,width=416,height=76},-- quit
  }
}
local sheetOptions_D=
{
  frames=
  {
    {x=0 ,y=0,width=104,height=52},-- input red (1)
    {x=104,y=0,width=104,height=52},-- input blue (2)
    {x=208,y=0,width=104,height=52},-- input yellow (3)
  }
}
local sheetOptions_E=
{
  frames=
  {
    {x=461,y=0,width=47,height=75},-- number 0
    {x=0,y=0,width=47,height=75},-- number 1
    {x=47,y=0,width=47,height=75},-- number 2
    {x=99,y=0,width=47,height=75},-- number 3
    {x=147,y=0,width=47,height=75},-- number 4
    {x=203,y=0,width=47,height=75},-- number 5
    {x=253,y=0,width=47,height=75},-- number 6
    {x=306,y=0,width=47,height=75},-- number 7
    {x=357,y=0,width=47,height=75},-- number 8
    {x=408  ,y=0,width=47,height=75},-- number 9

  }
}
local sheetOptions_F=
{
  frames=
  {
    {x=0,y=0,width=104,height=104},
    {x=104,y=0,width=104,height=104},
    {x=208,y=0,width=104,height=104},
    {x=312,y=0,width=104,height=104},
    {x=416,y=0,width=104,height=104},
    {x=518,y=0,width=104,height=104}
  }
}

local sheetOptions_G =
{
  frames=
  {
    {x=0,y=0,width=76,height=76},
    {x=76,y=0,width=76,height=76},
  }
}
local pipes = graphics.newImageSheet("img/sheet.png", sheetOptions_A)
local cross = graphics.newImageSheet("img/sheet.png", sheetOptions_B)
local button_handle = graphics.newImageSheet("img/buttons.png", sheetOptions_C)
local inputs_handle = graphics.newImageSheet("img/inputs.png", sheetOptions_D)
local numbers_handle = graphics.newImageSheet("img/numbers.png", sheetOptions_E)
local quest_handle = graphics.newImageSheet("img/question_button.png", sheetOptions_G)
local explosion_handle = graphics.newImageSheet("img/explosion.png", sheetOptions_F)

local explosion_animation =
{
    name="explode",
    start=1,
    count=6,
    time=400,
    loopCount = 1,
    loopDirection = "forward"
}
--declare functions

local makeTile
local placeTile
local updateButton
local buttonEvent
local updateBoard
local updateBorder
local tileEvent
local changeTileColor
local onBoard
local onBorder
local checkDirection
local updateColor
local borderColorUpdate
local resetColor
local checkConnection
local getColor
local updateNumber
local updateUI
local loaddata
local start
local pause
local resetEvent
local pauseEvent
local backtogameEvent
local quitEventFail
local quitEventSucc
local quitEventNext
local getWinValues
local pipeChecker
local getSource
local endofgame
local nextLevel
local retryLevel
local tutorialEvent

--define functions
loadScores=function(what)
	 local file = io.open(filePath, "r")
	 if file then
     local contents = file:read( "*a")
     io.close( file )
	   progress = json.decode( contents )
	 end
end

saveScores=function()
  local file = io.open(filePath,"w")
  if file then
    file:write(json.encode(progress))
    io.close(file)
  end
end

loaddata = function(lvl)
  local path = system.pathForFile("lvl/"..world.."/"..lvl..".txt",system.ResourceDirectory)
  local file = io.open(path)

  --board
  for i=1,6 do
    for a=1,8 do
      board[i][a]=file:read("*n")
      --if(board[i][a]>=1 and board[i][a]<=7)then  --could be used to block certain tiles from erasement
      --  blocked[i][a]=true
      --end
    end
  end
  --border
  for a=1,8 do
    border[1][a]=file:read("*n")
  end
  for a=1,8 do
    border[2][a]=file:read("*n")
  end
  for a=1,6 do
    border[3][a]=file:read("*n")
  end
  for a=1,6 do
    border[4][a]=file:read("*n")
  end

  for a=1,4 do
    N[a]=file:read("*n")
  end

  io.close( file )
end

makeTile = function(typ, c1, c2) --{typ=0 straight, c1=color, c2=typ},{typ=7 cross, c1=horiz, c2=verti}
  if(typ>=1 and typ<=6) then--normal pipe
    return display.newImageRect(tileGroup,pipes,c1*6+typ,104,104)
  end
  if(typ==7) then--cross
    return display.newImageRect(tileGroup,cross,c1*4+c2+1,104,104)
  end
  if(typ==8) then--empty
    return display.newImageRect(tileGroup,pipes,25,104,104)
  end
  if(typ==9) then--stone
    return display.newImageRect(tileGroup,pipes,26,104,104)
  end
end

placeTile = function(tile,y,x)
  tile.x = 66+(x-1)*104
  tile.y = 46+(y-1)*104
  tile.r = y
  tile.c = x
end

updateButton = function()
  for i=1,5 do --game buttons
    if(composer.getVariable("sfx")==1) then
      audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
    end
    display.remove(button[i])
    if(buttonPressed==i) then
      button[i]= display.newImageRect(uiGroup,button_handle,(2*i),208,104)
    else
      button[i]= display.newImageRect(uiGroup,button_handle,(2*i)-1,208,104)
    end
    button[i].x=1014
    button[i].y=150+(i-1)*104
    button[i].number=i
    button[i]:addEventListener("tap",buttonEvent)
  end
end

buttonEvent = function(event)
  if(pauseActive==false)then
    buttonPressed=event.target.number
    updateButton()
    updateNumber()
  end
end

updateUI = function()
  --ui buttons
  button[7]=display.newImageRect(uiGroup,button_handle,13,76,76) --reset
  button[7].x=1028
  button[7].y=50
  button[8]=display.newImageRect(uiGroup,button_handle,11,76,76) --pause
  button[8].x=1132
  button[8].y=50
end

updateNumber = function()
  for i=1,4 do
    display.remove(numbers[i][1])
    display.remove(numbers[i][2])
    if(N[i]<=9)then
      numbers[i][1]=display.newImageRect(uiGroup,numbers_handle,N[i]+1,47,75)
      numbers[i][1].x=1170
      numbers[i][1].y=164+(i-1)*104
    elseif(N[i]>9)then
      numbers[i][1]=display.newImageRect(uiGroup,numbers_handle,N[i]%10+1,47,75)
      numbers[i][1].x=1170
      numbers[i][1].y=164+(i-1)*104
      numbers[i][2]=display.newImageRect(uiGroup,numbers_handle,(N[i]-N[i]%10)/10+1,47,75)
      numbers[i][2].x=1118
      numbers[i][2].y=164+(i-1)*104
    end
  end
end

updateBoard = function()
  display.remove(board_background)
  local board_background = display.newImageRect(tileGroup, "img/board_background.png", 1280, 720)
  board_background.x =0
  board_background.y =0
  for row=1,6 do
    for col=1,8 do
      display.remove(tiles[row][col])
      if(board[row][col]==7)then
        local c1= (color[row][col]-color[row][col]%10)/10
        local c2= color[row][col]%10
        tiles[row][col]=makeTile(7,(color[row][col]-color[row][col]%10)/10,color[row][col]%10) --not finished!
      elseif(board[row][col]<=6 and board[row][col]>=1) then
        tiles[row][col]=makeTile(board[row][col],color[row][col],0)
      elseif(board[row][col]==8)then
        tiles[row][col]=makeTile(8,0,0)
      elseif(board[row][col]==9)then
        tiles[row][col]=makeTile(9,0,0)
      end
      placeTile(tiles[row][col],row,col)
      tiles[row][col].r=row
      tiles[row][col].c=col
      tiles[row][col]:addEventListener("tap",tileEvent)
    end
  end
end

updateBorder = function()
  --upper
  for i=1,8 do
    if(border[1][i]~=0)then
      inputs[1][i]=display.newImageRect(tileGroup,inputs_handle,border[1][i],104,52)
      inputs[1][i].x=66+(i-1)*104
      inputs[1][i].y=-6
    end
  end
  --lower
  for i=1,8 do
    if(border[2][i]~=0)then
      inputs[2][i]=display.newImageRect(tileGroup,inputs_handle,border[2][i],104,52)
      inputs[2][i]:rotate(180)
      inputs[2][i].x=66+i*104
      inputs[2][i].y=722
    end
  end
  --left
  for i=1,6 do
    if(border[3][i]~=0)then
      inputs[3][i]=display.newImageRect(tileGroup,inputs_handle,border[3][i],104,52)
      inputs[3][i]:rotate(-90)
      inputs[3][i].x=14
      inputs[3][i].y=46+i*104
    end
  end
  --right
  for i=1,6 do
    if(border[4][i]~=0)then
      inputs[4][i]=display.newImageRect(tileGroup,inputs_handle,border[4][i],104,52)
      inputs[4][i]:rotate(90)
      inputs[4][i].x=950
      inputs[4][i].y=46+(i-1)*104
    end
  end
end

getWinValues = function()
  winValues={0,0,0}
  for i=1,8 do
    if(border[1][i]==1)then winValues[1]=winValues[1]+1 end
    if(border[1][i]==2)then winValues[2]=winValues[2]+1 end
    if(border[1][i]==3)then winValues[3]=winValues[3]+1 end
  end
  --lower
  for i=1,8 do
    if(border[2][i]==1)then winValues[1]=winValues[1]+1 end
    if(border[2][i]==2)then winValues[2]=winValues[2]+1 end
    if(border[2][i]==3)then winValues[3]=winValues[3]+1 end
  end
  --left
  for i=1,6 do
    if(border[3][i]==1)then winValues[1]=winValues[1]+1 end
    if(border[3][i]==2)then winValues[2]=winValues[2]+1 end
    if(border[3][i]==3)then winValues[3]=winValues[3]+1 end
  end
  --right
  for i=1,6 do
    if(border[4][i]==1)then winValues[1]=winValues[1]+1 end
    if(border[4][i]==2)then winValues[2]=winValues[2]+1 end
    if(border[4][i]==3)then winValues[3]=winValues[3]+1 end
  end
  --print("WINVALUES:  blue: "..winValues[1].." red: "..winValues[2].." yellow: "..winValues[3])
end

tileEvent = function(event)
  if(pauseActive==false)then
    connected = {{},{},{}}
    local row=event.target.r
    local col=event.target.c
    --sound effects
    if(composer.getVariable("sfx")==1) then
      if(buttonPressed==1 and (N[1]>0 or board[row][col]==1 or board[row][col]==2) and board[row][col]~=9 and blocked[row][col]==false)then
        if(audio.isChannelPlaying(2)) then audio.play(composer.getVariable("sfx_tile"),{channel = 3,loops = 0})
        else audio.play(composer.getVariable("sfx_tile"),{channel = 2,loops = 0}) end
      elseif(buttonPressed==2 and (N[2]>0 or (board[row][col]>=3 and board[row][col]<=6)) and board[row][col]~=9 and blocked[row][col]==false)then
        if(audio.isChannelPlaying(2)) then audio.play(composer.getVariable("sfx_tile"),{channel = 3,loops = 0})
        else audio.play(composer.getVariable("sfx_tile"),{channel = 2,loops = 0}) end
      elseif(buttonPressed==3 and (N[3]>0 or board[row][col]==7) and board[row][col]~=9 and blocked[row][col]==false)then
        if(board[row][col]~=7)then
          if(audio.isChannelPlaying(2)) then audio.play(composer.getVariable("sfx_tile"),{channel = 3,loops = 0})
          else audio.play(composer.getVariable("sfx_tile"),{channel = 2,loops = 0}) end
        end
      elseif(buttonPressed==4 and board[row][col]==9 and N[4]>0 and blocked[row][col]==false)then
        if(audio.isChannelPlaying(2)) then audio.play(composer.getVariable("sfx_expl"),{channel = 3,loops = 0})
        else audio.play(composer.getVariable("sfx_expl"),{channel = 2,loops = 0}) end
      elseif(buttonPressed==5 and board[row][col]~=9 and blocked[row][col]==false)then
        if(audio.isChannelPlaying(2)) then audio.play(composer.getVariable("sfx_swipe"),{channel = 3,loops = 0})
        else audio.play(composer.getVariable("sfx_swipe"),{channel = 2,loops = 0}) end
      else
        if(audio.isChannelPlaying(2)) then audio.play(composer.getVariable("sfx_error"),{channel = 3,loops = 0})
        elseif(audio.isChannelPlaying(3))then audio.play(composer.getVariable("sfx_error"),{channel = 4,loops = 0})
        else audio.play(composer.getVariable("sfx_error"),{channel = 2,loops = 0}) end
      end
    end

    --game logic
    if(buttonPressed==1 and board[row][col]~=9 and blocked[row][col]==false) then

      if(not(board[row][col]==1 or board[row][col]==2) and N[1]>0)then --create new tile
        if(board[row][col]>=3 and board[row][col]<=6)then N[2]=N[2]+1 end
        if(board[row][col]==7)then N[3]=N[3]+1 end
        N[1]=N[1]-1
        board[row][col]=2
      end

      if(board[row][col]==1) then --change orientation
        board[row][col]=2
      elseif(board[row][col]==2)then
        board[row][col]=1
      end

    elseif(buttonPressed==2 and board[row][col]~=9 and blocked[row][col]==false) then

      if((board[row][col]<=2 or board[row][col]>=7) and N[2]>0)then --create new tile
        if(board[row][col]==1 or board[row][col]==2)then N[1]=N[1]+1 end
        if(board[row][col]==7)then N[3]=N[3]+1 end
        N[2]=N[2]-1
        board[row][col]=5 --because of icon on button
      end

      if(board[row][col]>=3 and board[row][col]<=5 ) then--change orientation
        board[row][col]=board[row][col]+1
      elseif(board[row][col]==6) then
        board[row][col]=3
      end

    elseif(buttonPressed==3 and board[row][col]~=7 and N[3]>0  and board[row][col]~=9 and blocked[row][col]==false) then --create new tile
      if(board[row][col]==1 or board[row][col]==2)then N[1]=N[1]+1 end
      if(board[row][col]>=3 and board[row][col]<=6)then N[2]=N[2]+1 end
      board[row][col]=7
      N[3]=N[3]-1
    elseif(buttonPressed==4 and board[row][col]==9 and N[4]>0 and blocked[row][col]==false) then
      --animation
      local explosion=display.newSprite(explosion_handle,explosion_animation)
      explosion.x=66+(col-1)*104
      explosion.y=46+(row-1)*104
      explosion:play();
      local clear = function() display.remove(explosion)end
      timer.performWithDelay(500, clear )
      board[row][col]=8
      N[4]=N[4]-1
    elseif(buttonPressed==5 and board[row][col]~=9 and blocked[row][col]==false) then --erase
      if(board[row][col]==1 or board[row][col]==2) then N[1]=N[1]+1 end
      if(board[row][col]>=3 and board[row][col]<=6) then N[2]=N[2]+1 end
      if(board[row][col]==7) then N[3]=N[3]+1 end
      board[row][col]=8

    end
    resetColor()
    borderColorUpdate()
    updateBoard()
    updateNumber()
    checkWin()
    --print("CONECTIONS: blue: "..#connected[1].." red: "..#connected[2].." yellow: "..#connected[3])
  end
end

onBoard = function(row, col)
  if((row>=1 and row<=6) and (col>=1 and col<=8)) then
    return true
  else
    return false
  end
end

onBorder = function(row, col)
  if((row==0 or row==7) or (col==0 or col==9)) then
    return true
  else
    return false
  end
end

getColor=function(row,col,dir) --dir = direction coming from
  if(board[row][col]>=1 and board[row][col]<=6)then
    return color[row][col]
  elseif(board[row][col]==7)then
    if(dir==1 or dir==3)then
      return color[row][col]%10
    elseif(dir==2 or dir==4)then
      return (color[row][col]-color[row][col]%10)/10
    end
  end
  return 0
end

checkConnection=function(row,col,dir)
  if(dir==1) then --up
    if(onBoard(row-1,col))then
      if(board[row][col]==1 or board[row][col]==4 or board[row][col]==5 or board[row][col]==8) then return false end
      if(board[row-1][col]==1 or board[row-1][col]==3 or board[row-1][col]==6 or board[row][col]==8) then return false end
      return true
    elseif(onBorder(row-1,col))then
      if(board[row][col]==1 or board[row][col]==4 or board[row][col]==5 or board[row][col]==8) then return false end
      return true
    end
  elseif(dir==2) then --left
    if(onBoard(row,col-1))then
      if(board[row][col]==2 or board[row][col]==3 or board[row][col]==4 or board[row][col]==8) then return false end
      if(board[row][col-1]==2 or board[row][col-1]==5 or board[row][col-1]==6 or board[row][col]==8) then return false end
      return true
    elseif(onBorder(row,col-1))then
      if(board[row][col]==2 or board[row][col]==3 or board[row][col]==4 or board[row][col]==8) then return false end
      return true
    end
  elseif(dir==3) then --down
    if(onBoard(row+1,col))then
      if(board[row][col]==1 or board[row][col]==3 or board[row][col]==6 or board[row][col]==8) then return false end
      if(board[row+1][col]==1 or board[row+1][col]==4 or board[row+1][col]==5 or board[row][col]==8) then return false end
      return true
    elseif(onBorder(row+1,col))then
      if(board[row][col]==1 or board[row][col]==3 or board[row][col]==6 or board[row][col]==8) then return false end
      return true
    end
  elseif(dir==4) then --right
    if(onBoard(row,col+1))then
      if(board[row][col]==2 or board[row][col]==5 or board[row][col]==6 or board[row][col]==8) then return false end
      if(board[row][col+1]==2 or board[row][col+1]==3 or board[row][col+1]==4 or board[row][col]==8) then return false end
      return true
    elseif(onBorder(row,col+1))then
      if(board[row][col]==2 or board[row][col]==5 or board[row][col]==6 or board[row][col]==8) then return false end
      return true
    end
  end
end

checkDirection = function(row,col,dir) --1=up 2=left 3=down 4=right --returns color of field
  if(dir==1 and checkConnection(row,col,1)) then --up
    if(onBoard(row-1,col))then
      return getColor(row-1,col,1)
    elseif(onBorder(row-1,col))then
      return border[1][col] --check upper border
    end
  elseif(dir==2 and checkConnection(row,col,2)) then --left
    if(onBoard(row,col-1))then
      return getColor(row,col-1,2)
    elseif(onBorder(row,col-1))then
      return border[3][row] --check left border
    end
  elseif(dir==3 and checkConnection(row,col,3)) then --down
    if(onBoard(row+1,col))then
      return getColor(row+1,col,3)
    elseif(onBorder(row+1,col))then
      return border[2][col] --check lower border
    end
  elseif(dir==4 and checkConnection(row,col,4)) then --right
    if(onBoard(row,col+1))then
      return getColor(row,col+1,4)
    elseif(onBorder(row,col+1))then
      return border[4][row] --check right border
    end
  end
  return 0
end

pipeChecker=function(B1,B2)
  local color=border[B1][B2]
  local element=B1*10+B2
  if(table.indexOf(connected[color],element)==nil)then
    table.insert(connected[color],element)
  end
end

updateColor = function(row, col,B1,B2) --location on border where originated
  if(onBoard(row,col)==true)then
    local type=board[row][col]
    --horizontal
    if(type==1) then
      local c2=checkDirection(row,col,2)
      local c4=checkDirection(row,col,4)

      if(c2~=0)then
        color[row][col]=c2
        whereFromA[row][col]=B1*10+B2
        if(c4==0 and checkConnection(row,col,4)) then
          updateColor(row,col+1,B1,B2)
        end
      elseif(c4~=0)then
        color[row][col]=c4
        whereFromA[row][col]=B1*10+B2
        if(c2==0 and checkConnection(row,col,2))then
          updateColor(row,col-1,B1,B2)
        end
      end

      --check if ending
      if(col==1 and c2~=0)then --left
        if(not(B1==3 and B2==row)and (border[B1][B2]==border[3][row]))then
          pipeChecker(B1,B2)
          return
        end
      end
      if(col==8 and c4~=0)then --right
        if(not(B1==4 and B2==row)and (border[B1][B2]==border[4][row]))then
          pipeChecker(B1,B2)
          return
        end
      end

    end
    --vertical
    if(type==2) then
      local c1=checkDirection(row,col,1)
      local c3=checkDirection(row,col,3)
      if(c1~=0)then
        color[row][col]=c1
        whereFromA[row][col]=B1*10+B2
        if(c3==0 and checkConnection(row,col,3))then
          updateColor(row+1,col,B1,B2)
        end
      elseif(c3~=0)then
        color[row][col]=c3
        whereFromA[row][col]=B1*10+B2
        if(c1==0 and checkConnection(row,col,1))then
          updateColor(row-1,col,B1,B2)
        end
      end

      --check if ending
      if(row==1 and c1~=0)then --up
        if(not(B1==1 and B2==col)and (border[B1][B2]==border[1][col]))then
          pipeChecker(B1,B2)
          return
        end
      end
      if(row==6 and c3~=0)then --down
        if(not(B1==2 and B2==col)and (border[B1][B2]==border[2][col]))then
          pipeChecker(B1,B2)
          return
        end
      end

    end
    --up-right
    if(type==3) then
      local c1=checkDirection(row,col,1)
      local c4=checkDirection(row,col,4)
      if(c1~=0)then
        color[row][col]=c1
        whereFromA[row][col]=B1*10+B2
        if(c4==0 and checkConnection(row,col,4))then
          updateColor(row,col+1,B1,B2)
        end
      elseif(c4~=0)then
        color[row][col]=c4
        whereFromA[row][col]=B1*10+B2
        if(c1==0 and checkConnection(row,col,1))then
          updateColor(row-1,col,B1,B2)
        end
      end

      --check if ending
      if(row==1 and c1~=0)then --up
        if(not(B1==1 and B2==col)and (border[B1][B2]==border[1][col]))then
          pipeChecker(B1,B2)
          return
        end
      end
      if(col==8 and c4~=0)then --right
        if(not(B1==4 and B2==row) and (border[B1][B2]==border[4][row]))then
          pipeChecker(B1,B2)
          return
        end
      end

    end
    --down-right
    if(type==4) then
      local c3=checkDirection(row,col,3)
      local c4=checkDirection(row,col,4)
      if(c3~=0)then
        color[row][col]=c3
        whereFromA[row][col]=B1*10+B2
        if(c4==0 and checkConnection(row,col,4))then
          updateColor(row,col+1,B1,B2)
        end
      elseif(c4~=0)then
        color[row][col]=c4
        whereFromA[row][col]=B1*10+B2
        if(c3==0 and checkConnection(row,col,3))then
          updateColor(row+1,col,B1,B2)
        end
      end
      --check if ending
      if(row==6 and c3~=0)then --down
        if(not(B1==2 and B2==col)and (border[B1][B2]==border[2][col]))then
          pipeChecker(B1,B2)
          return
        end
      end
      if(col==8 and c4~=0)then --right
        if(not(B1==4 and B2==row)and (border[B1][B2]==border[4][row]))then
          pipeChecker(B1,B2)
          return
        end
      end

    end
    --down-left
    if(type==5) then
      local c3=checkDirection(row,col,3)
      local c2=checkDirection(row,col,2)
      if(c3~=0)then
        color[row][col]=c3
        whereFromA[row][col]=B1*10+B2
        if(c2==0 and checkConnection(row,col,2))then
          updateColor(row,col-1,B1,B2)
        end
      elseif(c2~=0)then
        color[row][col]=c2
        whereFromA[row][col]=B1*10+B2
        if(c3==0 and checkConnection(row,col,3))then
          updateColor(row+1,col,B1,B2)
        end
      end
      --check if ending
      if(row==6 and c3~=0)then --down
        if(not(B1==2 and B2==col)and (border[B1][B2]==border[2][col]))then
          pipeChecker(B1,B2)
          return
        end
      end
      if(col==1 and c2~=0)then --left
        if(not(B1==3 and B2==row)and (border[B1][B2]==border[3][row]))then
          pipeChecker(B1,B2)
          return
        end
      end

    end
    --up-left
    if(type==6) then
      local c1=checkDirection(row,col,1)
      local c2=checkDirection(row,col,2)
      if(c1~=0)then
        color[row][col]=c1
        whereFromA[row][col]=B1*10+B2
        if(c2==0 and checkConnection(row,col,2))then
          updateColor(row,col-1,B1,B2)
        end
      elseif(c2~=0)then
        color[row][col]=c2
        whereFromA[row][col]=B1*10+B2
        if(c1==0 and checkConnection(row,col,1))then
          updateColor(row-1,col,B1,B2)
        end
      end
      --check if ending
      if(row==1 and c1~=0)then --up
        if(not(B1==1 and B2==col) and (border[B1][B2]==border[1][col]))then
          pipeChecker(B1,B2)
          return
        end
      end
      if(col==1 and c2~=0)then --left
        if(not(B1==3 and B2==row) and (border[B1][B2]==border[3][row]))then
          pipeChecker(B1,B2)
          return
        end
      end

    end
    --crossing
    if(type==7)then
      --colors
      local c1=checkDirection(row,col,1)
      local c2=checkDirection(row,col,2)
      local c3=checkDirection(row,col,3)
      local c4=checkDirection(row,col,4)
      --sources
      local c1B1,c1B2 = getSource(row,col,1)
      local c2B1,c2B2 = getSource(row,col,2)
      local c3B1,c3B2 = getSource(row,col,3)
      local c4B1,c4B2 = getSource(row,col,4)

      if(c1~=0)then
        if(c2==0 and c4==0)then --side check
          color[row][col]=c1
          whereFromA[row][col]=c1B1*10+c1B2
          elseif(c2~=0)then
            color[row][col]=c2*10+c1
            whereFromB[row][col]=c2B1*10+c2B2
            whereFromA[row][col]=c1B1*10+c1B2
            if(c4==0 and checkConnection(row,col,4))then
              updateColor(row,col+1,c2B1,c2B2)
            end
          elseif(c4~=0)then
            color[row][col]=c4*10+c1
            whereFromB[row][col]=c4B1*10+c4B2
            whereFromA[row][col]=c1B1*10+c1B2
            if(c2==0 and checkConnection(row,col,2))then
              updateColor(row,col-1,c4B1,c4B2)
            end
        end
        if(c3==0 and checkConnection(row,col,3))then --main check
          updateColor(row+1,col,c1B1,c1B2)
        end
      elseif(c2~=0)then
        if(c1==0 and c3==0)then --side check
          color[row][col]=10*c2
          whereFromB[row][col]=c2B1*10+c2B2
          elseif(c1~=0)then
            color[row][col]=c2*10+c1
            whereFromB[row][col]=c2B1*10+c2B2
            whereFromA[row][col]=c1B1*10+c1B2
            if(c3==0 and checkConnection(row,col,3))then
              updateColor(row+1,col,c1B1,c1B2)
            end
          elseif(c3~=0)then
            color[row][col]=c2*10+c3
            whereFromB[row][col]=c2B1*10+c2B2
            whereFromA[row][col]=c3B1*10+c3B2
            if(c1==0 and checkConnection(row,col,1))then
              updateColor(row-1,col,c3B1,c3B2)
            end
        end
        if(c4==0 and checkConnection(row,col,4))then --main check
          updateColor(row,col+1,c2B1,c2B2)
        end
      elseif(c3~=0)then
        if(c2==0 and c4==0)then --side check
          color[row][col]=c3
          whereFromA[row][col]=c3B1*10+c3B2
          elseif(c4~=0)then
            color[row][col]=c4*10+c3
            whereFromB[row][col]=c4B1*10+c4B2
            whereFromA[row][col]=c3B1*10+c3B2
            if(c2==0 and checkConnection(row,col,2))then
              updateColor(row,col-1,c4B1,c4B2)
            end
          elseif(c2~=0)then
            color[row][col]=c2*10+c3
            whereFromB[row][col]=c2B1*10+c2B2
            whereFromA[row][col]=c3B1*10+c3B2
            if(c4==0 and checkConnection(row,col,4))then
              updateColor(row,col+1,c2B1,c2B2)
            end
        end
        if(c1==0 and checkConnection(row,col,1))then --main check
          updateColor(row-1,col,c3B1,c3B2)
        end
      elseif(c4~=0)then
        if(c1==0 and c3==0)then--side check
          color[row][col]=10*c4
          whereFromB[row][col]=c4B1*10+c4B2
          elseif(c1~=0)then
            color[row][col]=c4*10+c1
            whereFromB[row][col]=c4B1*10+c4B2
            whereFromA[row][col]=c1B1*10+c1B2
            if(c3==0 and checkConnection(row,col,3))then
              updateColor(row+1,col,c1B1,c1B2)
            end
          elseif(c3~=0)then
            color[row][col]=c4*10+c3
            whereFromB[row][col]=c4B1*10+c4B2
            whereFromA[row][col]=c3B1*10+c3B2
            if(c1==0 and checkConnection(row,col,1))then
              updateColor(row-1,col,c3B1,c3B2)
            end
        end
        if(c2==0 and checkConnection(row,col,2))then --main check
          updateColor(row,col-1,c4B1,c4B2)
        end
      end

      --check if ending
      if(row==1 and c1~=0 and c3~=0)then --up
        if(not(c3B1==1 and c3B2==col) and (border[c3B1][c3B2]==border[1][col]))then
          pipeChecker(c3B1,c3B2)
          return
        end
      end
      if(row==6 and c3~=0 and c1~=0)then --down
        if(not(c1B1==2 and c1B2==col) and (border[c1B1][c1B2]==border[2][col]))then
          pipeChecker(c1B1,c1B2)
          return
        end
      end
      if(col==1 and c2~=0 and c4~=0)then --left
        if(not(c4B1==3 and c4B2==row) and (border[c4B1][c4B2]==border[3][row]))then
          pipeChecker(c4B1,c4B2)
          return
        end
      end
      if(col==8 and c4~=0 and c2~=0)then --right
        if(not(c2B1==4 and c2B2==row) and (border[c2B1][c2B2]==border[4][row]))then
          pipeChecker(c2B1,c2B2)
          return
        end
      end
    end
  end
end

getSource = function(row,col,dir)
  local B1,B2=0,0
  if(dir==1)then --up
    if(onBoard(row-1,col))then
      B1=(whereFromA[row-1][col]-whereFromA[row-1][col]%10)/10
      B2=whereFromA[row-1][col]%10
    elseif(onBorder(row-1,col))then
      B1=1
      B2=col
    end
    return B1,B2
  elseif(dir==2)then --left
    if(onBoard(row,col-1))then
      if(board[row][col-1]==7)then
        B1=(whereFromB[row][col-1]-whereFromB[row][col-1]%10)/10
        B2=whereFromB[row][col-1]%10
      else
        B1=(whereFromA[row][col-1]-whereFromA[row][col-1]%10)/10
        B2=whereFromA[row][col-1]%10
      end
    elseif(onBorder(row,col-1))then
      B1=3
      B2=row
    end
    return B1,B2
  elseif(dir==3)then --down
    if(onBoard(row+1,col))then
      B1=(whereFromA[row+1][col]-whereFromA[row+1][col]%10)/10
      B2=whereFromA[row+1][col]%10
    elseif(onBorder(row+1,col))then
      B1=2
      B2=col
    end
    return B1,B2
  elseif(dir==4)then --right
    if(onBoard(row,col+1))then
      if(board[row][col+1]==7)then
        B1=(whereFromB[row][col+1]-whereFromB[row][col+1]%10)/10
        B2=whereFromB[row][col+1]%10
      else
        B1=(whereFromA[row][col+1]-whereFromA[row][col+1]%10)/10
        B2=whereFromA[row][col+1]%10
      end
    elseif(onBorder(row,col+1))then
      B1=4
      B2=row
    end
    return B1,B2
  end
end

borderColorUpdate = function()
  --upper
  for i=1,8 do
    if(border[1][i]~=0 and checkConnection(1,i,1))then
      updateColor(1,i,1,i)
    end
  end
  --lower
  for i=1,8 do
    if(border[2][i]~=0 and checkConnection(6,i,3))then
      updateColor(6,i,2,i)
    end
  end
  --left
  for i=1,6 do
    if(border[3][i]~=0 and checkConnection(i,1,2))then
      updateColor(i,1,3,i)
    end
  end
  --right
  for i=1,6 do
    if(border[4][i]~=0 and checkConnection(i,8,4))then
      updateColor(i,8,4,i)
    end
  end
end

resetColor = function()
  color[1]={0,0,0,0,0,0,0,0}
  color[2]={0,0,0,0,0,0,0,0}
  color[3]={0,0,0,0,0,0,0,0}
  color[4]={0,0,0,0,0,0,0,0}
  color[5]={0,0,0,0,0,0,0,0}
  color[6]={0,0,0,0,0,0,0,0}

  whereFromA[1]={0,0,0,0,0,0,0,0}
  whereFromA[2]={0,0,0,0,0,0,0,0}
  whereFromA[3]={0,0,0,0,0,0,0,0}
  whereFromA[4]={0,0,0,0,0,0,0,0}
  whereFromA[5]={0,0,0,0,0,0,0,0}
  whereFromA[6]={0,0,0,0,0,0,0,0}
  whereFromB[1]={0,0,0,0,0,0,0,0}
  whereFromB[2]={0,0,0,0,0,0,0,0}
  whereFromB[3]={0,0,0,0,0,0,0,0}
  whereFromB[4]={0,0,0,0,0,0,0,0}
  whereFromB[5]={0,0,0,0,0,0,0,0}
  whereFromB[6]={0,0,0,0,0,0,0,0}
end

checkWin = function()
  local win=true
  for i=1,3 do
    if(#connected[i]*2~=winValues[i])then
      win=false
    end
  end
  if(win==true)then
    print("GAME FINISHED")
    endofgame()
  end
end

start = function()
  loaddata(level)
  resetColor()
  updateButton()
  updateBorder()
  borderColorUpdate()
  updateBoard()
  updateNumber()
  updateUI()
  getWinValues()
end

resetEvent=function(event)
  if(pauseActive==false)then
    if(composer.getVariable("sfx")==1) then
      audio.play(composer.getVariable("sfx_swipe"),{channel = 2,loops = 0})
    end
    if(event.phase == "began")then
      button[7]=display.newImageRect(uiGroup,button_handle,14,76,76)
      button[7].x=1028
      button[7].y=50
    elseif(event.phase == "ended" or event.phase == "cancelled" or (event.x-event.xStart)>15 or (event.y-event.yStart)>15) then
      start()
    end
  end
end

pauseEvent=function(event)
  if(pauseActive==false)then
    if(event.phase == "began")then
      button[8]=display.newImageRect(uiGroup,button_handle,12,76,76)
      button[8].x=1132
      button[8].y=50
    elseif(event.phase == "ended" or event.phase == "cancelled" or (event.x-event.xStart)>15 or (event.y-event.yStart)>15) then
      if(composer.getVariable("sfx")==1) then
        audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
      end
      pause()
    end
  end
end

tutorialEvent=function(event)
  if(pauseActive==false)then
    if(tutActive==false)then
      if(event.phase == "ended" or event.phase == "cancelled" or (event.x-event.xStart)>15 or (event.y-event.yStart)>15) then
        if(composer.getVariable("sfx")==1) then
          audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
        end
        question=display.newImageRect(uiGroup,quest_handle,2,76,76)
        question.x=925
        question.y=50
        tutscreen=display.newImageRect(tutgroup, "img/tut"..level..".png", 1280, 720)
        if(level==1)then
          blocked={{true,true,true,true,true,true,true,false},
                   {true,true,true,true,true,true,true,false},
                   {false,false,false,false,false,false,false,false},
                   {false,false,false,false,false,false,false,false},
                   {false,false,false,false,false,false,false,false},
                   {false,true,true,true,true,true,true,true}}
        elseif(level==2)then
          blocked={{true,true,true,true,true,true,true,true},
                   {false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,false,false,false},
                   {false,false,false,false,false,false,false,false}}
        elseif(level==3)then
          blocked={{false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,false,false,false},
                   {false,false,false,false,false,false,false,false},
                   {false,false,false,false,false,false,false,false}}
        elseif(level==4)then
          blocked={{false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,true,true,true},
                   {false,false,false,false,false,false,false,false},
                   {false,false,false,false,false,false,false,false},
                   {false,false,false,false,false,false,false,false}}
        end
        tutActive=true
      end
    elseif(tutActive==true)then
      if(event.phase == "ended" or event.phase == "cancelled" or (event.x-event.xStart)>15 or (event.y-event.yStart)>15) then
        question=display.newImageRect(uiGroup,quest_handle,1,76,76)
        question.x=925
        question.y=50
        display.remove(tutscreen)
        blocked={{false,false,false,false,false,false,false,false},
                 {false,false,false,false,false,false,false,false},
                 {false,false,false,false,false,false,false,false},
                 {false,false,false,false,false,false,false,false},
                 {false,false,false,false,false,false,false,false},
                 {false,false,false,false,false,false,false,false}}
        tutActive=false
        if(composer.getVariable("sfx")==1) then
          audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
        end
        print("tutorial endet")
      end
    end
  end
end

quitEventFail = function(event)
  display.remove(pauseGroup)
  if(composer.getVariable("sfx")==1) then
    audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  end
  local a=composer.getVariable("ads")
  if(a==0)then
    composer.gotoScene("ad",{params={world=world, level=level, success=0}})
  elseif(a==1)then
    composer.gotoScene("level",{params={world=world, level=level, success=0}})
  end
end

quitEventSucc = function(event)
  display.remove(pauseGroup)
  if(composer.getVariable("sfx")==1) then
    audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  end
  local a=composer.getVariable("ads")
  if(a==0)then
    composer.gotoScene("ad",{params={world=world, level=level, success=1}})
  elseif(a==1)then
    composer.gotoScene("level",{params={world=world, level=level, success=1}})
  end
end

quitEventNext = function(event)
  if(event.phase == "ended")then
    if(composer.getVariable("sfx")==1) then
      audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
    end
    display.remove(pauseGroup)
    local a=composer.getVariable("ads")
    if(a==0)then
      composer.gotoScene("ad",{params={world=world, level=level, success=2}})
    elseif(a==1)then
      composer.gotoScene("level",{params={world=world, level=level, success=2}})
    end
  end
end


backtogameEvent=function(event)
  if(event.phase == "ended")then
    if(composer.getVariable("sfx")==1) then
      audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
    end
    button[8]=display.newImageRect(uiGroup,button_handle,11,76,76)
    button[8].x=1132
    button[8].y=50
    display.remove(pauseGroup)
    pauseGroup=display.newGroup()
    local deactivate=function() pauseActive=false end
    timer.performWithDelay(500,deactivate)
  end
end

pause=function()
  pauseActive=true
  --remove tutorial screeen if necessary
  if(tutActive==true)then
    question=display.newImageRect(uiGroup,quest_handle,1,76,76)
    question.x=925
    question.y=50
    display.remove(tutscreen)
    tutActive=false
    blocked={{false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false}}
  end
  local pauseScreen = display.newImageRect(pauseGroup, "img/pauseScreen.png", 1680, 1120)
  pauseScreen.x = -200
  pauseScreen.y = -200
  button[9]=display.newImageRect(pauseGroup,button_handle,15,416,76)
  button[9].x=display.contentCenterX-208
  button[9].y=320
  button[9]:addEventListener("touch",backtogameEvent)
  button[10]=display.newImageRect(pauseGroup,button_handle,16,416,76)
  button[10].x=display.contentCenterX-208
  button[10].y=420
  button[10]:addEventListener("tap",quitEventFail)
end

endofgame=function()
  pauseActive=true
  --remove tutorial screeen if necessary
  if(tutActive==true)then
    question=display.newImageRect(uiGroup,quest_handle,1,76,76)
    question.x=925
    question.y=50
    display.remove(tutscreen)
    tutActive=false
    blocked={{false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false},
             {false,false,false,false,false,false,false,false}}
  end
  local successScreen = display.newImageRect(pauseGroup, "img/successScreen.png", 1680, 1120)
  successScreen.x = -200
  successScreen.y = -200
  local sheetOptions_Z=
  {
    frames=
    {
      {x=0,y=0,width=416,height=76},-- next level
      {x=0,y=76,width=416,height=76},-- retry level
      {x=0,y=152,width=416,height=76},-- quit
    }
  }
  local endbuttons = graphics.newImageSheet("img/success_buttons.png", sheetOptions_Z)

  if(level~=45) then
    button[11]=display.newImageRect(pauseGroup,endbuttons,1,416,76)
    button[11].x=display.contentCenterX-208
    button[11].y=290
    button[11]:addEventListener("touch",quitEventNext)

    button[12]=display.newImageRect(pauseGroup,endbuttons,2,416,76)
    button[12].x=display.contentCenterX-208
    button[12].y=390
    button[12]:addEventListener("tap",retryLevel)

    button[13]=display.newImageRect(pauseGroup,endbuttons,3,416,76)
    button[13].x=display.contentCenterX-208
    button[13].y=490
    button[13]:addEventListener("tap",quitEventSucc)
  else
    button[12]=display.newImageRect(pauseGroup,endbuttons,2,416,76)
    button[12].x=display.contentCenterX-208
    button[12].y=390
    button[12]:addEventListener("tap",retryLevel)

    button[13]=display.newImageRect(pauseGroup,endbuttons,3,416,76)
    button[13].x=display.contentCenterX-208
    button[13].y=490
    button[13]:addEventListener("tap",quitEventSucc)
  end
end

retryLevel = function(event)
  tutActive=false
  blocked={{false,false,false,false,false,false,false,false},
           {false,false,false,false,false,false,false,false},
           {false,false,false,false,false,false,false,false},
           {false,false,false,false,false,false,false,false},
           {false,false,false,false,false,false,false,false},
           {false,false,false,false,false,false,false,false}}
  if(composer.getVariable("sfx")==1) then
    audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  end
  display.remove(pauseGroup)
  pauseGroup=display.newGroup()
  local deactivate=function() pauseActive=false end
  timer.performWithDelay(500,deactivate)
  start()
end

--create scene
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  backGroup = display.newGroup()
  sceneGroup:insert( backGroup )
  tileGroup = display.newGroup()
  sceneGroup:insert( tileGroup )
  uiGroup = display.newGroup()
  sceneGroup:insert( uiGroup )
  pauseGroup = display.newGroup()
  sceneGroup:insert( pauseGroup )
  tutgroup=display.newGroup()
  sceneGroup:insert(tutgroup)
  display.setDefault("anchorX",0)
  display.setDefault("anchorY",0)

  local grey_back = display.newImageRect( backGroup, "img/grey_back.png", 1680, 1120 )
  grey_back.x=-200
  grey_back.y=-200

  local background = display.newImageRect(backGroup, "img/background.png", 1280, 720)
  background.x =0
  background.y =0

  button[7]=display.newImageRect(uiGroup,button_handle,13,76,76) --reset
  button[7].x=1028
  button[7].y=50
  button[7]:addEventListener("touch",resetEvent)
  button[8]=display.newImageRect(uiGroup,button_handle,11,76,76) --pause
  button[8].x=1132
  button[8].y=50
  button[8]:addEventListener("touch",pauseEvent)
  if(level>=1 and level<=4)then
    question=display.newImageRect(uiGroup,quest_handle,1,76,76)
    question.x=925
    question.y=50
    question:addEventListener("touch",tutorialEvent)
  end

  print("create levle: "..level )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

    for i=1,6 do
      board[i]={8,8,8,8,8,8,8,8}
    end
    for i=1,6 do
      color[i]={0,0,0,0,0,0,0,0}
    end
    for i=1,4 do
      border[i]={0,0,0,0,0,0,0,0}
    end

    musicOn = composer.getVariable("music")

    level = composer.getVariable( "level" )
    world = composer.getVariable( "world" )

    if(level>=5)then
      print("lesgo")
      display.remove(question)
      question:removeEventListener("touch",tutorialEvent)
    end

    loadScores("progress")
    print("show levle: "..level )
    start()
		-- Code here runs when the scene is still off screen (but is about to come on screen)
    if(composer.getVariable("music")==1)then
      audio.stop(1)
      audio.play( musicTrack2, { channel=1, loops=-1 } )
		end

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
    audio.stop(1)
    composer.removeScene("game")
	elseif ( phase == "did" ) then

		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
