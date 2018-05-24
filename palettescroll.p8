pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- readsprite

function rspr(idx,y)
	if idx == 0 then
		return {0}
	end

	local pix = {}
	
	local li = idx*4
	local ly = y*64
	ly += flr(idx/16)*64*7

	local start = li+ly

	for i=start,start+3 do
	 local bc = peek(i)
		local b1 = flr(bc%16)
		local b2 = flr(bc/16)
		add(pix, b1)
		add(pix, b2)
	end
	
	return pix
end

function rmap(x,y)
	local idx = mget(x,y/8)
	return rspr(idx,y%8)
end
-->8
-- scaling

rec128 = 1/128

function scale_linear(y)
	return 2*(y-64)*rec128
end

function scale_sine(y)
 local ly = y*rec128
 ly -= 0.5
 ly = sin(ly*0.5)
 ly *= ly
 ly *= 0.8
 ly += 0.2
	return ly
end
-->8
-- uvs

function uv_linear(y,wrap)
	local uvy = y+scrolly
	uvy *= 0.5
	uvy = flr(uvy)
	uvy %= wrap
 return uvy
end

-->8
-- palettescroll

draw_pal = false

function scanline(
	t_width,
	y,
	f_sc,
	f_uv,
	uv_wrap
)
	local t_width = t_width or 8
 local y = y or 0
 local f_sc = f_sc or scale_linear
 local f_uv = f_uv or uv_linear
 local uv_wrap = uv_wrap or 8
 
 local scale = f_sc(y)
 if scale > 0 then
  local step = 8*scale
  
  local lb = (t_width*4)*scale
  local la = -lb
  
  local la += 64+(scrollx*scale)
  local lb += 64+(scrollx*scale)
  
  local pixs = {}
  add(pixs, rmap(0,f_uv(y,uv_wrap)))
  add(pixs, rmap(1,f_uv(y,uv_wrap)))
  add(pixs, rmap(2,f_uv(y,uv_wrap)))
  local i = 0
  
  for x=la,lb-1,step do
   local le = x+step
   
   if(x<128 and le>=0) then
   	local c = 0
   	if draw_pal then
   		c = i
   	else
   		local pix = pixs[1+flr(i/8)]
   		c = pix[1+(i%#pix)]
   	end
   	
   	rect(x+0.5,y,le-0.5,y,c)
   end
   
   i += 1
  end
	end
end

-->8
-- main

scrollx = 0
scrolly = 0

function _init()
	music(0)
end

function _update60()
	if btn(0) then
	 scrollx += 1
	end
	
	if btn(1) then
		scrollx -= 1
	end
	
	if btnp(4) then
		draw_pal = not draw_pal
	end
	
	scrolly = scrolly + 0.5
end

function _draw()
 cls()
 
 for y=0,127 do
  scanline(
  	24,
   y,
   scale_sine,
   uv_linear,
   11*8
  )
 end
end

__gfx__
00000000b7b7b7b74444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003b3b3b3b4999999407777770070000700007700007777770077777700777777007777770077777700000000000000000000000000000000000000000
00700700b3b3b3b349a99a9407000000070000700007700000077000077000700770077007000000000770000000000000000000000000000000000000000000
0007700094949494499aa99407777770077777700007700000077000077000700770077007777770000770000000000000000000000000000000000000000000
0007700049494949499aa99407777770077777700007700000077000077777700770077007777770000770000000000000000000000000000000000000000000
007007009494949449a99a9400000070070000700007700000077000077000000770077000000070000770000000000000000000000000000000000000000000
00000000292929294999999407777770070000700007700000077000077000000777777007777770000770000000000000000000000000000000000000000000
00000000424242424444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05666666666666666666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56666666667777666666666500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56677777777777777777766500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56677777777777777777766500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56666666667777666666666500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05666666666666666666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0103020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0106020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0207010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0208010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0209010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020a010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000000205000000020500000002050000000205000000020500000002050000000305000000030500000002050000000205000000020500000002050000000205000000020500000005050000000505000000
011000000065000000000000000024650000000000000000000000060000650000002665024000000000000000650000000000000000246500000000000000000000000600006500000026650000000000000000
011000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c600000003c60000000
__music__
01 00424344
01 00424344
01 00014344
03 00014244

