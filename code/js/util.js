function ord(x) {
    return x.charCodeAt(0);
}

function chr(x) {
    return String.fromCharCode(x);
}

function htmlentities(str) {
    var tagsToReplace = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;'
    };

    return str.replace(/([&<>])/g, function (match) {
        return tagsToReplace[match];
    });
}

function getElementByXpath(path) {
    return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}
