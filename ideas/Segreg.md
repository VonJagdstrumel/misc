# Segreg #

## Composants principaux ##

Consiste en un réseau maillé de systèmes permettant de recenser, surveiller, configurer, utiliser et répliquer des services.

### Démon de présence - protond ###

#### Noyau ####

Permet à une machine compatible avec cette architecture d'annoncer sa présence sur un réseau restreint grace à des datagrammes UDP multicast. Les autres pairs répondent à leur tour dans ce même but mais avec des datagrammes UDP unicast.

Les pairs sont repertoriés en mémoire dans une CuncurrentHashMap maintenue à jour à l'aide de timeout et de relance de datagrammes.

Un flux TCP local permet à segregd de récupérer la liste des pairs depuis la Map.

L'ensemble des communications applicatives se font au format JSON.

#### Extension possible ####

Ne plus simplement lister les pairs disponibles sur le réseau. Echanger les services disponibles en même temps qu'indiquer la présence des pairs. Centraliser en utilisant la capacité native d'échange d'information régulier, cohérent et centralisé de protond.

### Service d'aggrégation - segregd ###

#### Noyau ####

Un système de modules permet de consulter et d'agir avec les services/pairs connus sur le réseau. De préférence, chaque module doit gérer un service spécifique. Toutes ces informations sont mises à disposition via une interface http publique. (API ou dashboard?)

#### Configuration ####

La configuration de l'architecture se fera via la persistance en base de données (MySQL/PostgreSQL/SQLite) des paramètres. Le noyau et chaque module auront leurs paramètres propres.

#### Modules ####

##### Apache Httpd #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Affichage et modification de la configuration
* Récapitulatif des vhosts
* Ports ouverts
* Affichage des modules activés
* Accès aux logs
* Stop/Restart
* Annuaire des webservices

##### Nginx #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Accès aux logs
* Récapitulatif des servers
* Ports ouverts
* Annuaire des webservices
* Modules activés

##### MySQL #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Affichage et modification de la configuration
* Stop/Restart
* Accès phpmyadmin
* Récapitulatif des bases et utilisateurs
* Affichage des moteurs activés
* Ports ouverts
* Accès aux logs

##### Named/BIND #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Accès aux logs
* Ports ouverts
* Récapitulatif des zones
* Stop/Restart
* Affichage et modification de la configuration

##### Postfix #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Accès aux logs
* Ports ouverts

##### BTSync #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification du fichier de configuration
* Accès aux logs
* Accès WebUI
* Ports ouverts
* Récapitulatif des répertoires et modification/réplication

##### System #####

* Usage CPU/load average.
* Processus/services
* Usage mémoire (RAM + Swap)
* Usage périphériques de stockage
* Interfaces réseau
* Ping (pair à pair et vers 8.8.8.8)
* Ports LISTEN et connexions
* Uptime
* OS
* Batterie
* Utilisateurs logués
* Affichage/modification hosts
* Shell
* Liste (et modification?) des règles netfilter

##### µTorrent #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification du fichier de configuration
* Accès WebUI
* Ports ouverts
* Accès aux logs
* Récapitulatif des torrents

##### FreeLan #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Ports ouverts
* Accès aux logs
* Recapitulatif des liaisons

##### OpenVPN #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Ports ouverts
* Accès aux logs
* Récapitulatif des liaisons

##### Polipo/Privoxy #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Ports ouverts
* Accès aux logs

##### Tor #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Ports ouverts
* Accès aux logs
* Annuaire des services cachés

##### NTP #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Ports ouvers
* Accès aux logs
* Liste des serveurs

##### SSH #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Ports ouverts
* Accès aux logs
* Gestion des clés

##### FTP #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de la configuration
* Ports ouverts
* Accès aux logs
* Gestion des utilisateurs
* Gestion des repertoires

##### DHCP #####

* Affichage des informations du processus
	* PID
	* Uptime
	* Memory usage
	* User/Group
	* Nice/Priorité
	* Répertoire de travail
	* Commande d'execution
* Stop/Restart
* Affichage et modification de ma configuration
* Ports ouverts
* Accès aux logs
* Gestion des subnet
* Liste des baux
