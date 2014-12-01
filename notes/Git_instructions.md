## Génération des clés SSH ##

### Linux, Mac OS, Windows [Cygwin/Msysgit]

Au choix:
* http://git-scm.com/book/fr/Git-sur-le-serveur-G%C3%A9n%C3%A9ration-des-cl%C3%A9s-publiques-SSH
* https://help.github.com/articles/generating-ssh-keys#platform-windows

### Windows

1. Télécharger PuTTYgen (http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
2. Lancer PuTTYgen
3. Cocher SSH2-RSA
4. _Generate_ puis bouger la souris dans la fenêtre pendant la génération
5. Le passphrase est optionnel
6. Une fois terminé, _Conversions_ -> _Export OpenSSH key_
7. Répondre _Oui_ et enregistrer la clé privée
8. Me renvoyer la clé publique contenue dans la zone de texte

## Configuration de NetBeans ##

Dès que j'aurai ajouté la clé publique, il sera possible d’accéder au repo.

1. Une fois NetBeans lancé et sur la page d'accueil, parcourir le menu _Team_ -> _Git_ -> _Clone..._
2. _Repository URL_ -> L'url qu'on vous fournit genre `ssh://behindtheshell.fr:42022/projet.git`
3. _Username_ -> Dans la majorité des cas, ce sera `git`
4. Cocher _Private/Public key_
5. _Private Key File_ -> Le chemin de la clé privée
6. _Passphrase_ -> Le passphrase de la clé si défini
7. _Next_ puis _Yes_ s'il est demandé si on veut se connecter au serveur
8. _Select All_ si besoin puis _Next_
9. Indiquer le chemin ou sera cloné le projet dans le champs _Parent Directory_
10. _Finish_
