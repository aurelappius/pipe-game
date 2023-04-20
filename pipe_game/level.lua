
local composer = require( "composer" )

local scene = composer.newScene()

local json = require("json")
local filePath = system.pathForFile("progess.json",system.DocumentsDirectory)
local progress = {0,0,0} --world 1,2,3
local musicTrack = composer.getVariable("musicTrack")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame(event)
	if(composer.getVariable("sfx")==1) then
    audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  end
	composer.setVariable("level", event.target.nr)
	composer.setVariable("world", event.target.wrld)
	composer.gotoScene("game")--,{ time=800, effect="crossFade" })
end


local function nextWorld(event)
	if(event.phase == "ended")then
		if(composer.getVariable("sfx")==1) then
    	audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  	end
		composer.gotoScene("level",{params={world=scene.w+1}})
	end
end

local function lastWorld(event)
	if(event.phase == "ended")then
		if(composer.getVariable("sfx")==1) then
    	audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  	end
		if(scene.w==1)then
			composer.gotoScene("menu")
		end
		if(scene.w>1) then
			composer.gotoScene("level",{params={world=scene.w-1}})
		end
	end
end

local function loadScores()
	local file = io.open(filePath, "r")
	if file then
		local contents = file:read( "*a")
		io.close( file )
		progress = json.decode( contents )
	end
end

local function saveScores()
	local file = io.open(filePath,"w")
	if file then
		file:write(json.encode(progress))
		io.close(file)
	end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	display.setDefault("anchorX",0)
	display.setDefault("anchorY",0)

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen


	--loadScores()

	local sheetOptions_B=
	{
		frames=
		{
			{x=207 ,y=0,width=589,height=68},-- title 1
			{x=207 ,y=68,width=589,height=68},-- title 2
			{x=207 ,y=136,width=589,height=68},-- title 3
			{x=0,y=0,width=171,height=68},-- back 1
			{x=0,y=68,width=171,height=68},-- back 2
			{x=0,y=136,width=171,height=68},-- back 3
		}
	}
	scene.buttons = graphics.newImageSheet("img/level_buttons.png", sheetOptions_B)
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
	scene.pipes = graphics.newImageSheet("img/sheet.png", sheetOptions_A)

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
	scene.inputs = graphics.newImageSheet("img/inputs.png", sheetOptions_C)

	scene.layout = {
		{1, 1,1,1,1,1,1,1,1,1, 5},
		{4, 1,1,1,1,1,1,1,1,1, 6},
		{3, 1,1,1,1,1,1,1,1,1, 5},
		{4, 1,1,1,1,1,1,1,1,1, 6},
		{3, 1,1,1,1,1,1,1,1,1, 1}
	}
	scene.level_distr = {
		{0, 1,2,3,4,5,6,7,8,9, 0},
		{0, 18,17,16,15,14,13,12,11,10, 0},
		{0, 19,20,21,22,23,24,25,26,27, 0},
		{0, 36,35,34,33,32,31,30,29,28, 0},
		{0, 37,38,39,40,41,42,43,44,45, 0}
	}
end


-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	loadScores()

	scene.cont=event.params.success

	if ( phase == "will" ) then
		scene.w=event.params.world
		scene.color = {
			{0, 0,0,0,0,0,0,0,0,0, 0},
			{0, 0,0,0,0,0,0,0,0,0, 0},
			{0, 0,0,0,0,0,0,0,0,0, 0},
			{0, 0,0,0,0,0,0,0,0,0, 0},
			{0, 0,0,0,0,0,0,0,0,0, 0}
		}

			print("world: "..scene.w)

		if(event.params.success==1 and event.params.level==progress[scene.w]+1 and event.params.level~=45) then
			progress[scene.w]=progress[scene.w]+1
			saveScores()
		end

		if(event.params.success==2 and event.params.level==progress[scene.w]+1 and event.params.level~=45) then
			progress[scene.w]=progress[scene.w]+1
			saveScores()
			composer.setVariable("level", event.params.level+1)
			composer.setVariable("world", scene.w)
			composer.gotoScene("game")
		elseif(event.params.success==2 and event.params.level~=45) then
			composer.setVariable("level", event.params.level+1)
			composer.setVariable("world", scene.w)
			composer.gotoScene("game")
		end

		if(event.params.level==45) then
			progress[scene.w]=45
			saveScores()
		end

		local lvl=progress[scene.w]

		if(lvl==0) then scene.color[1][1]=1 end
		if(lvl>=1 and lvl<=8) then
			for i = 1,lvl+1 do
				scene.color[1][i]=1
			end
		end
		if(lvl>=9 and lvl<=17) then
			scene.color[1]={1,1,1,1,1,1,1,1,1,1,1}
			for i = 20-lvl,11 do
				scene.color[2][i]=1
			end
		end
		if(lvl>=18 and lvl<=26) then
			scene.color[1]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[2]={1,1,1,1,1,1,1,1,1,1,1}
			for i = 1,lvl-17 do
				scene.color[3][i]=1
			end
		end
		if(lvl>=27 and lvl<=35) then
			scene.color[1]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[2]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[3]={1,1,1,1,1,1,1,1,1,1,1}
			for i = 38-lvl,11 do
				scene.color[4][i]=1
			end
		end
		if(lvl>=36 and lvl<=44) then
			scene.color[1]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[2]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[3]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[4]={1,1,1,1,1,1,1,1,1,1,1}
			for i = 1,lvl-35 do
				scene.color[5][i]=1
			end
		end
		if(lvl==45)then
			scene.color[1]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[2]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[3]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[4]={1,1,1,1,1,1,1,1,1,1,1}
			scene.color[5]={1,1,1,1,1,1,1,1,1,1,1}
		end

		--check for success

		scene.grey_back = display.newImageRect( sceneGroup, "img/grey_back.png", 1680, 1120 )
		scene.grey_back.x=-200
		scene.grey_back.y=-200

		scene.background = display.newImageRect( sceneGroup, "img/level_screen.png", 1280, 720 )
		scene.background.x = 0
		scene.background.y = 0


		scene.title = display.newImageRect(sceneGroup,scene.buttons,scene.w,589,68)
		scene.title.x=display.contentCenterX-295
		scene.title.y=65

		scene.tiles={{},{},{},{},{}}
		for r=1,5 do
			for c=1,11 do
				scene.tiles[r][c] = display.newImageRect(sceneGroup,scene.pipes,6*scene.w*scene.color[r][c]+scene.layout[r][c],104,104)
				scene.tiles[r][c].x = 67 +(c-1)*104
				scene.tiles[r][c].y = 151 +(r-1)*104
				scene.tiles[r][c].nr = scene.level_distr[r][c]
				scene.tiles[r][c].wrld = scene.w
			end
		end

		scene.input = display.newImageRect(sceneGroup,scene.inputs,scene.w,104,52)
		scene.input:rotate(-90)
		scene.input.x=15
		scene.input.y=255

		if(lvl==45)then
			scene.ouput = display.newImageRect(sceneGroup,scene.inputs,scene.w,104,52)
		else
			scene.ouput = display.newImageRect(sceneGroup,scene.inputs,4,104,52)
		end
		scene.ouput:rotate(90)
		scene.ouput.x=1264
		scene.ouput.y=567


		scene.numbers = display.newImageRect(sceneGroup,"img/level_screen_numbers.png",1280, 720 )
		scene.numbers.x = 0
		scene.numbers.y = 3
		scene.back = display.newImageRect(sceneGroup,scene.buttons,scene.w+3,171,68)
		scene.back.x=136
		scene.back.y=65

		if( scene.w~=3 )then
			scene.next = display.newImageRect(sceneGroup,scene.buttons,scene.w+3,171,68)
			scene.next:rotate(180)
			scene.next.x=1141
			scene.next.y=133
		end

		if(scene.w~=1)then --blocked worlds (coming soon)
			scene.comingSoon = display.newImageRect(sceneGroup,"img/coming_soon_v2.png",2800, 600 )
			scene.comingSoon.x=-600
			scene.comingSoon.y=150
		end

		if(scene.w==1)then
			display.remove(scene.comingSoon)
		end
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		scene.back:addEventListener("touch",lastWorld)
		if( scene.w~=3 )then
			scene.next:addEventListener("touch",nextWorld)
		end
		for r=1,5 do
			for c=1,11 do
				if(scene.tiles[r][c].nr~=0 and scene.tiles[r][c].nr<=progress[scene.w]+1) then
					if(scene.w==1)then--blocked worlds (coming soon)
						scene.tiles[r][c]:addEventListener("tap",gotoGame)
					end
				end
			end
		end
		if(composer.getVariable("music")==1)then
			audio.play( musicTrack, { channel=1, loops=-1 } )
		end
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

		if(scene.cont~=2)then
			if( scene.w~=3 )then
				scene.next:removeEventListener("tap",nextWorld)
			end
			scene.back:removeEventListener("tap",lastWorld)
			for r=1,5 do
				for c=1,11 do
					if(scene.tiles[r][c].nr~=0 and scene.tiles[r][c].nr<=progress[scene.w]+1) then
						if(scene.w==1)then--blocked worlds (coming soon)
							scene.tiles[r][c]:removeEventListener("tap",gotoGame)
						end
					end
				end
			end
		end

		--composer.removeScene("level")
	elseif ( phase == "did" ) then

		if(scene.cont~=2)then
			display.remove(scene.title)
			display.remove(scene.next)
			display.remove(scene.back)
			for r=1,5 do
				for c=1,11 do
					display.remove(scene.tiles[r][c] )
				end
			end
		end

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
