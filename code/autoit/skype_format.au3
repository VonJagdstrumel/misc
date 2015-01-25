Local $list[2] = ["_", "█"]
$percent = 0

Func Terminate()
    Exit
EndFunc

HotKeySet("{PAUSE}", "Terminate")
Sleep(5000)

While $percent <= 100
    $nbBlocks = Round($percent / 5)
    $nbSpaces = 20 - $nbBlocks
    $progress = ""

    For $i = 1 To 20
        If $i > $nbBlocks Then
            $progress = $progress & $list[0]
        Else
            $progress = $progress & $list[1]
        EndIf
    Next

    $daString = "Formatting drive C: ... " & $progress & " " & $percent & "%"
    $percent = $percent + 1

    ClipPut($daString)
    Send("{UP}^a^v{Enter}")
    Sleep(Random(0, 1000, 1))
WEnd

ClipPut("Formatting drive C: ... OK NIGGAH, TEH SHIT IZ DONE!")
Send("{UP}^a^v{Enter}")
