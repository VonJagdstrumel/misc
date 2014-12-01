/*
 * Run in Firefox Scratchpad
 */

var r = '';
var list = new Array();
$('div.thread').each(function () {
    if (this instanceof HTMLDivElement) {
        list.push({
            name: this.childNodes[0].textContent.trim(),
            count: 0
        });
        for (var index in this.childNodes) {
            if (this.childNodes[index] instanceof HTMLDivElement) {
                list[list.length - 1].count++;
            }
        }
    }
});
for (i in list) {
    r += list[i].name + ';' + list[i].count + '\n';
}
r;
