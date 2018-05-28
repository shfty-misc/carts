pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
 -- globals

scrollx = 0
scrolly = 0

-->8
-- perfhud

enable_profiling = true

t_prof = {}

function draw_perfhud()
	clip()

	local h = 0
 for k,v in pairs(t_prof) do
 	h += 6
 end
	
 rect(1,1,96,h+15,6)
 rectfill(2,2,95,h+14,0)
 
 color(7)
 cursor(3,3)
 
	if enable_profiling then
  for k,v in pairs(t_prof) do
  	local cpu = v.cpu*100
 	 print(k..": "..cpu.."%")
  end
  
  t_prof = {}
 end
 
 local cpu = stat(1)*100
 print("cpu "..cpu)
 print("fps "..stat(7))
end

function pr_start(name)
	if enable_profiling then
 	if t_prof[name] == nil then
 		t_prof[name] = {
 			start = 0,
 			cpu = 0
 		}
 	end
 	t_prof[name].start = stat(1)
	end
end

function pr_end(name)
	if enable_profiling then
		t_prof[name].cpu += stat(1) - t_prof[name].start
	end
end
-->8
-- scaling

function scale_linear(y)
	pr_start("scale_linear")
 ly = 2*(y-64)/128
 pr_end("scale_linear")
	return ly
end

function scale_sine(y)
	pr_start("scale_sine")
 local ly = y/128
 ly -= 0.5
 ly = sin(ly*0.5)
 ly *= ly
 ly *= 0.8
 ly += 0.2
	pr_end("scale_sine")
	return ly
end
-->8
-- scalepix

draw_pal = false

function map2spr(x,y)
	pr_start("map2spr")
	local sx,sy = -1,-1
	local s = mget(x,y)
	if s > 0 then
  sx = flr(s%16)*8
  sy = flr(s/16)*8
 end
	pr_end("map2spr")
 
 return sx,sy
end

function scanline(
	t_width,
	y,
	f_sc
)
	pr_start("locals")
	local t_width = t_width or 8
 local y = y or 0
 local f_sc = f_sc or scale_linear
	pr_end("locals")

 local scale = f_sc(y)
 
 if scale > 0 then
		pr_start("locals_inner")
  local step = 8*scale
  
  local lb = (t_width*4)*scale
  local la = -lb
  
  local sxs = scrollx*scale
  local la += 64+sxs
  local lb += 64+sxs
  pr_end("locals_inner")
  
  local i = 0
  for x=la,lb-1,step do
   if(x<128 and x+step>=0) then
   	if draw_pal then
					pr_start("draw_pal")
   		rect(
   			x+0.5,y,
   			x+step-0.5,y,
   			i
   		)
					pr_end("draw_pal")
   	else
   		local mx,my = i/8,y/8
    	local sx,sy = map2spr(mx,my)
   	
   		if sx > -1 and sy > -1 then
						pr_start("draw_spr")
    		sspr(
    			sx+i%8,sy+y%8,
    			1,1,
    			x,y,
    			ceil(step),1
    		)
						pr_end("draw_spr")
   		end
   	end
   end
   
   i += 1
  end
	end
end

-->8
-- main

function _init()
	-- play background music
	music(0)
end

function _update60()
	-- left / right scroll input
	if btn(0) then
	 scrollx += 1
	end
	
	if btn(1) then
		scrollx -= 1
	end
	
	-- toggle debug visualization
	if btnp(4) then
		draw_pal = not draw_pal
	end
	
	-- integrate vertical scroll
	scrolly = scrolly + 0.5
end

xw = 8
ys = 0
ye = 127

function _draw()
 cls()
 
 -- iterate through screen rows
 for y=ys,ye do
 	-- draw row
  scanline(
  	xw,
   y,
   scale_sine
  )
 end
 
 draw_perfhud()
end

__gfx__
00000000b7b7b7b74444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003b3b3b3b4999999407777770070000700007700007777770077777700777777000000000000000000000000000000000000000000000000000000000
00700700b3b3b3b349a99a9407000000070000700007700000077000077000700770077000000000000000000000000000000000000000000000000000000000
0007700094949494499aa99407777770077777700007700000077000077000700770077000000000000000000000000000000000000000000000000000000000
0007700049494949499aa99407777770077777700007700000077000077777700770077000000000000000000000000000000000000000000000000000000000
007007009494949449a99a9400000070070000700007700000077000077000000770077000000000000000000000000000000000000000000000000000000000
00000000292929294999999407777770070000700007700000077000077000000777777000000000000000000000000000000000000000000000000000000000
00000000424242424444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0103020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0106020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0207010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0208010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0206010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0107020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0106020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0203010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0206010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0208010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0207010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000000205000000020500000002050000000205000000020500000002050000000305000000030500000002050000000205000000020500000002050000000205000000020500000005050000000505000000
011000000065000000000000000024650000000000000000000000060000650000002665024000000000000000650000000000000000246500000000000000000000000600006500000026650000000000000000
011000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c60000000
__music__
01 00424344
01 00424344
01 00014344
03 00014244

