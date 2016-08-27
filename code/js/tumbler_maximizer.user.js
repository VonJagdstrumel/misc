// ==UserScript==
// @name       Tumblr Image Maximizer
// @namespace  vonjagdstrumel.fr
// @include    http://*.tumblr.com/
// @include    http://restrictedsenses.com/*
// @version    1
// @grant      none
// @require    http://code.jquery.com/jquery-1.11.2.min.js
// ==/UserScript==

$('img[src*=".media.tumblr.com/"][src*="/tumblr_"]').map(function (_, item) {
    item = $(item)
    var orig = item.attr('src');
    item.error(function () {
        if (this.src != orig) {
            this.src = orig;
        }
    });
    item.attr('src', orig.replace(/_[0-9]+\.(jpe?g|gif|png)/, '_1280.$1'));
});

$('img[class="attachment-thumbnail"]').map(function (_, item) {
    item = $(item);
    item.attr('src', item.attr('src').replace(/-[0-9]+x[0-9]+(\.jpe?g)$/, '$1'));
});
