; Requires http://www.autoitscript.com/forum/topic/95595-ffau3-v0601b-10/
#Include <FF.au3>

If _FFConnect() Then
    While 1
        _FFFormSubmit(1, 'index', 'click')
        _FFLoadWait()
        Sleep(200)
    WEnd
EndIf
