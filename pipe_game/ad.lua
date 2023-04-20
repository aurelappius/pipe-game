
local composer = require( "composer" )

local scene = composer.newScene()

local admob = require( "plugin.admob" )

local w=0
local l=0
local s=0
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function continue()
	composer.gotoScene("level",{params={world=w, level=l, success=s}})
end

local function adListener( event )

    if ( event.phase == "init" ) then  -- Successful initialization
			admob.load( "interstitial", { adUnitId="ca-app-pub-3940256099942544/1033173712"})--ca-app-pub-5427361289209198/5830736943" } )

		elseif ( event.phase == "failed" ) then  -- The ad failed to load
			 print( event.type )
			 print( event.isError )
			 print( event.response )
	 end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local grey_back = display.newImageRect( sceneGroup, "img/grey_back.png", 1680, 1120 )
	grey_back.x=-200
	grey_back.y=-200

	admob.init( adListener, { appId="ca-app-pub-5427361289209198~2466207001" } )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	w=event.params.world
	s=event.params.success
	l=event.params.level
	if ( phase == "will" ) then
		if ( admob.isLoaded( "interstitial" ) ) then
    	admob.show( "interstitial" )
		end
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		timer.performWithDelay(2000,continue)
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
		composer.removeScene("ad")
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
