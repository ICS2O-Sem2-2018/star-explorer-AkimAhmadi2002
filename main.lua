





local composer = require( "composer" )

local scene = composer.newScene()
display.setStatusBar( display.HiddenStatusBar )

local composer = require( "composer" )
math.randomseed( os.time() )


composer.gotoScene( "menu" )
local function gotogame()
    composer.gotoScene( "game" )
end
