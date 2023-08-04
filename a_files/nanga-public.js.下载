if (!window.location.origin) {
    window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
}
//(function ($) {
//  $.fn.setPlaceholder = function () {
//    return this.each(function () {
//      var label = $(this).parent().prev();
//      label.hide();
//      // var label_new = $(this).parent().prev().text().replace('*', '');
//      var label_new = $(this).parent().prev().text();
//      $(this).attr('placeholder', label_new);
//    });
//  };
//})(jQuery);
//$('.gform_body input.medium').setPlaceholder();
//$(document).bind('gform_post_render', function () {
//  $('.gform_body input.medium').setPlaceholder();
//});
//(function () {
//    var NOTFOUNDSRC = 'http://placehold.it/1x1/000000/000000';
//    document.addEventListener('error', function (e) {
//        if (e.target.nodeName.toUpperCase() === 'IMG' && e.target.getAttribute('src') !== NOTFOUNDSRC) {
//            e.target.setAttribute('src', NOTFOUNDSRC);
//        }
//    }, true);
//})();
(function ($) {
    'use strict';
    $(function () {
        var retina = window.devicePixelRatio > 1;
        $('#commentform').removeAttr('novalidate');
        $('.vg-link').click(function () {
            window.location = $(this).find('a').attr('href');
            return false;
        });
        $('.vg-link-scroll').click(function () {
            $('html, body').animate({
                scrollTop: $($(this).attr('href')).offset().top
            }, {
                duration: 500,
                easing: "swing"
            });
            return false;
        });
        if (retina) {
        } else {
        }
    });
    $(window).load(function () {
        if (nanga.environment === 'development') {
            console.log(nanga);
        }
    });
})(jQuery);
