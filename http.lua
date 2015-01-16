--[==[ --for start
require("http")
--04-01-2014: chaged API file -> function 
--to set call back API function, returned 'string'
http:setapi( userfunc() 
M[apifunc] - API user function
M[req] - request
  M[answer] - anwer to browser
]==] 

local moduleName = ... 
local M = {}
_G[moduleName] = M

if not M.answer then
  M.req=""
  M.answer=""
  print("http initialized!")
else
  print("http.answer is nil!")
end

M.setapi=function (tab,callb) M.apifunc=callb end

-- run server
M.srv=net.createServer(net.TCP, 30)
M.srv:listen(80,function(conn) 

  conn:on("receive",  function(conn, pl )
    M.req=pl 
	pl=nil
	--prepare parameters
	dofile("parse.lua")
	--process user function, if exist
    if type( M.apifunc )=="function" then
	  collectgarbage("collect")
      M.apimsg=M.apifunc()
    else
      M.apimsg="MsgAPI" 
    end
    --get htmlcode
	local lfile; lfile=file.list()
	if M.file=="/" then
	  if lfile["index.html"] then M.file="/index.html"
       elseif lfile["index.lsf"] then M.file="/index.lsf"
	  elseif lfile["index.lua"] then M.file="/index.lua"
	  elseif  lfile["index.pht"] then M.file="/index.pht" end
	end
	if lfile[tostring(string.match(M.file, "/(.*)")) ] then --file esist
	  local ftype; ftype=string.match(M.file, "%.([%w]+)$")
	  if ftype=="lua" then
	    M.answer=loadfile(string.match(M.file, "([%w_%-%.!@#$%%]+)$")) ()
	  else
	    M.answer=loadfile("type"..tostring(ftype)..".lua")(M.file)
	  end
	  ftype=nil
	else -- file not found!
	  M.answer=loadfile("html404.lua")()
	end
	--send page
     collectgarbage("collect")
	conn:send(M.answer) 
  end)
  conn:on("sent",  function(conn, pl)  
    --print("c:on \"sent\"",pl)
	conn:close()
  end) 
end)

return M