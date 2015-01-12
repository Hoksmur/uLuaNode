-- small 'chunk' interpreter
-- for use: interpret("test.lua",123, "sTriNg")
-- test: print( interpret("test.lua", [startstring, endstring[ subfiles params] ] ) )

local interpret=function(fn, stidx, eidx, ...)
local rez="";local buf="";succ=true
local cidx=1;local cond=true
if not stidx then stidx=1 end
file.open(fn)
repeat
  buf=file.readline()
  if buf and cidx>=stidx then 
    if not succ then
	  rez=rez..buf
	else
	  rez=buf
	end
	succ, rx=pcall( loadstring(rez), ... )
	--print( succ,rx)
  end
  cidx=cidx+1 
  if eidx then cond=(cidx<=eidx) else cond=true end
until not( buf and cond)
file.close()
return rx
end

return interpret