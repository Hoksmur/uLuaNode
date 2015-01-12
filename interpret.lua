-- small 'chunk' interpreter
local interpret=function(fn, ...)
local rez="";local buf="";succ=true
file.open(fn)
repeat
  buf=file.readline()
  if buf then 
    if not succ then
	  rez=rez..buf
	else
	  rez=buf
	end
	succ, rx=pcall( loadstring(rez), ... )
	--print( succ,rx)
  end
until not buf
file.close()
end
-- for use: interpret("test.lua",123, "sTriNg")
return interpret