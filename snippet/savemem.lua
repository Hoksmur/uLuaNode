-- posible - way to save mem
s=[=[ local tab,FN print('X',...)
tab,FN=... file.open(FN,'w+') file.writeline('return {')
for k,v in pairs(tab) do
 if type(k)~='string' then k=tostring(k) else k='"'..k..'"' end
 if type(v)~='string' then v=tostring(v) else v='"'..v..'"' end
 file.writeline(' ['..k..']='..v..',') end 
file.writeline('}') file.flush() file.close()]=]
fx1=loadstring(s)
print(#s, #string.dump(fx1))