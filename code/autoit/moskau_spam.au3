Local $array[106] = [ _
    'Moskau', _
    'Fremd und geheimnisvoll', _
    'T�rme aus rotem Gold', _
    'Kalt wie das Eis', _
    'Moskau', _
    'Doch wer dich wirklich kennt', _
    'Der wei�, ein Feuer brennt', _
    'In dir so hei�', _
    '', _
    'Kosaken hey hey hey hebt die Gl�ser hey', _
    'Natascha ha ha ha du bist sch�n ah ha', _
    'Towarisch hey hey hey auf das Leben hey', _
    'Auf Dein Wohl Bruder hey Bruder ho', _
    '', _
    'Moskau, Moskau', _
    'Wirf die Gl�ser an die Wand', _
    'Russland ist ein sch�nes Land', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Deine Seele ist so gro�', _
    'Nachts da ist der Teufel los', _
    'Ha ha ha ha ha, hey', _
    '', _
    'Moskau, Moskau', _
    'Liebe schmeckt wie Kaviar', _
    'M�dchen sind zum k�ssen da', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Komm wir tanzen auf dem Tisch', _
    'Bis der Tisch zusammenbricht', _
    'Ha ha ha ha ha', _
    '', _
    'Moskau', _
    'T�r zur Vergangenheit', _
    'Spiegel der Zarenzeit', _
    'Rot wie das Blut', _
    'Moskau', _
    'Wer deine Seele kennt', _
    'Der wei�, die Liebe brennt', _
    'Hei� wie die Glut', _
    '', _
    'Kosaken hey hey hey hebt die Gl�ser hey', _
    'Natascha ha ha ha du bist sch�n ah ha', _
    'Towarisch hey hey hey auf die Liebe hey', _
    'Auf Dein Wohl M�dchen hey M�dchen ho', _
    '', _
    'Moskau, Moskau', _
    'Wirf die Gl�ser an die Wand', _
    'Russland ist ein sch�nes Land', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Deine Seele ist so gro�', _
    'Nachts da ist der Teufel los', _
    'Ha ha ha ha ha, hey', _
    '', _
    'Moskau...', _
    'Lala lala lala la, lala lala lala la', _
    'Ho ho ho ho ho, hey', _
    'Moskau...', _
    'Lala lala lala la, lala lala lala la', _
    'Ha ha ha ha ha', _
    'Oh, oh oh oh, oh, oh oh oh, oh, oh oh oh oh...', _
    'Moskau! Moskau!', _
    '', _
    'Moskau, Moskau', _
    'Wodka trinkt man pur und kalt', _
    'Das macht hundert Jahre alt', _
    'ha ha ha ha ha, hey', _
    'Moskau, Moskau', _
    'V�terchen dein Glas ist leer', _
    'Doch im Keller ist noch mehr', _
    'Ha ha ha ha ha', _
    '', _
    'Moskau... Moskau...', _
    '', _
    'Moskau', _
    'Alt und doch jung zugleich,', _
    'In aller Ewigkeit', _
    'Stehst du noch da.', _
    'Moskau', _
    'Dein Herz schl�gt stark und weit.', _
    'Es schl�gt f�r reich und arm', _
    'In dieser Stadt.', _
    '', _
    'Kosaken hey hey hey hebt die Gl�ser hey', _
    'Natascha ha ha ha du bist sch�n ah ha', _
    'Towarisch hey hey hey auf das Leben hey', _
    'Auf Dein Wohl Bruder hey Bruder ho', _
    '', _
    'Moskau, Moskau', _
    'Wirf die Gl�ser an die Wand', _
    'Russland ist ein sch�nes Land', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Deine Seele ist so gro�', _
    'Nachts da ist der Teufel los', _
    'Ha ha ha ha ha, hey', _
    '', _
    'Moskau, Moskau', _
    'Liebe schmeckt wie Kaviar', _
    'M�dchen sind zum k�ssen da', _
    'Ha ha ha ha ha', _
    'Moskau, Moskau', _
    'Komm wir tanzen auf dem Tisch', _
    'Bis der Tisch zusammenbricht', _
    'Ha ha ha ha ha, hey!' _
]
$index = 0

Func Terminate()
    Exit
EndFunc

HotKeySet("{PAUSE}", "Terminate")
Sleep(5000)

While $index < UBound($array)
    $index = $index + 1
    ClipPut($array[$index])
    ;Send("{UP}^a^v{Enter}") ;Skype
    Send("+{Enter}^v{Enter}") ;Dota
    Sleep(2000)
WEnd
