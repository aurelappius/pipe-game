-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")

--hide status bar
display.setStatusBar (display.HiddenStatusBar)
--random seed
math.randomseed(os.time())

--set settings and shop values

local json = require("json")
local filePathShop = system.pathForFile("shop.json",system.DocumentsDirectory)
local shop = 0 --ads on
local filePathPref = system.pathForFile("pref.json",system.DocumentsDirectory)
local pref = {1,1} --music and sfx on

local file = io.open(filePathShop, "r")
if file then
  local contents = file:read( "*a")
  io.close( file )
  shop = json.decode( contents )
end

local file = io.open(filePathPref, "r")
if file then
  local contents = file:read( "*a")
  io.close( file )
  pref = json.decode( contents )
end

composer.setVariable("ads",shop)
composer.setVariable("music",pref[1])
composer.setVariable("sfx",pref[2])

local click = audio.loadSound( "sfx/click.wav")
local expl = audio.loadSound( "sfx/explosion.wav")
local tile = audio.loadSound( "sfx/tile.wav")
local swipe = audio.loadSound( "sfx/swipe.wav")
local error = audio.loadSound( "sfx/error.wav")

composer.setVariable("sfx_click",click)
composer.setVariable("sfx_expl",expl)
composer.setVariable("sfx_tile",tile)
composer.setVariable("sfx_swipe",swipe)
composer.setVariable("sfx_error",error)

-- go to menu screen
composer.gotoScene("menu")

--reserve channel 1 for background menu music
audio.reserveChannels(1)
audio.setVolume(0.5, {channel=1})
