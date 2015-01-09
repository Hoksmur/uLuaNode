--typepht
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
  local s1,s2,s3, func
  buf=file.readline()
  if buf then 
   s1,s2,s3=string.match(buf,"(.*)<%?lua(.-)%?>(.*)")
   if s2 then --part has inserted code
    func=assert(loadstring(s2))
	answer=answer..s1..tostring(func(...))..s3
   else -- hasn't
    answer=answer..buf
   end
  end
until not buf
 print("PHT #: ", #answer)
 return answer
