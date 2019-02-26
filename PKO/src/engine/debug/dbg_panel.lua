--debug panel
-------------------------------
dbg_panel=graphic:subclass({
	name="debug panel",
	pos=vec2:new(0,8),
	sz=vec2:new(123,115),
	sy=0,
	key=nil,
	v=false,
	c={2,10,124,116}
})

function dbg_panel:init()
	graphic.init(self)
	local bg=box:new(self,{
		sz=self.sz,
		sc=0x1107.0000,
		fc=0x1100.5a5a
	})
end

function dbg_panel:update()
	if(not self.v) return
	
	if(keyp("-")) self.sy -= 114
	if(keyp("=")) self.sy += 114
	if(keyp("[")) self.sy -= 6
	if(keyp("]")) self.sy += 6
	
	self.sy = max(self.sy,0)
	
	graphic.update(self)
end

function dbg_panel:tostring()
	return
		prim.tostring(self).." "..
		"w:"..flr(self.w)..","..
		"w:"..flr(self.w)
end