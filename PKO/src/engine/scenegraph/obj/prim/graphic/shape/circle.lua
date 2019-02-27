--circle
--circle shape
-------------------------------
circle=shape:subclass({
	name="circle",
	r=1,								   --radius
})

function circle:draw_fill()
	local pos=self:getpos()
	circfill(
		pos.x,
		pos.y,
		self.r,
 	self.fc
 )
end

function circle:draw_stroke()
	local pos=self:getpos()
	circ(
		pos.x,
		pos.y,
		self.r,
 	self.sc
 )
end

function circle:contains(p,m)
	m = m or 255

	if(not band(self.cm,m)) then
		return false
	end

	local pos = self:getpos()
	local d = p-pos
	return d:len() <= self.r
end
