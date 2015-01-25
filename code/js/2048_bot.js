/*
 * Run in Firefox Scratchpad for http://gabrielecirulli.github.io/2048/
 */

score = null;
stuck = null;

function doKeyPress(element, key) {
    var keyboardEvent = document.createEvent('KeyboardEvent');
    keyboardEvent.initKeyEvent('keydown', true, true, window, false, false, false, false, keyboardEvent[key], 0);

    element.dispatchEvent(keyboardEvent);
}

function doMouseClick(element, button) {
    var mouseEvent = document.createEvent('MouseEvent');
    mouseEvent.initMouseEvent('click', true, true, window, 1, element.clientLeft, element.clientTop, element.clientLeft, element.clientTop, false, false, false, false, button, null);

    element.dispatchEvent(mouseEvent);
}

function getElementByXpath(path) {
    return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}

function checkAndReset() {
    var gameScore = score;
    var gameStuck = stuck;
    var scoreElement = getElementByXpath('//div[@class=\'score-container\']');
    var messageElement = getElementByXpath('//div[@class=\'game-message game-over\']');
    var newGameElement = getElementByXpath('//a[@class=\'restart-button\']');

    score = scoreElement.innerHTML;
    stuck = false;

    if (gameStuck) {
        doMouseClick(newGameElement, 0);
        score = 0;
    }
    else if (scoreElement.innerHTML == gameScore || messageElement !== null) {
        stuck = true;
    }
}

function mainLoop() {
    var gameElement = getElementByXpath('//div[@class=\'game-container\']');

    setTimeout(doKeyPress, 0, gameElement, 'DOM_VK_LEFT');
    setTimeout(doKeyPress, 50, gameElement, 'DOM_VK_DOWN');
    setTimeout(doKeyPress, 100, gameElement, 'DOM_VK_RIGHT');
    setTimeout(doKeyPress, 150, gameElement, 'DOM_VK_DOWN');
    setTimeout(checkAndReset, 200);
}

setInterval(mainLoop, 200);
