/*
 * Run in Firefox Scratchpad (browser context)
 */

var r = '';
var list = new Array();
var mainWindow = Components.classes['@mozilla.org/appshell/window-mediator;1'].getService(Ci.nsIWindowMediator).getMostRecentWindow('navigator:browser');
for (var index in mainWindow) {
    if (!isNaN(parseFloat(index)) && isFinite(index) && mainWindow[index] instanceof Window && mainWindow[index].location.host == '9gag.com') {
        list.push({
            url: mainWindow[index].location.href,
            title: mainWindow[index].document.title.substr(0, mainWindow[index].document.title.length - 7)
        });
    }
}
for (i in list) {
    r += '* [[' + list[i].url + '|' + list[i].title + ']]\n';
}
r;
