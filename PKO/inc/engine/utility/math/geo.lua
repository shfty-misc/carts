require("vec2")

geo={
	name="geo",
	vs=nil,				--vertices
	be=nil,				--box extents
	cr=nil					--circle radius
}

function geo:new(v)
	self.__index=self

	local o = setmetatable({}, self)

	if(type(v) == "table") then
		if(v.is_a and v:is_a(vec2)) then
			o.be = v
			o:calculate_circle()
		else
			o.vs=v
			o:calculate_box()
			o:calculate_circle()
		end
	else
		o.cr = v
	end

	return o
end

	function geo:calculate_box()
	local bmin = nil
	local bmax = nil

	for v in all(self.vs) do
		if(bmin == nil) then
			bmin = vec2:new(v.x,v.y)
		else
			if(bmin.x > v.x) bmin.x = v.x
			if(bmin.y > v.y) bmin.y = v.y
		end
		if(bmax == nil) then
			bmax = vec2:new(v.x,v.y)
		else
			if(bmax.x < v.x) bmax.x = v.x
			if(bmax.y < v.y) bmax.y = v.y
		end
	end

	self.be=vec2:new(
		(bmax.x-bmin.x)/2,
		(bmax.y-bmin.y)/2
	)
end

function geo:calculate_circle()
	self.cr=max(self.be.x,self.be.y)
end

function geo:__eq(rhs)
	if(self.cr!=rhs.cr) return false
	if(self.be!=rhs.be) return false
	if(#self.vs != #rhs.vs) return false
	for i = 1, #self.vs do
		if(self.vs[i] != rhs.vs[i]) return false
	end
	return true
end
