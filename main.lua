--main.lua
print("main.lua started.")
local lfile,wst

local function dlyld(fname)
  tmr.alarm(6,500,1, function()
   local cstat; cstat=wifi.sta.status()
   if cstat~=1 then
     tmr.alarm(6,100,0, function()
     if file.open(fname,"r") then
       file.close() dofile(fname) else
       print("not found:", fname) end
     end) end end)
end 

lfile=file.list()
print("wifi STA state is: ", wifi.sta.status())

-- change condition to 'false' if you don't want 'safe mode'
if lfile["err.flg"] then
 --dont touch wifi.tab and up AP
 wifi.setmode(2)
 wifi.ap.config({["ssid"]="esp_cfgerr_12345678",
 ["pwd"]=wifi.ap.getmac()})
 file.remove("err.flg")
else 
 wst=wifi.sta.status()
 if wifi.getmode()==1 then
  --status ~=1, see 'init.lua'
   if wst==2 or wst==4 then --wrong_pwd or conn_fault
    file.open("err.flg","w+") file.close()
    node.restart()
   elseif wst==0 then --node doesn't trying connect
    wifi.sta.autoconnect(1)
    wifi.sta.connect()
    tmr.delay(10000000) --10 sec
   end
 end
  if lfile["wupdate.flg"] then
   wtab=dofile("wifi.tab")
   wifi.sta.config(wtab.staid,wtab.stapwd)
   wifi.ap.config({["ssid"]=wtab.apid,["pwd"]=wtab.appwd})
   wifi.setmode(tonumber(wtab.wm) )
  end
end
require("http")
