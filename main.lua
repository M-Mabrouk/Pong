-- "C:\Program Files\LOVE\love.exe" "C:\Users\Mabrouk\Desktop\Love2D\Pong"
-- "C:\Program Files\LOVE\love.exe" "C:\Users\Mabrouk\Desktop\Love2D\Pong" --console

width = 1280
height = 720
widthV = 432
heightV = 243
playerSpeed = 200
computerSpeed = 80
ballYspeed = 120
ballXspeed = 150
gameState = "start"
playerScore = 0
computerScore = 0
speedFactor = 1.09
agression = 1.1
yThreshMin = 10
yThreshMax = 120
winStatement = ""
scored = 2
turn = 1

push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'

function sign(num)
    if num > 0 then
        return 1
    elseif num < 0 then
        return -1
    else
        return 0
    end
end

function ShowFps()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("Fps: " .. tostring(love.timer.getFPS()), 10, 10)
end

function love.load()

    love.window.setTitle("Pong")

    love.graphics.setDefaultFilter("nearest", "nearest")

    push:setupScreen(widthV, heightV, width, height, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('font.ttf', 16)
    largeFont = love.graphics.newFont('font.ttf', 32)

    player = Paddle(10, 30, 5, 20, 'up', 'down', playerSpeed, false)
    computer = Paddle(widthV - 10, heightV - 30, 5, 20, '', '', computerSpeed, true)
    ball = Ball(widthV / 2 - 2, heightV / 2 - 2, 4, 4, ballXspeed, ballYspeed)

    math.randomseed(os.time())
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == "start" then
        if love.keyboard.isDown("return") then
            gameState = "serve"
        end
    elseif gameState == "serve" then
        turn = 3 - scored
        ball:reset(turn)
        if love.keyboard.isDown("space") then
            gameState = "play"
        end
    elseif gameState == "score" then
        if(scored == 1) then
            playerScore = playerScore + 1
            computer.speed = computer.speed * agression
        else
            computerScore = computerScore + 1
            computer.speed = computer.speed / agression
        end
        if playerScore > 10 or computerScore > 10 then
            gameState = "win"
        else
            gameState = "serve"
        end
    elseif gameState == "win" then
        winStatement = scored == 1 and "Player" or "Computer"
        winStatement = winStatement .. " Won!"
        if love.keyboard.isDown("return") then
            gameState = "serve"
            ball.dx = ballXspeed
            playerScore = 0
            computerScore = 0
        end
    elseif gameState == "play" then
        if ball:collide(player) or ball:collide(computer) then
            ball.dx = -ball.dx * speedFactor
            ball.dy = sign(ball.dy)*math.random(yThreshMin, yThreshMax)
            ball.x = math.max(player.x + player.width, ball.x)
            ball.x = math.min(computer.x - ball.width, ball.x)
            sounds.paddle_hit:play()
        end
        if ball.y < 0 or ball.y > heightV-ball.height then
            ball.dy = -ball.dy
            ball.y = math.max(0, ball.y)
            ball.y = math.min(heightV - ball.height, ball.y)
            sounds.wall_hit:play()
        end
        if ball.x < player.x - ball.width or ball.x > computer.x + computer.width then
            sounds.score:play()
            scored = ball.x < player.x - ball.width and 2 or 1 
            gameState = "score"
        end
        ball:update(dt)
    end
    player:update(dt, 0)
    computer:update(dt, ball.y - (computer.height - ball.height)/2)
end

function displayScore()
    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(playerScore), widthV / 2 - 50, 20)
    love.graphics.print(tostring(computerScore), widthV / 2 + 30, 20)
end

function love.draw()
    push:apply('start')

    love.graphics.clear(0, 0, 0, 255)
    if gameState == "start" then
        love.graphics.setFont(mediumFont)
        love.graphics.printf("Pong", 0, 20, widthV, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("press enter", 0, 40, widthV, "center")
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("player " .. tostring(turn) .. " serve", 0, 10, widthV, "center")
    elseif gameState == "win" then 
        love.graphics.setFont(mediumFont)
        love.graphics.printf(winStatement, 0, heightV/2, widthV, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("press enter", 0, heightV/2 + 20, widthV, "center")
    end

    displayScore()

    player:draw()
    computer:draw()
    ball:draw()

    ShowFps()

    push:apply('end')
end

function love.keypressed(key)
    if(key == "Escape") then
        love.event.quit()
    end
end