// ==UserScript==
// @name       Tumblr Image Maximizer
// @namespace  vonjagdstrumel.fr
// @include    http://*.tumblr.com/
// @version    1
// @grant      none
// @require    http://code.jquery.com/jquery-1.11.2.min.js
// ==/UserScript==

$('img[src*=".media.tumblr.com/"][src*="/tumblr_"]').map(function (_, item) {
    var orig = $(item).attr('src');
    $(item).error(function () {
        if (this.src !== orig) {
            this.src = orig;
        }
    });
    $(item).attr('src', $(item).attr('src').replace(/_[0-9]+\.(jpe?g|gif|png)/, '_1280.$1'));
});
