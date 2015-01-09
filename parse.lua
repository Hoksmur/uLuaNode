print("_parse_ node.heap() : ", node.heap() )
--[==[ parse header
set M.type to GET or POST or [....]
set M.file : replace / to index.html or real requested
set M.params to request string or ""
 if POST, set M.boundary and M.boundlen
]==] 
local M;M=http

local i; local j
i,j=string.find(M.req, "\r\n")
if string.find(M.req, "([%u]+) /") < i then
  M.type=string.match(M.req, "([%u]+) /")
else
  M.type=string.sub(M.req, 4)
end
i=nil; j=nil

if M.boundary and M.boundary ~= "" then
 --do this if we wait boundary
end

local stmp
M.file=string.match(M.req, "[%u]+ (/[%d%a]*%.?[%d%a]*)")

stmp=string.match(M.req, "%?([%a%d%p]+)" )
if stmp then -- parameters exist
  M.params=stmp
  stmp=nil
else -- no parameters
  M.params=""
end

if M.type=="POST" then
  if string.match(M.req, "boundary(.)") then 
    --boundary part found
    M.boundary=string.match(M.req, "boundary=([%a%d%p]*)" ) 
    M.boundlen=tonumber(string.match(M.req, "Content%-Length: (%d*)") )
  else
    M.boundary=""
    M.boundlen=0
  end
end

M.req=nil
collectgarbage("collect")