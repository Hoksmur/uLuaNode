local answer
local fname; local par; local msg
fname,par,msg=...
answer="HTTP/1.1 200 OK\
Server: uLuaNode\
Cache-Control: no-cache, must-revalidate\
Pragma: no-cache\
Content-Language: ru\
Content-Type: text/html; charset=utf-8\
Accept-Ranges: bytes\
Connection: close\r\n\r\n"
file.open(string.match( fname,"/(.+)"),"r")
repeat
  local buf
  buf=file.readline()
  if buf then answer=answer..buf end
until not buf
 print("html #: ", #answer)
 return answer