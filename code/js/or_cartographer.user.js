// ==UserScript==
// @name       Origins Return - Cartographer
// @namespace  behindtheshell.fr
// @include    http://*.origins-return.fr/galaxie.php*
// @version    1
// @grant      none
// @require    http://code.jquery.com/jquery-1.11.2.min.js
// ==/UserScript==

$(function () {
    var dataList = [];

    $('table[width="600px"] tr').map(function (_, currentRow) {
        var cellSelection = $('td', currentRow);
        var info = $(cellSelection[2]);

        if (info.text() !== '-') {
            var dataRow = [];
            var spanSelection = $('span', info);
            var coordinates = [$('#galaxi').val(), $('#system').val(), $(cellSelection[0]).text()];
            dataRow[0] = coordinates.join(':');
            dataRow[3] = $('img', info).attr('src');

            if (info.html().match(/PageAlly/)) {
                dataRow[1] = $(spanSelection[0]).text();
                dataRow[2] = $(spanSelection[1]).text();
            }
            else {
                dataRow[1] = '';
                dataRow[2] = $(spanSelection[0]).text();
            }

            dataList.push(dataRow.join(','));
        }
    });

    $('table[width="600px"]').replaceWith('<textarea rows="10" cols="100" style="overflow: auto;" onClick="select(); focus();">' + dataList.join("\n") + '</textarea>');
});
