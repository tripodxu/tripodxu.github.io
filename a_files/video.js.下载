window.HELP_IMPROVE_VIDEOJS = false;
var video;
(function ($) {
    var isMobile = $.restive.isMobile();
    var headerHeight = $('#header--fixed').outerHeight();

    function getNextChapter() {
        var $curr = $('.chapter.playing');
        var $next = ($curr.next().length) ? $curr.next() : $('#chapters .chapter').first();
        $curr.removeClass('playing');
        $next.addClass('playing');
        video.currentTime($next.attr('data-time'));
        video.pause();
    }

    $(function () {
        if (!isMobile) {
            video = videojs('video', {
                bigPlayButton: false,
                inactivityTimeout: 0,
                loadingSpinner: false,
                loop: false,
                nativeControlsForTouch: false,
                controlBar: {
                    captionsButton: false,
                    chaptersButton: false,
                    currentTimeDisplay: false,
                    customControlSpacer: false,
                    durationDisplay: false,
                    fullscreenToggle: false,
                    liveDisplay: false,
                    muteToggle: false,
                    playbackRateMenuButton: false,
                    playToggle: false,
                    subtitlesButton: false,
                    timeDivider: false,
                    progressControl: {
                        seekBar: {
                            mouseTimeDisplay: false
                        }
                    },
                    remainingTimeDisplay: false,
                    volumeControl: false,
                    volumeMenuButton: false
                },
                preload: "none"
            }, function () {
                //this.volume(0);
                //this.play();
                $('.video-custom-controls').show();
                this.on('ended', function () {
                });
                this.on('timeupdate', function () {
                });
                //this.on( 'progress', function() {
                //    console.log( player.bufferedPercent() );
                //    if ( player.bufferedPercent() > 0.5 ) {
                //        player.play();
                //    }
                //}, false );
                //this.addRemoteTextTrack( {
                //    kind: 'chapters',
                //    mode: 'visible',
                //    src: '/wp-content/themes/vg-twig/assets/video/chapters.vtt'
                //} );
            });
            video.markers({
                markerTip: {display: false},
                markerStyle: {
                    'width': '1px',
                    'border-radius': '0',
                    'background-color': '#222121'
                },
                breakOverlay: {
                    display: true,
                    displayTime: 1,
                    style: {'background-color': 'transparent'},
                    text: function (marker) {
                        return '<div class="overlay-line-1">' + marker.overlay1 + '</div>' + '<div class="overlay-line-2">' + marker.overlay2 + '</div>';
                    }
                },
                onMarkerClick: function (marker) {
                },
                onMarkerReached: function (marker) {
                    //video.pause();
                    //setTimeout( function() {
                    //    video.play();
                    //}, 2000 );
                    $('.vjs-marker').removeClass('active');
                    $(".vjs-marker[data-marker-key='" + marker.key + "']").addClass('active');
                    setTimeout(function () {
                        $('.vjs-break-overlay').removeClass('animate');
                    }, 3000);
                },
                markers: video_vars.markers
                //markers: [
                //    {
                //        overlay1: "JEWELRY DISPLAYS",
                //        overlay2: "LUXURY JEWELRY DISPLAYS",
                //        overlayText: "JEWELRY DISPLAYS",
                //        text: "JEWELRY DISPLAYS",
                //        time: 0,
                //    },
                //    {
                //        overlay1: "EXPERIENCE",
                //        overlay2: "LUXURY JEWELRY DISPLAYS",
                //        overlayText: "EXPERIENCE",
                //        text: "EXPERIENCE",
                //        time: 10,
                //    },
                //    {
                //        overlay1: "CRAFTSMANSHIP",
                //        overlay2: "LUXURY JEWELRY DISPLAYS",
                //        overlayText: "CRAFTSMANSHIP",
                //        text: "CRAFTSMANSHIP",
                //        time: 15,
                //    },
                //    {
                //        overlay1: "CUSTOM-MADE",
                //        overlay2: "LUXURY JEWELRY DISPLAYS",
                //        overlayText: "CUSTOM-MADE",
                //        text: "CUSTOM-MADE",
                //        time: 25,
                //    }
                //]
            });
            video.on('play', function () {
                $('.play.paused').removeClass('paused').addClass('playing');
            });
            video.on('pause', function () {
                $('.play.playing').removeClass('playing').addClass('paused');
            });
            $('.skip').click(function (e) {
                //getNextChapter();
                //video.markers.next();
                var where = $(this).attr('href');
                $(where).velocity('scroll', {
                    duration: 1000,
                    easing: 'ease-in-out'
                });
                e.preventDefault();
            });
            $(document).on('click', '.play.playing', function (e) {
                $(this).removeClass('playing').addClass('paused');
                video.pause();
                e.preventDefault();
            });
            $(document).on('click', '.play.paused', function (e) {
                $(this).removeClass('paused').addClass('playing');
                video.play();
                e.preventDefault();
            });
            $(document).on('click', '.mute.unmuted', function (e) {
                $(this).removeClass('unmuted').addClass('mutedd');
                video.volume(0);
                e.preventDefault();
            });
            $(document).on('click', '.mute.mutedd', function (e) {
                $(this).removeClass('mutedd').addClass('unmuted');
                video.volume(1);
                e.preventDefault();
            });
        }
    });
})(jQuery);
//window.addEventListener( 'load', function() {
//    function checkLoad() {
//        console.log( video.readyState() );
//        if ( video.readyState === 4 ) {
//            console.log( video.readyState );
//            console.log( '--- Video is ready' );
//            video.play();
//        } else {
//            setTimeout( checkLoad, 100 );
//        }
//    }
//
//    checkLoad();
//}, false );
