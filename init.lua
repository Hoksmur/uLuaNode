-- init.lua 
local DefPin = 4 --gpio2

local function copyfile( src, dest)
 print("COPY "..src.." to "..dest)
 file.remove(dest)
 file.open(src, "r")
 local bufout; bufout = ""
 repeat
     buf = file.readline()
     if buf then
      bufout = bufout..buf
 end
 until not buf
 file.close()
 file.open(dest, "w+")
 file.writeline(bufout)
 file.flush(dest) file.close(dest)
end

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

gpio.mode(DefPin, gpio.INPUT)
if  gpio.read(DefPin) == gpio.LOW then --button pressed on start
 local timeend; local tlast
 timeend = tmr.now() + 3000000 -- 3 seconds
 repeat
     tmr.wdclr()
     print("nop" ) -- ESP-01, blue LED on
     tlast = timeend - tmr.now()
 until ( tlast < 0 )
 if gpio.read(DefPin) == gpio.HIGH then --button released
     print("loading \"defailt.lua\"...")
     copyfile("default.lua", "main.lua")
     local str,apmac,stamac
     apmac=wifi.ap.getmac()
     stamac=wifi.sta.getmac()
     str='return {["wm"]="2",["apid"]="ESP_'..apmac..'",["appwd"]="'..apmac
     str=str..'",["staid"]="STA_'..stamac..'",["stapwd"]="' ..stamac..'",}'
     file.open("wifipar.tab","w+")
     file.writeline(str) file.flush() file.close() 
     str=dofile("wifipar.tab")
     wifi.ap.config({['ssid']=str.apid, ['pwd']=str.appwd})
 end
end

if file.open("new.lua","r") then -- update exist
 file.close()
 copyfile( "new.lua", "main.lua")
 file.remove("new.lua")
end

if file.open("main.lua", "r") then
     file.close()
     dlyld("main.lua") -- wait wifi, then start it
else print(" file \'main.lua\' not found!") end
