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
     file.flush(dest)
     file.close(dest)
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
     end
end

if file.open("new.lua","r") then -- update exist
     file.close()
     copyfile( "new.lua", "main.lua")
     file.remove("new.lua")
end


if file.open("main.lua", "r") then
     file.close()
     dofile("main.lua")
else
     print(" file \'main.lua\' not found!")
end
