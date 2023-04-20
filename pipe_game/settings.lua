
local composer = require( "composer" )

local scene = composer.newScene()

local json = require("json")
local filePath = system.pathForFile("pref.json",system.DocumentsDirectory)
local pref = {1,1} --setting 1,2
local musicTrack=composer.getVariable("musicTrack")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local color
local layout
local title
local tiles
local inputs
local input
local back
local buttons
local pipes
local background
local update
local txt
local onoff
local sw_txt = {}

local function loadScores()
	local file = io.open(filePath, "r")
	if file then
		local contents = file:read( "*a")
		io.close( file )
		pref = json.decode( contents )
	end
end

local function saveScores()
	local file = io.open(filePath,"w")
	if file then
		file:write(json.encode(pref))
		io.close(file)
	end
end

local function changeSettings(event)
	if(composer.getVariable("sfx")==1) then
		audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
	end
	if(event.target.r==2)then
		if(pref[1]==1) then
			audio.stop(1)
			pref[1]=0
		else
			audio.play( musicTrack, { channel=1, loops=-1 } )
			pref[1]=1
		end
		composer.setVariable("music",pref[1])
	end
	if(event.target.r==4)then
		if(pref[2]==1) then pref[2]=0
		else pref[2]=1	end
		composer.setVariable("sfx",pref[2])
	end
	saveScores()
	update(event.target.sc)
end


local function backtoMenu(event)
	if(composer.getVariable("sfx")==1) then
		audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
	end
	composer.gotoScene("menu")
end



update=function(sceneGroup)

	background = display.newImageRect( sceneGroup, "img/level_screen.png", 1280, 720 )
	background.x = 0
	background.y = 0

	color = {
		{0,0,0,0,0,0,0,0,0,0, 0},
		{3,3,3,3,3,3,3,3,3*pref[1], 3*pref[1], 3*pref[1]},
		{0,0,0,0,0,0,0,0,0,0, 0},
		{2,2,2,2,2,2,2,2,2*pref[2], 2*pref[2], 2*pref[2]},
		{0,0,0,0,0,0,0,0,0,0, 0},
	}

	for i=1,2 do
		if(pref[i]==1)then
			layout[2*i] = {1,1,1,1,1,1,1,1,1,1,1}
		else
			layout[2*i] = {1,1,1,1,1,1,1,1,2,1,1}
		end
	end



	title = display.newImageRect(sceneGroup,buttons,1,589,68)
	title.x=display.contentCenterX-295
	title.y=65

	tiles={{},{},{},{},{}}
	for r=1,5 do
		for c=1,11 do
			if(layout[r][c]~=0)then
				tiles[r][c] = display.newImageRect(sceneGroup,pipes,6*color[r][c]+layout[r][c],104,104)
				tiles[r][c].x = 67 +(c-1)*104
				tiles[r][c].y = 151 +(r-1)*104
				tiles[r][c].r = r
				tiles[r][c].sc = sceneGroup
			end
		end
	end

	if(pref[1]==1)then sw_txt[1]=display.newImageRect(sceneGroup,onoff,1,104,104)
	else sw_txt[1]=display.newImageRect(sceneGroup,onoff,2,104,104) end
	sw_txt[1].x=900
	sw_txt[1].y=255

	if(pref[2]==1)then sw_txt[2]=display.newImageRect(sceneGroup,onoff,1,104,104)
	else sw_txt[2]=display.newImageRect(sceneGroup,onoff,2,104,104) end
	sw_txt[2].x=900
	sw_txt[2].y=462

	for i=1,2 do
		input = display.newImageRect(sceneGroup,inputs,color[2*i][1],104,52)
		input:rotate(-90)
		input.x=15
		input.y=151+i*208
	end

	for i=1,2 do
		if(pref[i]==0)then
			input = display.newImageRect(sceneGroup,inputs,4,104,52)
		else
			input = display.newImageRect(sceneGroup,inputs,color[2*i][1],104,52)
		end
		input:rotate(90)
		input.x=1263
		input.y=47+i*208
	end


	txt = display.newImageRect(sceneGroup,"img/settings_text_v2.png",1280, 720 )
	txt.x = 20
	txt.y = 3

	back = display.newImageRect(sceneGroup,buttons,2,171,68)
	back.x=136
	back.y=65
end




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	display.setDefault("anchorX",0)
	display.setDefault("anchorY",0)


	local sceneGroup = self.view

	local grey_back = display.newImageRect( sceneGroup, "img/grey_back.png", 1680, 1120 )
	grey_back.x=-200
	grey_back.y=-200

	local sheetOptions_B=
	{
		frames=
		{
			{x=207 ,y=0,width=589,height=68},-- title 1
			{x=0,y=0,width=171,height=68},-- back 1
		}
	}
	buttons = graphics.newImageSheet("img/settings_buttons.png", sheetOptions_B)
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
			{x=0  ,y=312,width=104,height=104},--horizontal yellow
	    {x=104,y=312,width=104,height=104},--vertikal yellow
	    {x=208,y=312,width=104,height=104},--up right yellow
	    {x=312,y=312,width=104,height=104},--down right yellow
	    {x=416,y=312,width=104,height=104},--down left yellow
	    {x=520,y=312,width=104,height=104}, --up left yellow
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
	    {x=1040,y=0,width=104,height=104}, --empty
	    {x=1040,y=104,width=104,height=104} --stone
	  }
	}
	pipes = graphics.newImageSheet("img/sheet.png", sheetOptions_A)

	local sheetOptions_C=
	{
	  frames=
	  {
			{x=208,y=0,width=104,height=52},-- input yellow
	    {x=0 ,y=0,width=104,height=52},-- input blue
			{x=104,y=0,width=104,height=52},-- input red
			{x=312,y=0,width=104,height=52},-- input grey
	  }
	}
	inputs = graphics.newImageSheet("img/inputs.png", sheetOptions_C)
	local sheetOptions_D=
	{
	  frames=
	  {
			{x=0,y=0,width=104,height=104},-- ON
	    {x=104 ,y=0,width=104,height=104},-- OFF
	  }
	}
	onoff = graphics.newImageSheet("img/onOff.png", sheetOptions_D)

	layout={
		{0, 0,0,0,0,0,0,0,0,0, 0},
		{1, 1,1,1,1,1,1,1,2,1, 1},
		{0, 0,0,0,0,0,0,0,0,0, 0},
		{1, 1,1,1,1,1,1,1,2,1, 1},
		{0, 0,0,0,0,0,0,0,0,0, 0}
	}
end


-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	loadScores()
	update(sceneGroup)
	if ( phase == "will" ) then


	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		back:addEventListener("tap",backtoMenu)

		tiles[2][9]:addEventListener("tap",changeSettings)
		tiles[4][9]:addEventListener("tap",changeSettings)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)


		composer.removeScene("settings")
	elseif ( phase == "did" ) then

		--saveScores()
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
