rednet.open("right")
rednet.open("left")
rednet.open("back")

while true do
	id, message = rednet.receive()
	if strutils.startsWith(message, ":") then
		splitted = strutils.separate(message, ":")
		mailFile = misc.readFile(id .. ".srz")
		mailTable = textutils.unserialize(mailFile)

		if splitted[2] == "count" then
			unreadCount = 0
			for _, rawMail in ipairs(mailTable) do
				if rawMail[4] == 1 then
					unreadCount = unreadCount + 1
				end
			end
			rednet.send(id, tostring(unreadCount))
		elseif splitted[2] == "list" then
			listTab = {}
			for _, rawMail in ipairs(mailTable) do
				mail = {rawMail[1], rawMail[2], rawMail[4]}
				table.insert(listTab, mail)
			end
			rednet.send(id, textutils.serialize(listTab))
		elseif splitted[2] == "read" then
			rawMail = mailTable[splitted[3]]
			mail = {rawMail[1], rawMail[2], rawMail[3]}
			rednet.send(id, textutils.serialize(mail))
			-- Write that we've read mail
		elseif splitted[2] == "send" then
			print("Received send!")
			-- Read dest file
			-- Append mail to table
			-- Write back table
		elseif splitted[2] == "delete" then
			if mailTable[splitted[3]] ~= nil then
				table.remove(mailTable, splitted[3])
			end
			-- Write back table to file
		end
	end
end
