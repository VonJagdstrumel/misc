function pause()
    term.setCursorBlink(true)
    print("Appuyez sur Entrée pour continuer...")
    while true do
        local _, nKey = os.pullEvent("key")
        if nKey == 28 then
            break
        end
    end
    term.setCursorBlink(false)
end

function readKey()
    term.setCursorBlink(true)
    local _, nKey = os.pullEvent("key")
    term.setCursorBlink(false)
    return nKey
end

function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

function centerPrint(sText)
    local nWidth = term.getSize()
    local _, y = term.getCursorPos()
    term.setCursorPos(math.ceil(nWidth / 2 - sText:len() / 2), y)
    print(sText)
end

function readFile(sFilePath)
    local file = fs.open(sFilePath, "r")
    local sContent = file.readAll()
    file.close()
    return sContent
end
