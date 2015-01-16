local lsf={}
 lsf.twp=dofile("wifi.tab")
 lsf.t={ '<INPUT TYPE="radio" name="wm" VALUE=1', --first wm,
'>STA<INPUT TYPE="radio" name="wm" VALUE=2', --second wm
'>AP <INPUT TYPE="radio" name="wm" VALUE=3', --third wm
'>BOTH<br><tt>STA SSID, password<input type="text" name="staid" value="'..lsf.twp["staid"], --STA_SSID
'"><input type="text" name="stapwd" value="'..lsf.twp["stapwd"], --station pass
'"><br>AP SSID, password&nbsp;<input type="text" name="apid" value="'..lsf.twp["apid"], --AP id
'"><input type="text" name="appwd" value="'..lsf.twp["appwd"], --AP pass
'"><br></tt><input type="submit" value="Apply changes"></form>'}
-- lsf.t[wifi.getmode()]=lsf.t[wifi.getmode()].." checked"
lsf.t[ tonumber(lsf.twp.wm) ]=lsf.t[ tonumber(lsf.twp.wm) ].." checked"
lsf.twp=nil
local wm,ws
 wm=wifi.getmode()
if wm==1 then ws="Station"
elseif wm==2 then ws="Access point"
else ws="Station + Access point" end

 http.answer= 'HTTP/1.1 200 OK\
Server: uLuaNode\
Cache-Control: no-cache, must-revalidate\
Pragma: no-cache\
Content-Language: ru\
Content-Type: text/html; charset=utf-8\
Accept-Ranges: bytes\
Connection: close\r\n\r\n<html><head><title>esp8266</title></head>\
<body><h1>uLuaNode sample WiFi</h1><hr>\
<font color="brown">Reset node for apply changes!<br>\
</font>Current mode is <b>'..ws..'</b><br><form action="/wifi.lua" method="GET">'
-- http://192.168.1.55/wifi.lsf?wm=3&staid=12&stapwd=34&apid=56&appwd=78 
if http.params and type(http.params.wm)=="string" then 
assert(loadstring(" local tab,FN \
tab,FN=... file.open(FN,'w+') file.writeline('return {')\
for k,v in pairs(tab) do \
 if type(k)~='string' then k=tostring(k) else k='\"'..k..'\"' end\
 if type(v)~='string' then v=tostring(v) else v='\"'..v..'\"' end\
 file.writeline(' ['..k..']='..v..',') end file.writeline('}') file.flush() file.close() \
"),"Err save")(http.params,"wifi.tab")
end 
http.answer=http.answer..lsf.t[1]..lsf.t[2]..lsf.t[3]..lsf.t[4]..lsf.t[5]..lsf.t[6]..lsf.t[7]..lsf.t[8]
lsf=nil --end works
return http.answer
