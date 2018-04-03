
local composer = require( "composer" )

local scene = composer.newScene()


local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

local function gotogame()
    composer.gotoScene( "game" )
end
math.randomseed( os.time() )


composer.gotoScene( "menu" )
