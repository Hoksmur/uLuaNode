-- not exist [404]
print("! ...", ... )
local M; M=http
local bufstr; local outstr 
  outstr="HTTP/1.1 404 Not Found\
Server: uLuaNode\
Cache-Control: no-cache, must-revalidate\
Pragma: no-cache\
Content-Language: ru\
Content-Type: text/html; charset=utf-8\
Accept-Ranges: bytes\
Connection: close\
Content-Length: "
  bufstr=[==[<html><head><meta http-equiv="refresh" content="10; url=/" /></head><body>
<h1>File <font color="#CC0080">]==].. M.file ..[==[</font> not found!</h1><br>
go to <a href="/"><b>start page</b></a>
</body></html> ]==] 
  bufstr=tostring(#bufstr).."\r\n\r\n"..bufstr
  outstr=outstr..bufstr; bufstr=nil
  print("_404_ node.heap():", node.heap(), "lenght: ", #outstr )

  return outstr
