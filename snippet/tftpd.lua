--[==[ Start:
tftpd=loadfile("tftpd.lua")():start()
-- Stop:
tftpd:stop() tftpd=nil

unix:
    $ tftp 10.10.1.125
    tftp> mode binary
    tftp> put mybinary.dat
    Sent 6263 bytes in 5.5 seconds
    tftp> 

Windows:
    tftp -i 10.10.1.125 put myfile.dat
]==]

return({
urv=nil,
socket=nil,
start=function(this)
	local state=0 -- 0 = idle 1 = put request in progress
	local filename,blocks

	local function tohex(str)
    		str=tostring(str)
    		return (str:gsub('.', function (c)
        		return string.format('%02X', string.byte(c))
    		end))
	end

	local function senderr(conn,msg)
		conn:send(string.char(00,05,00,00) .. msg .. string.char(00))
	end

	local function sendack(conn,block)
		conn:send(string.char(00,04) .. string.char(00,block) )
	end

	local function abort(conn,msg)
		senderr(conn,msg)
		if state == 1 then
			file.close()
			file.remove(filename)
		end
		state = 0
		print("ABORT:" .. msg)
	end

	this.urv=net.createServer(net.UDP) 
	this.urv:on("receive",function(conn,payload) 
		this.socket=conn
		-- print(tohex(payload:sub(1,20))) 
		local major,minor=payload:byte(1,2)
		if state == 0 then
			if minor == 2 then
				filename=payload:match("^..(.-)%z")
				print("opening " .. filename)
				file.open(filename,"w+")
				state = 1 -- receiving
				blocks = 0
				sendack(conn,0)
			else
				abort(conn,"Unsupported")
			end
		elseif state == 1 then
			if minor == 3 then
				local major,minor,blockh,block,data=payload:match("^(.)(.)(.)(.)(.*)$")
				local rblock = block:byte(1)
				if rblock > 253 then
					abort(conn,"sorry, too big for me")
				else
					blocks = blocks + 1
					if rblock == blocks then
				 		print(string.format("Receiving Block %i ",block:byte(1) ) )
						file.write(data)
						sendack(conn,block:byte(1))
						if #payload - 4 < 512 then
							print("closing " .. filename)
							file.close()
							state = 0
						end
					else
						if rblock > blocks then
							abort(conn,"Sorry. missed something. Try again")	
						else
							print("Skipping duplicate")
							blocks = blocks - 1
							sendack(conn,blocks)
						end
					end
				end
			else
				abort(conn,"unexpected command. please retry.")
			end
		end
	end) 
	this.urv:listen(69) 
end,
stop=function(this)
	if this.socket then this.socket:close() this.socket=nil end
	this.urv:close() this.urv=nil
end
})
