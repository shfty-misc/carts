require("prim")
require("proj_move")
require("map_contains")
require("time")

--missile
--homing projectile
-------------------------------
missile=prim:extend({
	name="missile",
	sa=0,					--start angle
	ss=80,				--start speed
	d=2,						--duration
	cm=7,					--collision mask
	mc=nil				--move component
})

function missile:init()
	prim.init(self)
	self.mc=proj_move:new(self,{
		a=self.sa,
		s=self.ss
	})
	self:trail()
	self:graphic()
end

function missile:update()
	--self.mc.a += 0.25 * time.dt

	self.d -= time.dt
	if(self.d <= 0) self:destroy()
	
	prim.update(self)

	local p = self:t().t
	if(map_contains(p, self.cm)) then
		self:destroy()
	end
end

function missile:graphic()
	return circle:new(self,{
		sc=6,
		fc=7
	})
end

function missile:trail()
	return trail:new(self,{
		cs={6,12,13,1}
	})
end
