Ball = Class{}

function Ball:init(x, y, width, height, Xspeed, Yspeed)
    self.x = x
    self.y = y
    self.initX = x
    self.initY = y
    self.width = width
    self.height = height
    self.Xspeed = Xspeed
    self.Yspeed = Yspeed
    self.dx = (math.random(2) == 0 and self.Xspeed or -self.Xspeed)
    self.dy = math.random(-self.Yspeed, self.Yspeed)
end

function Ball:collide(paddle)
    if paddle.x > self.x + self.width or self.x > paddle.x + paddle.width then
        return false
    end
    if paddle.y > self.y + self.height or self.y > paddle.y + paddle.height then
        return false
    end
    return true
end

function Ball:reset(dir)
    self.x = self.initX
    self.y = self.initY
    self.dx = (dir == 1 and self.Xspeed or -self.Xspeed)
    self.dy = math.random(-self.Yspeed, self.Yspeed)
end

function Ball:update(dt)
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt
end

function Ball:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end