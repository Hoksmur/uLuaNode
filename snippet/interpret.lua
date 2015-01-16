-- small 'chunk' interpreter. Usage:
-- intr=loadfile("interpret.lua")
-- test: print( intr("test.lua", [startstring, endstring[, subchunk's params] ] ) )

-- function(fn, stidx, eidx, ...)
local fn, stidx, eidx,i
fn,stidx,eidx = ... 
--for i,j in pairs(arg1) do print("P:",i,j) end
local rez="";local buf="";succ=true
local cidx=1;local cond=true
if not stidx then stidx=1 end
file.open(fn)
repeat
 tmr.wdclr()
  buf=file.readline() tmr.wdclr()
  if buf and cidx>=stidx then 
    if not succ then
	  rez=rez..buf
	else
	  rez=buf
	end
	succ, rx=pcall( loadstring(rez), select(4,...) ) 
  end
  cidx=cidx+1 
  if eidx then cond=(cidx<=eidx) else cond=true end
until not( buf and cond)
file.close()
return rx
