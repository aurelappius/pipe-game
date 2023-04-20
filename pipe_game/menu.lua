
local composer = require( "composer" )

local scene = composer.newScene()

local musicTrack

local creditsActive=false

local sheetOptions=
{
	frames=
	{
		{x=0 ,y=0,width=171,height=68},-- settings button
		{x=206,y=0,width=592,height=68},-- play button
		{x=832,y=0,width=172,height=68},-- shop button
	}
}
local buttons = graphics.newImageSheet("img/title_buttons.png", sheetOptions)

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local gotoLevel
local gotoSettings
local gotoShop
local showMenu
local showCredits
local backtoMenu


gotoLevel=function()
	if(creditsActive==false)then
		if(composer.getVariable("sfx")==1) then
			audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
		end
		composer.gotoScene("level",{params={world=1, level=0, success=0}})--,{ time=800, effect="crossFade" })
	end
end

gotoSettings=function()
	if(creditsActive==false)then
		if(composer.getVariable("sfx")==1) then
			audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
		end
		composer.gotoScene("settings")--,{ time=800, effect="crossFade" })
	end
end

gotoShop=function()
	if(creditsActive==false)then
		if(composer.getVariable("sfx")==1) then
			audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
		end
		composer.gotoScene("shop")--,{ time=800, effect="crossFade" })
	end
end

backtoMenu=function(event)
	if(creditsActive==true)then
		creditsActive=false
		if(composer.getVariable("sfx")==1) then
			audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
		end
		showMenu(event.target.sg)
	end
end

showCredits=function(event)
	if(creditsActive==false)then
    if(event.phase == "ended" or event.phase == "cancelled" or (event.x-event.xStart)>15 or (event.y-event.yStart)>15) then
			if(composer.getVariable("sfx")==1) then
				audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
			end
      local scene=event.target.sg
			creditsActive=true
		  local creditsScreen = display.newImageRect(scene, "img/creditsScreen.png", 1680, 1120)
		  creditsScreen.x = -200
		  creditsScreen.y = -200
		  qb=display.newImageRect(scene,"img/close_button.png",68,68)
		  qb.x=990
		  qb.y=120
			qb.sg=scene
		  qb:addEventListener("tap",backtoMenu)
    end
  end
end

showMenu=function(scene)
	local grey_back = display.newImageRect( scene, "img/grey_back.png", 1680, 1120 )
	grey_back.x=-200
	grey_back.y=-200
	local background = display.newImageRect( scene, "img/title_screen.png", 1280, 720 )
	background.x = 0
	background.y = 0
	local settingsButton = display.newImageRect(scene,buttons,1,171,68)
	settingsButton.x=136
	settingsButton.y=484
	local playButton = display.newImageRect(scene,buttons,2,592,68)
	playButton.x=346
	playButton.y=484
	local shopButton = display.newImageRect(scene,buttons,3,172,68)
	shopButton.x=970
	shopButton.y=484
	local infoButton = display.newImageRect(scene, "img/info_button.png", 68, 68 )
	infoButton.x=85
	infoButton.y=63
	settingsButton:addEventListener("tap",gotoSettings)
	playButton:addEventListener("tap",gotoLevel)
	shopButton:addEventListener("tap", gotoShop)
	infoButton.sg=scene
	infoButton:addEventListener("touch",showCredits)
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

	showMenu(sceneGroup)

	musicTrack = audio.loadStream( "music/menu.wav")

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		composer.setVariable("musicTrack",musicTrack)
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
