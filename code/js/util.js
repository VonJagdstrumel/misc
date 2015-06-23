Math.seed = 824;

/**
 * Générateur de nombres aléatoires seedable
 * @param {Number} min
 * @param {Number} max
 * @returns {Number}
 */
Math.seededRandom = function (min, max) {
    max = max || 1;
    min = min || 0;
    Math.seed = (Math.seed * 9301 + 49297) % 233280;
    var rnd = Math.seed / 233280;
    return min + rnd * (max - min);
};

/**
 * Retire une portion de la chaine de caractères et met en majuscule la première lettre
 * @param {String} regex
 * @returns {String}
 */
String.prototype.truncateText = function (regex) {
    regex = regex || '';
    var tmp = this.replace(new RegExp(regex), '');
    return tmp.charAt(0).toUpperCase() + tmp.slice(1);
};

/**
 * Conversion de degrés en radians
 * @param {Number} degrees
 * @returns {Number}
 */
Math.radians = function (degrees) {
    return degrees * Math.PI / 180;
};

/**
 * Transforme les caractères spéciaux HTML en leurs entités
 * @returns {String}
 */
String.prototype.htmlEntities = function () {
    var tagsToReplace = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;'
    };
    return this.replace(/([&<>])/g, function (match) {
        return tagsToReplace[match];
    });
};

/**
 * Récupère le premier noeud
 * @param {String} path
 * @returns {Element}
 */
Node.prototype.getFirstNodeByXpath = function (path) {
    return document.evaluate(path, this, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
};

/**
 * Récupère une liste de noeuds
 * @param {String} path
 * @returns {Array}
 */
Node.prototype.getNodeListByXpath = function (path) {
    var snapshot = document.evaluate(path, this, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    var elementList = [];
    for (var i = 0; i < snapshot.snapshotLength; ++i) {
        elementList.push(snapshot.snapshotItem(i));
    }
    return elementList;
};
