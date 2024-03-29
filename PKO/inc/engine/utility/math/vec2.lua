--vec2
--two dimensional vector
-------------------------------
vec2={
	x=0,
	y=0
}

function vec2:new(x,y)
	self.__index=self
	return setmetatable({
		x=x or 0,
		y=y or 0
	}, self)
end

function vec2:is_a(t)
	return t == vec2
end

function vec2:__unm()
	return vec2:new(
		-self.x,
		-self.y
	)
end

function vec2:__add(rhs)
	if(type(rhs)=="table") then
 	return vec2:new(
 		self.x+rhs.x,
 		self.y+rhs.y
 	)
	end
	
	return vec2:new(
		self.x+rhs,
		self.y+rhs
	)
end

function vec2:__sub(rhs)
	if(type(rhs)=="table") then
 	return vec2:new(
 		self.x-rhs.x,
 		self.y-rhs.y
 	)
	end
	
	return vec2:new(
		self.x-rhs,
		self.y-rhs
	)
end

function vec2:__mul(rhs)
	if(type(rhs)=="table") then
 	return vec2:new(
 		self.x*rhs.x,
 		self.y*rhs.y
 	)
	end
	
	return vec2:new(
		self.x*rhs,
		self.y*rhs
	)
end

function vec2:__div(rhs)
	if(type(rhs)=="table") then
 	return vec2:new(
 		self.x/rhs.x,
 		self.y/rhs.y
 	)
 end
 
	return vec2:new(
		self.x/rhs,
		self.y/rhs
	)
end

function vec2:__mod(rhs)
	if(type(rhs)=="table") then
 	return vec2:new(
 		self.x%rhs.x,
 		self.y%rhs.y
 	)
 end
 
	return vec2:new(
		self.x%rhs,
		self.y%rhs
	)
end

function vec2:__pow(rhs)
	if(type(rhs)=="table") then
 	return vec2:new(
 		self.x^rhs.x,
 		self.y^rhs.y
 	)
 end
 
	return vec2:new(
		self.x^rhs,
		self.y^rhs
	)
end

function vec2:__eq(rhs)
	if(type(rhs)=="table") then
		return flr(self.x)==flr(rhs.x) and
			flr(self.y)==flr(rhs.y)
	end

	return self.x==rhs and
		self.y==rhs
end

function vec2:__lt(rhs)
	if(type(rhs)=="table") then
		return self.x<rhs.x and
			self.y<rhs.y
	end

	return self.x<rhs and
		self.y<rhs
end

function vec2:__le(rhs)
	if(type(rhs)=="table") then
		return self.x<=rhs.x and
			self.y<=rhs.y
	end

	return self.x<=rhs and
		self.y<=rhs
end

function vec2:copy()
	return vec2:new(self.x,self.y)
end

function vec2:sqlen()
	local sql = 0
	sql+=self.x^2
	sql+=self.y^2
	return sql
end

function vec2:len()
	return sqrt(self:sqlen())
end

function vec2:normalize()
	return self/self:len()
end

function vec2:rotate(a)
	local x = self.x * cos(a) + self.y * sin(a)
	local y = -self.x * sin(a) + self.y * cos(a)
	return vec2:new(x,y)
end

function vec2:perp_cw()
	return vec2:new(-self.y,self.x)
end

function vec2:perp_ccw()
	return vec2:new(self.y,-self.x)
end

function vec2:dot(rhs)
	local d=self.x*rhs.x
	d+=self.y*rhs.y
	return d
end

function vec2:lerp(tgt,d)
	d = max(d,0)
	d = min(d,1)
	return vec2:new(
		lerp(self.x,tgt.x,d),
		lerp(self.y,tgt.y,d)
	)
end

function vec2:__tostr()
	return "vec2 x:"..self.x..
	",y:"..self.y
end

function vec2.__concat(lhs,rhs)
	return tostr(lhs)..tostr(rhs)
end
