// ==UserScript==
// @name           UltraHolocaust3 - GreaseMonkey Edition
// @namespace      http://bono.comyr.com/
// @description    Sa va péter !
// @version        3.5a
// @include        http://*my3d-city.com/diplomatie.php*
// @author         Bono
// ==/UserScript==

/*
Changelog
- 1.0 : Première version en PHP
- 1.1 : Permet l'envoi des missile sur liste personalisée
- 2.0 : Support multi-utilisateur
- 3.0 : Passage en Javascript support Greasemonkey
- 3.1 : Envois simultanés
- 3.2 : Envois a intervales réguliers de 1min 40
- 3.3 : Affichage de l'état
- 3.4 : Intervale aléatoire entre 1min 30 et 1min 40
- 3.5 : Bouton d'annulation
- 3.5a : Boite de dialogue lorsque c'est fini
*/

var supprimed = document.getElementsByName("bombarder")[0];
var container = document.createElement("div");
var xhr_object;
var enablecancel = 0;
var countdown;
var total;
var actual;

if(window.XMLHttpRequest)
	xhr_object = new XMLHttpRequest();
else if(window.ActiveXObject)
	xhr_object = new ActiveXObject("Microsoft.XMLHTTP");
else {
	alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
	throw new Error();
}

function sendtimer(ville) {
	xhr_object.open("POST", "diplomatie.php", true);
	xhr_object.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhr_object.send("boomville="+ville);
}

function main() {
	var dastitle = document.createElement('strong');
	dastitle.innerHTML = 'UltraHolocaust3<br>';

	var dasform = document.createElement('form');
	dasform.setAttribute('method', 'post');
	dasform.setAttribute('action', 'diplomatie.php');

	var dasarea = document.createElement('textarea');
	dasarea.setAttribute('cols', '20');
	dasarea.setAttribute('rows', '10');
	dasarea.setAttribute('id', 'cboomville2');
	dasarea.value = GM_getValue('UH_List', null);

	var dasinput = document.createElement('input');
	dasinput.setAttribute('type', 'button');
	dasinput.setAttribute('value', 'Lancer');

	var dascancel = document.createElement('input');
	dascancel.setAttribute('type', 'button');
	dascancel.setAttribute('value', 'Annuler');

	dascancel.addEventListener('mousedown', function(event) {
		if(enablecancel == 0) {
			return;
		}
		status.innerHTML = 'Etat : Annulé...';
		enablecancel = 0;
		window.clearTimeout(countdown);
		return;
	},
	true
	);

	var dashelp = document.createElement('input');
	dashelp.setAttribute('type', 'button');
	dashelp.setAttribute('value', 'Aide');

	dashelp.addEventListener('mousedown', function(event) {
		alert('Entrez la liste des villes ciblées en les séparant au choix, par :' + "\n" +
		'- un espace;' + "\n" +
		'- une virgule;' + "\n" +
		'- un saut de ligne.');
		return;
	},
	true
	);

	var dasave = document.createElement('input');
	dasave.setAttribute('type', 'button');
	dasave.setAttribute('value', 'Enregistrer');

	dasave.addEventListener('mousedown', function(event) {
		GM_setValue('UH_List', dasarea.value);
		alert('Liste enregistrée !');
		return;
	},
	true
	);

	var dasclear = document.createElement('input');
	dasclear.setAttribute('type', 'button');
	dasclear.setAttribute('value', 'Vider la liste');

	dasclear.addEventListener('mousedown', function(event) {
		dasarea.value = null;
		return;
	},
	true
	);

	var br1 = document.createElement('br');
	var br2 = document.createElement('br');
	var br3 = document.createElement('br');

	var status = document.createElement('em');
	status.innerHTML = 'Etat : Inactif...';

	dasform.appendChild(dastitle);
	dasform.appendChild(dasarea);
	dasform.appendChild(br1);
	dasform.appendChild(dasinput);
	dasform.appendChild(dascancel);
	dasform.appendChild(dashelp);
	dasform.appendChild(br2);
	dasform.appendChild(dasave);
	dasform.appendChild(dasclear);
	dasform.appendChild(br3);
	dasform.appendChild(status);

	supprimed.parentNode.insertBefore(dasform, supprimed);
	supprimed.parentNode.removeChild(supprimed);

	dasinput.addEventListener('mousedown', function(event) {
		if(dasarea.value.length == 0) {
			alert("Aucune cible définie !");
			return;
		}

		if(enablecancel == 1) {
			return;
		}

		var list = dasarea.value;
		var parsedlist = list.replace(/(\||,|\r\n|\s)/gi,",");
		var onreturn = parsedlist.split(',');
		var tosend;
		var timing = 0;
		var ville;

		enablecancel = 1;

		for (tosend in onreturn){
			countdown = window.setTimeout(
				( function(ville) {
					return function() {
						var underbombing = parseInt(ville) + 1;
						var suivant = parseInt(ville) + 2;
						xhr_object.open("POST", "diplomatie.php", true);
						xhr_object.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
						xhr_object.send("boomville="+onreturn[ville]);

						if(onreturn.length == underbombing) {
							status.innerHTML = 'Etat : Terminé ! ' + underbombing + ' villes bombardée(s)...';
							alert('Terminé ! ' + underbombing + ' villes bombardée(s) !');
							enablecancel = 0;
							return;
						}

						status.innerHTML = 'Etat : ' + underbombing + '/' + onreturn.length + ' villes bombardée(s) !<br>Prochaine ville : ' + onreturn[underbombing];
					};
				} ) (tosend),
				timing
			);

			timing = timing + 300000 + (Math.round(Math.random() * 10) * 1000);
		}
		return;
	},
	true
	);
}

main();
