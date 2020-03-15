os.pullEvent = os.pullEventRaw
local password = "trollface"

misc.clearScreen()
print(os.version())
write("Password: ")
local input = read("*")
if input == password then
	misc.clearScreen()
	print(os.version())
else
	print("Incorrect password!")
	sleep(1)
	os.shutdown()
end
