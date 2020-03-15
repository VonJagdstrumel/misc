mon = peripheral.wrap("right")

function printStringCentre(sString)
	_, y = mon.getCursorPos()
	width = mon.getSize()
	mon.setCursorPos(math.ceil(width / 2 - sString:len() / 2), y)
	mon.write(sString)
end

function scrollText(tStrings, nRate)
	nRate = nRate or 5
	if nRate < 0 then
		error("rate must be positive")
	end

	width = mon.getSize()
	_, y = mon.getCursorPos()
	sText = ""
	for n = 1, #tStrings do
		sText = sText .. tostring(tStrings[n])
		sText = sText .. "          "
	end
	sString = "     "
	if width / string.len(sText) < 1 then
		nStringRepeat = 3
	else
		nStringRepeat = math.ceil(width / string.len(sText) * 3)
	end
	for n = 1, nStringRepeat do
		sString = sString .. sText
	end
	while true do
		for n = 1, string.len(sText) do
			sDisplay = string.sub(sString, n, n + width - 1)
			mon.clearLine()
			mon.setCursorPos(1, y)
			mon.write(sDisplay)
			sleep(1 / nRate)
		end
	end
end

tScrollText = {}
tScrollText[1] = "BREAKING NEWS"
tScrollText[2] = "Giant cookies falling from sky"
tScrollText[3] = "Trololoman sings along!"
tScrollText[4] = "OMFG! WTF IZ GOIN ON?!"

mon.clear()
mon.setCursorPos(1, 2)
printStringCentre("--- LOOK HERE MOFO ---")
mon.setCursorPos(1, 4)
scrollText(tScrollText, 10)