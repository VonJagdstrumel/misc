/*
 * Run in Firefox Scratchpad
 */

var r = '';
var list = new Array();
$('div:nth-child(2) > div:nth-child(2)').each(function () {
    if (this.childNodes[2] != undefined) {
        elText = this.childNodes[2].textContent.trim();
        if (elText.search('#quote') != -1) {
            list.push(elText);
        }
    }
});
for (i in list) {
    r += list[i] + '\n\n';
}
r;
