Paddle = Class{}

function Paddle:init(x, y, width, height, up, down, speed, AI)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.up = up
    self.down = down
    self.speed = speed
    self.AI = AI
end

function sign(num)
    if num > 0 then
        return 1
    elseif num < 0 then
        return -1
    else
        return 0
    end
end


function Paddle:update(dt, yFollow)
    if not self.AI then
        if love.keyboard.isDown(self.up) then
            self.y = self.y - self.speed*dt
        elseif love.keyboard.isDown(self.down) then
            self.y = self.y + self.speed*dt
        end
    else
        self.y = self.y + sign(yFollow - self.y)*math.min(math.abs(yFollow - self.y) , self.speed*dt)
    end
    self.y = math.min(heightV-self.height, self.y)
    self.y = math.max(0, self.y)
end

function Paddle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end