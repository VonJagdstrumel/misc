local password = "trollface"

while true do
	misc.clearScreen()
	print("<<Restricted area>>")
	write("Password: ")
	local input, signal = misc.digiLock()
	if input == password or signal == 1 then
		redstone.setOutput("left", true)
		redstone.setOutput("right", true)
		misc.pause()
		redstone.setOutput("left", false)
		redstone.setOutput("right", false)
	else
		print("Incorrect Password!")
		sleep(1)
	end
end
