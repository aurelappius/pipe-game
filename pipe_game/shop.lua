
local composer = require( "composer" )

local scene = composer.newScene()

local store
local targetAppStore = system.getInfo( "targetAppStore" )
if ( "apple" == targetAppStore ) then  -- iOS
    store = require( "store" )
elseif ( "google" == targetAppStore ) then  -- Android
    store = require( "plugin.google.iap.billing" )
elseif ( "amazon" == targetAppStore ) then  -- Amazon
    store = require( "plugin.amazon.iap" )
else
    print( "In-app purchases are not available for this platform." )
end

--only for testing
store = require( "store" )

local json = require("json")
local filePath = system.pathForFile("shop.json",system.DocumentsDirectory)
local shop = 0 --bought = 1, not bought 0
local productIdentifiers= "com.aurapps.pipes.ads"
local prize = "N/A"
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- ----------------------------------------------------------p-------------------------
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
		shop = json.decode( contents )
	end
end

local function saveScores()
	local file = io.open(filePath,"w")
	if file then
		file:write(json.encode(shop))
		io.close(file)
	end
end

local function productListener( event )
	print( event.products[1].productIdentifier )
	prize = event.products[1].localizedPrice
end

local function transactionListener( event )

    local transaction = event.transaction

    if ( transaction.isError ) then
        print( transaction.errorType )
        print( transaction.errorString )
    else
        -- No errors; proceed
        if ( transaction.state == "purchased" or transaction.state == "restored" ) then
            -- Handle a normal purchase or restored purchase here
            print( transaction.state )
            print( transaction.productIdentifier )
            print( transaction.date )

						shop=1
						composer.setVariable("ads",1)
						saveScores()

        elseif ( transaction.state == "cancelled" ) then
            -- Handle a cancelled transaction here

        elseif ( transaction.state == "failed" ) then
            -- Handle a failed transaction here
        end

        -- Tell the store that the transaction is complete
        -- If you're providing downloadable content, do not call this until the download has completed
        store.finishTransaction( transaction )
    end
end

local function purchaseEvent(event)
  if(composer.getVariable("sfx")==1) then
    audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  end
	if(shop==0)then
		store.purchase( productIdentifier )
	else
		print("already purchased")
	end
end

local function restoreEvent(event)
  if(composer.getVariable("sfx")==1) then
    audio.play(composer.getVariable("sfx_click"),{channel = 2,loops = 0})
  end
	if(shop==0)then
		store.restore( productIdentifier )
	else
		print("already purchased")
	end
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

	title = display.newImageRect(sceneGroup,buttons,1,589,68)
	title.x=display.contentCenterX-295
	title.y=65

	back = display.newImageRect(sceneGroup,buttons,2,171,68)
	back.x=136
	back.y=65

	p = display.newImageRect(sceneGroup,buttons,3,796,68)
	p.x=display.contentCenterX-395
	p.y=272

	pr = display.newText(sceneGroup,prize,820,275,native.systemFontBold, 55)
	pr:setFillColor( 0 )

	r = display.newImageRect(sceneGroup,buttons,4,796,68)
	r.x=display.contentCenterX-395
	r.y=482

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
			{x=0 ,y=68,width=796,height=68},-- purchase
			{x=0 ,y=136,width=796,height=68},-- restore
		}
	}
	buttons = graphics.newImageSheet("img/shop_buttons.png", sheetOptions_B)

	store.init( transactionListener )

	if ( store.canLoadProducts ) then
    store.loadProducts( productIdentifiers, productListener )
	end

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
		p:addEventListener("tap",purchaseEvent)
		r:addEventListener("tap",restoreEvent)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
    composer.removeScene("shop")
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
