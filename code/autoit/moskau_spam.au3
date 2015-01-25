Local $array[106] = [ _
    'Moskau', _
    'Fremd und geheimnisvoll', _
    'Türme aus rotem Gold', _
    'Kalt wie das Eis', _
    'Moskau', _
    'Doch wer dich wirklich kennt', _
    'Der weiß, ein Feuer brennt', _
    'In dir so heiß', _
    '', _
    'Kosaken hey hey hey hebt die Gläser hey', _
    'Natascha ha ha ha du bist schön ah ha', _
    'Towarisch hey hey hey auf das Leben hey', _
    'Auf Dein Wohl Bruder hey Bruder ho', _
    '', _
    'Moskau, Moskau', _
    'Wirf die Gläser an die Wand', _
    'Russland ist ein schönes Land', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Deine Seele ist so groß', _
    'Nachts da ist der Teufel los', _
    'Ha ha ha ha ha, hey', _
    '', _
    'Moskau, Moskau', _
    'Liebe schmeckt wie Kaviar', _
    'Mädchen sind zum küssen da', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Komm wir tanzen auf dem Tisch', _
    'Bis der Tisch zusammenbricht', _
    'Ha ha ha ha ha', _
    '', _
    'Moskau', _
    'Tür zur Vergangenheit', _
    'Spiegel der Zarenzeit', _
    'Rot wie das Blut', _
    'Moskau', _
    'Wer deine Seele kennt', _
    'Der weiß, die Liebe brennt', _
    'Heiß wie die Glut', _
    '', _
    'Kosaken hey hey hey hebt die Gläser hey', _
    'Natascha ha ha ha du bist schön ah ha', _
    'Towarisch hey hey hey auf die Liebe hey', _
    'Auf Dein Wohl Mädchen hey Mädchen ho', _
    '', _
    'Moskau, Moskau', _
    'Wirf die Gläser an die Wand', _
    'Russland ist ein schönes Land', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Deine Seele ist so groß', _
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
    'Väterchen dein Glas ist leer', _
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
    'Dein Herz schlägt stark und weit.', _
    'Es schlägt für reich und arm', _
    'In dieser Stadt.', _
    '', _
    'Kosaken hey hey hey hebt die Gläser hey', _
    'Natascha ha ha ha du bist schön ah ha', _
    'Towarisch hey hey hey auf das Leben hey', _
    'Auf Dein Wohl Bruder hey Bruder ho', _
    '', _
    'Moskau, Moskau', _
    'Wirf die Gläser an die Wand', _
    'Russland ist ein schönes Land', _
    'Ho ho ho ho ho, hey', _
    'Moskau, Moskau', _
    'Deine Seele ist so groß', _
    'Nachts da ist der Teufel los', _
    'Ha ha ha ha ha, hey', _
    '', _
    'Moskau, Moskau', _
    'Liebe schmeckt wie Kaviar', _
    'Mädchen sind zum küssen da', _
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
