local serverId = 4
local running = 1

rednet.open("right")
rednet.open("left")
rednet.open("back")

function mailCount()
	rednet.send(serverId, ":count")
	local m  = rednet.receiveFrom(serverId, 10)
	return m
end

function mailList()
	misc.clearScreen()

	rednet.send(serverId, ":list")
	local m  = rednet.receiveFrom(serverId, 10)
	local mailTable = textutils.unserialize(m)
	print("From\t\tSubject\t\tUnread")
	for _, mail in ipairs(mailTable) do
		unreadMark = ""
		if mail[3] == 1 then
			unreadMark = "X"
		end
		print(mail[1] .. "\t\t" .. mail[2] .. "\t\t" .. unreadMark)
	end
	print()
	print(">> 1: Read - 2: Write - 3: Delete - 4: Quit")
	while running == 1 do
		choice = misc.readKey()
		if choice == 79 then
			print()
		elseif choice == 80 then
			mailSend()
		elseif choice == 81 then
			print()
		elseif choice == 75 then
			running = 0
		end
	end
end

function mailSend()
	misc.clearScreen()

	local mail = {-1, "", ""}

	while mail[1] < 0 do
		write("Recipent ID: ")
		mail[1] = tonumber(read())
	end
	write("Object: ")
	mail[2] = read()

	print("Please write your message. Finish with a single dot.")
	repeat
		line = read()
		mail[3] = mail[3] .. line
	until line == "."

	print("Sending...")
	rednet.send(serverId, ":send:" .. textutils.serialize(mail))
	local m  = rednet.receiveFrom(serverId, 10)
	if message == nil then
		drawScreen("Unable to send email!")
	else
		drawScreen("Sent!")
	end
end

function drawScreen(note)
	misc.clearScreen()
	misc.cPrint("Rednet Email Manager")
	print()
	misc.cPrint(mailCount() .. " new mail(s)")
	print()
	print(note or "")
	print()
	print(">> 1: Inbox - 2: Write - 3: Quit")
end

drawScreen()
while running == 1 do
	choice = misc.readKey()
	if choice == 79 then
		mailList()
	elseif choice == 80 then
		mailSend()
	elseif choice == 81 then
		running = 0
	end
end
misc.clearScreen()
