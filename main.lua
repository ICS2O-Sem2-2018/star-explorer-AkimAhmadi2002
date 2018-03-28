-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )


math.randomseed( os.time()  )


local sheetOptions =
{
    frames =
    {
        {   -- 1 ) ASTEROID 1
            x = 0,
            y = 0,
            width = 102,
            heigth = 85
        },
        {   -- 2) ASTEROID 2
            x = 0,
            y = 85,
            width = 90,
            height =  83
        },
        {   -- 3) ASTEROID 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}
local objectSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

-- Initialize variables
local lives = 3
local score = 0
local died = false

local asteroidsTable = {}

local ship
local gameLoopTimer
local livesText
local scoreText

-- Set up display groups
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Load the background
local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody( ship, { radius=30, isSensor=true } )
ship.myName = "ship"

--Display lives and score
livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36)


display.setStatusBar( display.HiddenStatusBar )


local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end


local function createAsteroids()

    local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 85 )
    table.insert( asteroidsTable, newAsteroid )
    physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
    newAsteroid.myname = "asteroid"

    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then

        newAsteroid.x = -60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then

        newAsteroid.x = math.random( display.contentWidth )
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then

        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y= math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end

        newAsteroid:applyTorque( math.random( -6,6 ) )
end


local function fireLaser()

    local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40 )
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true
    newLaser.myName = "Laser"

    newLaser.x = ship.x
    newLaser.y = ship.y
    newLaser:toBack()

    transition.to( newLaser, { y=-40, time=500,
        onComplete = function() display.remove( newLaser ) end
    } )
end

ship:addEventListener( "tap", fireLaser )


local function dragShip( event )

    local ship = event.target
    local phase = event.phase

    if ( "began" == phase ) then

        display.currentStage:setFocus( ship )

        ship.touchOffsetX = event.x - ship.x

   elseif ( "moved" == phase ) then

       ship.x = event.x - ship.touchOffsetX
   end
end
