--debug scenegraph
-------------------------------
dbg_sg=dbg_panel:subclass({
	name="scenegraph",
	key="3",
	cw=nil,
	tw=nil
})

function dbg_sg:init()
	dbg_panel.init(self)

	self.cw=clip:new(self,{
		r=rect:new(2,10,124,116)
	})
	
	self.tw=text:new(self.cw,{
		pos=vec2:new(2,2)
	})
end

function dbg_sg:update()
	dbg_panel.update(self)
	
	if(not self.v) return

	local tw = self.tw
	tw.pos.y=2-self.sy
	tw.str=engine.sg:print()
end