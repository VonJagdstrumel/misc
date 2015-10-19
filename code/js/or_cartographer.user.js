// ==UserScript==
// @name       Origins Return - Cartographer
// @namespace  behindtheshell.fr
// @include    http://*.origins-return.fr/galaxie.php*
// @version    2.0
// @grant      none
// @require    http://code.jquery.com/jquery-1.11.2.min.js
// @require    https://gist.githubusercontent.com/arantius/3123124/raw/grant-none-shim.js
// ==/UserScript==

/**
 *
 * @param {String} playerState
 * @param {String} planetName
 * @param {String} allianceTag
 * @returns {PlanetDataStruct}
 */
function PlanetDataStruct(playerState, planetName, allianceTag) {
    this.playerState = playerState || '';
    this.planetName = planetName || '';
    this.allianceTag = allianceTag || '';
}

/**
 *
 * @param {HTMLImageElement} imageElement
 * @returns {undefined}
 */
PlanetDataStruct.prototype.stateFromImage = function (imageElement) {
    var ctx = document.createElement('canvas').getContext('2d');
    ctx.canvas.width = imageElement.width;
    ctx.canvas.height = imageElement.height;
    ctx.drawImage(imageElement, 0, 0);
    var imageData = ctx.getImageData(0, 0, imageElement.width, imageElement.height).data;
    var size = 0;
    var color = [0, 0, 0];

    for (var i = 0; i < imageData.length / 4; i = i + 2) {
        if (imageData[i * 4 + 3] > 127) {
            ++size;
            color[0] += imageData[i * 4];
            color[1] += imageData[i * 4 + 1];
            color[2] += imageData[i * 4 + 2];
        }
    }

    color[0] = color[0] / size > 127;
    color[1] = color[1] / size > 127;
    color[2] = color[2] / size > 127;

    this.playerState = !color[0] && !color[1] && color[2] ? 'holiday' :
        !color[0] && color[1] && !color[2] ? 'weak' :
        !color[0] && color[1] && color[2] ? 'pact' :
        color[0] && !color[1] && !color[2] ? 'strong' :
        color[0] && !color[1] && color[2] ? 'immune' :
        color[0] && color[1] && !color[2] ? 'afk' :
        color[0] && color[1] && color[2] ? 'normal' :
        '';
};

/**
 *
 * @returns {PersistentDataMap}
 */
function PersistentDataMap() {
    this.map = JSON.parse(GM_getValue('CartoList', '{}'));
}

/**
 *
 * @returns {undefined}
 */
PersistentDataMap.prototype.persist = function () {
    GM_setValue('CartoList', JSON.stringify(this.map));
};

/**
 *
 * @param {int} galaxy
 * @param {int} system
 * @param {int} planet
 * @param {PlanetDataStuct} data
 * @returns {undefined}
 */
PersistentDataMap.prototype.upsert = function (galaxy, system, planet, data) {
    if (!this.map[galaxy]) {
        this.map[galaxy] = {};
    }

    if (!this.map[galaxy][system]) {
        this.map[galaxy][system] = {};
    }

    this.map[galaxy][system][planet] = data;
};

/**
 *
 * @returns {String}
 */
PersistentDataMap.prototype.toCSV = function () {
    var csvResult = "Galaxy,System,Planet,State,Name,Alliance\n";

    for (var galaxy in this.map) {
        for (var system in this.map[galaxy]) {
            for (var planet in this.map[galaxy][system]) {
                data = this.map[galaxy][system][planet];
                csvResult += galaxy + ',' + system + ',' + planet + ',' + data.playerState + ',' + data.planetName + ',' + data.allianceTag + "\n";
            }
        }
    }

    return csvResult;
};

$(function () {
    var dataMap = new PersistentDataMap();

    $('table:eq(2) tr').map(function (_, row) {
        var playerCell = $('td:eq(2)', row);

        if (playerCell.text() != '-') {
            var imageItem = $('img', playerCell);
            var firstSpanItem = $('span:eq(0)', playerCell);

            var data = new PlanetDataStruct();
            data.fromImage(imageItem[0]);

            if (playerCell.html().match(/PageAlly/)) {
                data.allianceTag = firstSpanItem.text().replace(/^\[(.*)\]$/, '$1');
                data.planetName = $('span:eq(1)', playerCell).text();
            }
            else {
                data.planetName = firstSpanItem.text();
            }

            dataMap.upsert($('#galaxi').val(), $('#system').val(), $('td:eq(0)', row).text(), data);
        }
    });

    dataMap.persist();

    var showButton = $('<input>');
    showButton.val('CARTO');
    showButton.attr('type', 'button');
    showButton.insertAfter($('table input[value="Voir"]'));

    showButton.on('click', function () {
        alert(dataMap.toCSV());
    });
});
