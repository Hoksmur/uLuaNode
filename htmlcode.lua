local M; M=http

local limit; limit=1460
local listf
local bufstr
 
  M.answer="HTTP/1.1 200 OK\
Server: uLuaNode\
Cache-Control: no-cache, must-revalidate\
Pragma: no-cache\
Content-Language: ru\
Content-Type: text/html; charset=utf-8\
Accept-Ranges: bytes\
Connection: close\
Content-Length: "
  limit=limit-#M.answer
  tmr.wdclr()
  bufstr=[==[<html><head> <title>esp8266 uLua</title>
<body><h1>]==] .."chipid="..tostring(node.chipid())..[==[</h1><br> <table cols="1" border="1" width="100%">
<tr><td>
<form action="/index.html">
<input name="mod" type="radio" value="1">STA<input name="mod" type="radio" value="2" checked>AP<input name="mod" type="radio" value="3">STA+AP<hr>
<tt> AP.SSID<input type=text name="AID" value="APssid"> pass<input type=text name="APW" value="123456"><br>
STA.SSID<input type=text name="SID" value="ssid"> pass<input type=text name="SPW" value="123"></tt><hr>
<input type="submit" value="Set">
</form>
</td></tr> <tr><td>]==].. tostring(M.apimsg) .. [==[</td></tr> <tr><td>32</td></tr>
</table></body></html>]==] 
  bufstr=tostring(#bufstr).."\r\n\r\n"..bufstr
  print( "limit #str:", limit-#bufstr)
  M.answer=M.answer..bufstr; bufstr=nil
  print("_index.html_ node.heap():", node.heap() )
  return M.answer
