(function( $ ) {
    $( function() {
        $( '#section--about-papazian' ).css( 'margin-top', $( window ).height() + 250 );
    } );
    $( window ).load( function() {
        if ( $( 'body' ).hasClass( 'home' ) ) {
            new Waypoint.Inview( {
                element: $( '#section--introduction' ),
                enter: function( direction ) {
                    $( '#header--fixed' ).addClass( 'light' );
                    $( '#header' ).addClass( 'light' );
                    //console.log( 'Enter triggered with direction ' + direction );
                },
                exited: function( direction ) {
                    $( '#header--fixed' ).removeClass( 'light' );
                    $( '#header' ).removeClass( 'light' );
                    //console.log( 'Exited triggered with direction ' + direction );
                }
            } );
            new Waypoint.Inview( {
                element: $( '#section--luxurious-products' ),
                enter: function( direction ) {
                    if ( direction === 'down' ) {
                        console.log( 'Now!' );
                    }
                },
                exited: function( direction ) {
                }
            } );
        }
        $( '.show-in-view' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '80%'
                }
            );
        $( '.show-from-left' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '80%'
                }
            );
        $( '.show-from-right' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '80%'
                }
            );
        $( '.fade-in-view' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '80%'
                }
            );
        $( '.animate--stamp' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '70%'
                }
            );
        $( '.animate--timeline' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( '.timeline-years__full-line' ).addClass( 'animate' );
                    } else {
                        $( '.timeline-years__full-line' ).removeClass( 'animate' );
                    }
                }, {
                    offset: '80%'
                }
            );
        $( '.animate--line' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '80%'
                }
            );
        $( '.animate--filters' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '80%'
                }
            );
        $( '.animate--block' )
            .waypoint( function( direction ) {
                    if ( direction === 'down' ) {
                        $( this.element ).addClass( 'animate' );
                    } else {
                        $( this.element ).removeClass( 'animate' );
                    }
                }, {
                    offset: '100%'
                }
            );
        // if ( $( 'body' ).hasClass( 'single-post' ) ) {
        //     new Waypoint.Sticky( {
        //         element: $( '.navigation--post' )
        //         //offset: '60%'
        //     } );
        // }
        // if ( $( 'body' ).hasClass( 'single-product' ) ) {
        //     new Waypoint.Sticky( {
        //         element: $( '.navigation--post' )
        //         //offset: 1000
        //     } );
        // }
    } );
    $( window ).resize( function() {
        $( '#section--about-papazian' ).css( 'margin-top', $( window ).height() + 250 );
    } );
    $( window ).scroll( function() {
        if ( $( 'body' ).hasClass( 'home' ) ) {
            if ( $( window ).scrollTop() > 1 ) {
                $( '.vjs-control-bar' ).addClass( 'animate' );
                $( '.video-custom-controls' ).addClass( 'animate' );
            } else {
                $( '.vjs-control-bar' ).removeClass( 'animate' );
                $( '.video-custom-controls' ).removeClass( 'animate' );
            }
        }
    } );
})( jQuery );
