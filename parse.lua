--[==[ parse header
set M.type to GET or POST or [....]
set M.file : replace / to index.html or real requested
set M.params to request string or ""
 if POST, set M.boundary and M.boundlen
]==] 
local M;M=http

local i,j
local name,val,tab

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
  j=1; tab={} 
  repeat
   i,j,name,val=string.find(stmp,"([%w_%-%(%)]+)=([%w_%-%(%)]*)",j) 
   if i then tab[name]=val end
  until not i
  M.params=tab
  stmp=nil
else -- no parameters
  M.params=nil
end

M.req=nil
