// ==UserScript==
// @name       Origins Return - Raid Mode
// @namespace  behindtheshell.fr
// @include    http://*.origins-return.fr/*_attaquer.php*
// @include    http://*.origins-return.fr/*_attaquer.php*
// @include    http://*.origins-return.fr/galaxie.php*
// @include    http://*.origins-return.fr/raid.php*
// @version    2.0
// @grant      none
// @require    http://code.jquery.com/jquery-1.11.2.min.js
// @require    https://gist.githubusercontent.com/arantius/3123124/raw/grant-none-shim.js
// ==/UserScript==

$(function () {
    if (document.URL.indexOf('galaxie.php', 0) != -1) { // Galactic sensors
        $('table:eq(2) tr').map(function (_, row) {
            var buttonsCell = $('td:eq(3)', row);

            if ($('td:eq(2)', row).text() != '-' && $('img', buttonsCell).length == 7) {
                var jsonCoord = JSON.stringify([
                    $('#galaxi').val(),
                    $('#system').val(),
                    $('td:eq(0)', row).text()
                ]);

                var portalButton = $('<a>');
                portalButton.attr('href', unescape("javascript:window.open('http://universdestiny.origins-return.fr/porte_attaquer.php', '" + jsonCoord + "'); void(0);"));
                portalButton.html('<img src="images/autres/raider.gif" title="Raid Portail" style="cursor: pointer; border: medium none; height: 17px; width: 17px;" align="absmiddle">');
                $('img:eq(0)', buttonsCell).replaceWith(portalButton);

                var fleetButton = $('<a>');
                fleetButton.attr('href', unescape("javascript:window.open('http://universdestiny.origins-return.fr/flotte_attaquer.php', '" + jsonCoord + "'); void(0);"));
                fleetButton.html('<img src="images/autres/batailler.gif" title="Raid Flotte" style="cursor: pointer; border: medium none; height: 17px; width: 17px;" align="absmiddle">');
                $('img:eq(1)', buttonsCell).replaceWith(fleetButton);

                var listButton = $('<img>');
                listButton.attr('title', 'Ajouter');
                listButton.attr('src', 'http://www.widgetop.com/images/AddWidgets.png');
                listButton[0].style.cssText = 'cursor:pointer;border:none;height:17px;';
                listButton.attr('align', 'absmiddle');
                listButton.insertBefore(portalButton);

                listButton.on('click', function () {
                    var targetList = JSON.parse(GM_getValue('TargetList', '[]'));

                    targetList.push([
                        $('#galaxi').val(),
                        $('#system').val(),
                        $('td:eq(0)', $(this).parents('tr')).text()
                    ]);

                    GM_setValue('TargetList', JSON.stringify(targetList));
                });
            }
        });
    }
    else if (document.URL.indexOf('_attaquer.php#list', 0) != -1) { // Direct attack
        var targetIndex = parseInt(GM_getValue('TargetIndex', 0));
        var attackForm = $('form:eq(1)');

        if ($('#galaxi').length) {
            var targetList = JSON.parse(GM_getValue('TargetList', '[]'));
            var attackConfig = JSON.parse(GM_getValue('AttackConfig', '[]'));

            if (!targetList[targetIndex]) {
                targetIndex = 0;
                GM_setValue('TargetIndex', targetIndex);
            }

            attackForm.attr('action', attackForm.attr('action') + '#list');
            $('#galaxi').val(targetList[targetIndex][0]);
            $('#system').val(targetList[targetIndex][1]);
            $('#position').val(targetList[targetIndex][2]);

            for (var i = 0; i < attackConfig.length; i++) {
                var attackField = $('#' + attackConfig[i][0]);

                if (attackField.length) {
                    attackField.val(config[i][1]);
                }
            }
        }
        else {
            attackForm.on('submit', function () {
                GM_setValue('TargetIndex', targetIndex + 1);
            });
        }
    }
    else if (document.URL.indexOf('_attaquer.php', 0) != -1 && window.name) { // Automatic attack
        if ($('#galaxi').length) {
            var target = JSON.parse(window.name);
            var attackConfig = JSON.parse(GM_getValue('AttackConfig', '[]'));

            $('#galaxi').val(target[0]);
            $('#system').val(target[1]);
            $('#position').val(target[2]);

            for (var i = 0; i < attackConfig.length; i++) {
                var attackField = $('#' + attackConfig[i][0]);

                if (attackField.length) {
                    attackField.val(attackConfig[i][1]);
                }
            }
        }
        else {
            $('form:eq(1)').on('submit', function () {
                window.name = '';
            });
        }
    }
    else if (document.URL.indexOf('raid.php', 0) != -1) { // Raid command control
        console.log(42);
        var masterDiv = $('form:eq(0)').parent().children();
        masterDiv.eq(-4).html('<a href="porte_attaquer.php#list">Raid Porte</a> - <a href="flotte_attaquer.php#list">Raid Flotte</a>');

        var middleDiv = masterDiv.eq(-2);
        middleDiv.html('');

        var targetListDiv = $('<div>');
        targetListDiv[0].style.cssText = 'width:50%;float:left;text-align:center;';
        targetListDiv.html('Liste des cibles<br />');
        targetListDiv.appendTo(middleDiv);

        var targetList = JSON.parse(GM_getValue('TargetList', '[]'));
        var targetListContent = [];

        for (var i = 0; i < targetList.length; ++i) {
            targetListContent.push(targetList[i].join());
        }

        var targetListArea = $('<textarea>');
        targetListArea[0].style.cssText = 'width:200px;height:300px;';
        targetListArea.html(targetListContent.join('\n'));
        targetListArea.appendTo(targetListDiv);

        var attackConfigDiv = $('<div>');
        attackConfigDiv[0].style.cssText = 'width:50%;float:right;text-align:center;';
        attackConfigDiv.html('Configuration de raid<br />');
        attackConfigDiv.appendTo(middleDiv);

        var attackConfig = JSON.parse(GM_getValue('AttackConfig', '[["mili_nbre",0],["gdremorqueur",0],["ptremorqueur",0]]'));
        var attackConfigContent = [];

        for (var i = 0; i < attackConfig.length; ++i) {
            attackConfigContent.push(attackConfig[i].join());
        }

        var attackConfigArea = $('<textarea>');
        attackConfigArea[0].style.cssText = 'width:200px;height:300px;';
        attackConfigArea.html(attackConfigContent.join('\n'));
        attackConfigArea.appendTo(attackConfigDiv);

        var bottomDiv = masterDiv.eq(-1);
        bottomDiv[0].style.cssText = 'text-align:center;';
        bottomDiv.html('Compteur de cibles<br />');

        var currentTarget = parseInt(GM_getValue('currentTarget', 0));

        var currentTargetInput = $('<input>');
        currentTargetInput.value = (!targetList[currentTarget]) ? 0 : currentTarget;
        currentTargetInput.type = 'text';
        currentTargetInput.appendTo(bottomDiv);

        $('<br><br>').appendTo(bottomDiv);

        var saveButton = $('<input>');
        saveButton.val('Enregistrer');
        saveButton.attr('type', 'button');
        saveButton.appendTo(bottomDiv);

        saveButton.on('click', function () {
            targetListContent = targetListArea.value.replace('\r', '\n').replace(/[\n]+/gi, '|').split('|');
            targetList = [];

            for (var i = 0; i < targetListContent.length; ++i) {
                targetList.push(targetListContent[i].split(','));
            }

            GM_setValue('TargetList', JSON.stringify(targetList));

            attackConfigContent = attackConfigArea.value.replace('\r', '\n').replace(/[\n]+/gi, '|').split('|');
            attackConfig = [];

            for (var i = 0; i < attackConfigContent.length; ++i) {
                attackConfig.push(attackConfigContent[i].split(','));
            }

            GM_setValue('AttackConfig', JSON.stringify(attackConfig));

            currentTarget = targetList[currentTargetInput.val()] ? currentTargetInput.val() : 0;
            currentTargetInput.val(currentTarget);
            GM_setValue('CurrentTarget', currentTarget);
        });
    }
});


/*
 if (document.URL.indexOf("galaxie.php", 0) > 0) {
 window.addEventListener('load', function (event) {
 var allTrs = document.getElementsByTagName('table')[2].getElementsByTagName('tr');

 for (var j = 0; j < allTrs.length; j++) {
 var allTds = allTrs[j].getElementsByTagName('td');
 var pIcons = allTds[3].getElementsByTagName('img');

 if (allTds[2].innerHTML != "-" && pIcons.length == 7) {
 var buttonPortal = document.createElement('a');
 buttonPortal.href = unescape("javascript:window.open('http://universdestiny.origins-return.fr/porte_attaquer.php', '" + JSON.stringify([document.getElementById('galaxi').value, document.getElementById('system').value, (j + 1)]) + "'); void(0);");
 buttonPortal.innerHTML = '<img src="images/autres/raider.gif" title="Raid Portail" style="cursor: pointer; border: medium none; height: 17px; width: 17px;" align="absmiddle">';
 pIcons[0].parentNode.replaceChild(buttonPortal, pIcons[0]);

 var buttonFleet = document.createElement('a');
 buttonFleet.href = unescape("javascript:window.open('http://universdestiny.origins-return.fr/flotte_attaquer.php', '" + JSON.stringify([document.getElementById('galaxi').value, document.getElementById('system').value, (j + 1)]) + "'); void(0);");
 buttonFleet.innerHTML = '<img src="images/autres/batailler.gif" title="Raid Flotte" style="cursor: pointer; border: medium none; height: 17px; width: 17px;" align="absmiddle">';
 pIcons[1].parentNode.replaceChild(buttonFleet, pIcons[1]);

 var listButton = document.createElement('img');
 listButton.title = 'Ajouter';
 listButton.src = 'http://www.widgetop.com/images/AddWidgets.png';
 listButton.style.cssText = 'cursor:pointer;border:none;height:17px;';
 listButton.align = 'absmiddle';
 buttonPortal.parentNode.insertBefore(listButton, buttonPortal);
 listButton.addEventListener('click', function (event) {
 var list = JSON.parse(GM_getValue('List', '[]'));
 list.push([document.getElementById('galaxi').value, document.getElementById('system').value, this.parentNode.parentNode.getElementsByTagName('td')[0].innerHTML])
 GM_setValue('List', JSON.stringify(list));
 }, true);
 }
 }

 event.preventDefault();
 event.stopPropagation();
 }, true);
 }
 else if (document.URL.indexOf('_attaquer.php#list', 0) > 0) {
 var id = GM_getValue('Id', 0);
 document.forms[1].action = document.forms[1].action + '#list';

 if (document.getElementById('galaxi')) {
 var list = JSON.parse(GM_getValue('List', '[]'));
 var config = JSON.parse(GM_getValue('Config', '[]'));

 if (!list[id]) {
 id = 0;
 GM_setValue('Id', 0);
 }

 document.getElementById('galaxi').value = list[id][0];
 document.getElementById('system').value = list[id][1];
 document.getElementById('position').value = list[id][2];

 for (var i = 0; i < config.length; i++) {
 if (document.getElementById(config[i][0]))
 document.getElementById(config[i][0]).value = config[i][1];
 }
 }
 else {
 document.forms[1].addEventListener('submit', function (event) {
 GM_setValue('Id', parseInt(id) + 1);
 }, true);
 }
 }
 else if (document.URL.indexOf('_attaquer.php', 0) > 0 && window.name != '') {
 if (document.getElementById('galaxi')) {
 var coord = JSON.parse(window.name);
 var config = JSON.parse(GM_getValue('Config', '[]'));

 document.getElementById('galaxi').value = coord[0];
 document.getElementById('system').value = coord[1];
 document.getElementById('position').value = coord[2];

 for (var i = 0; i < config.length; i++) {
 if (document.getElementById(config[i][0]))
 document.getElementById(config[i][0]).value = config[i][1];
 }
 }
 else {
 document.forms[1].addEventListener('submit', function (event) {
 window.name = '';
 }, true);
 }
 }
 else if (document.URL.indexOf('raid.php', 0) > 0) {
 var id = GM_getValue('Id', 0);
 var list = JSON.parse(GM_getValue('List', '[]'));
 var config = JSON.parse(GM_getValue('Config', '[["mili_nbre",0],["gdremorqueur",0],["ptremorqueur",0]]'));
 var showList = [];
 var showConfig = [];

 var parentDiv = document.forms[0].parentNode;

 parentDiv.childNodes[parentDiv.childNodes.length - 5].innerHTML = '<a href="porte_attaquer.php#list">Raid Porte</a> - <a href="flotte_attaquer.php#list">Raid Flotte</a>';

 //===
 var thisDiv = parentDiv.childNodes[parentDiv.childNodes.length - 2];
 thisDiv.innerHTML = '';

 var leftChildDiv = document.createElement('div');
 leftChildDiv.style.cssText = 'width:50%;float:left;text-align:center;';
 leftChildDiv.innerHTML = 'Liste des cibles<br />';
 thisDiv.appendChild(leftChildDiv);

 var listArea = document.createElement('textarea');
 listArea.style.cssText = 'width:200px;height:300px;';
 for (var i = 0; i < list.length; i++)
 showList.push(list[i].join());
 listArea.innerHTML = showList.join('\n');
 leftChildDiv.appendChild(listArea);

 var rightChildDiv = document.createElement('div');
 rightChildDiv.style.cssText = 'width:50%;float:right;text-align:center;';
 rightChildDiv.innerHTML = 'Configuration de raid<br />';
 thisDiv.appendChild(rightChildDiv);

 var configArea = document.createElement('textarea');
 configArea.style.cssText = 'width:200px;height:300px;';
 for (var i = 0; i < config.length; i++)
 showConfig.push(config[i].join());
 configArea.innerHTML = showConfig.join('\n');
 rightChildDiv.appendChild(configArea);
 //===

 //===
 var headDiv = parentDiv.childNodes[parentDiv.childNodes.length - 1];
 headDiv.style.cssText = 'text-align:center;';
 headDiv.innerHTML = 'Compteur de cibles<br />';

 var idInput = document.createElement('input');
 idInput.value = (!list[id]) ? 0 : id;
 idInput.type = 'text';
 headDiv.appendChild(idInput);

 headDiv.appendChild(document.createElement('br'));
 headDiv.appendChild(document.createElement('br'));

 var saveButton = document.createElement('input');
 saveButton.value = 'Enregistrer Tout';
 saveButton.type = 'button';
 headDiv.appendChild(saveButton);
 saveButton.addEventListener('click', function (event) {
 showList = listArea.value.replace('\r', '\n').replace(/[\n]+/gi, '|').split('|');
 list = [];
 for (var i = 0; i < showList.length; i++)
 list.push(showList[i].split(','));
 GM_setValue('List', JSON.stringify(list));

 showConfig = configArea.value.replace('\r', '\n').replace(/[\n]+/gi, '|').split('|');
 config = [];
 for (var i = 0; i < showConfig.length; i++)
 config.push(showConfig[i].split(','));
 GM_setValue('Config', JSON.stringify(config));

 id = (!list[idInput.value]) ? 0 : idInput.value;
 idInput.value = id;
 GM_setValue('Id', id);
 }, true);
 //===
 }
 */
