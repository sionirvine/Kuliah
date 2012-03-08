#!/usr/local/bin/perl

use strict;
use Tk;

my ( $width, $height ) = ( 640, 480 );
my $count    = 0;
my @arrDrawX = ( 0, 0, 0 );
my @arrDrawY = ( 0, 0, 0 );
print("initializing..");

my $mw = MainWindow->new;
$mw->configure( -width => $width, -height => $height );
$mw->resizable( 0, 0 );

my $can = $mw->Canvas( -width => $width, -height => $height )->pack();

my $img = $mw->Photo(
    -width   => $width,
    -height  => $height,
    -palette => '256/256/256'
);

$img->blank;
$can->createImage( 0, 0, -image => $img, -anchor => 'nw' );
$can->CanvasBind( '<ButtonRelease-1>' => \&mouseClick );

print("complete\n");
MainLoop();

sub drawSmoothTriangle {
    my ( $x1, $y1, $x2, $y2, $x3, $y3 ) = @_;

    #I: persamaan ketiga garis
    my $a1 = $y1 - $y2;
    my $b1 = $x2 - $x1;
    my $c1 = $x1 * $y2 - $x2 * $y1;

    my $a2 = $y2 - $y3;
    my $b2 = $x3 - $x2;
    my $c2 = $x2 * $y3 - $x3 * $y2;

    my $a3 = $y3 - $y1;
    my $b3 = $x1 - $x3;
    my $c3 = $x3 * $y1 - $x1 * $y3;

    #II: harus positif!
    if ( int( $c1 + $c2 + $c3 ) < 0 ) {
        $a1 = -$a1;
        $b1 = -$b1;
        $c1 = -$c1;

        $a2 = -$a2;
        $b2 = -$b2;
        $c2 = -$c2;

        $a3 = -$a3;
        $b3 = -$b3;
        $c3 = -$c3;
    }

    #III: bounding box
    my $minx = $x1;
    my $maxx = $x1;
    my $miny = $y1;
    my $maxy = $y1;

    if ( $x2 < $minx ) { $minx = $x2; }
    if ( $x3 < $minx ) { $minx = $x3; }
    if ( $y2 < $miny ) { $miny = $y2; }
    if ( $y3 < $miny ) { $miny = $y3; }

    if ( $x2 > $maxx ) { $maxx = $x2; }
    if ( $x3 > $maxx ) { $maxx = $x3; }
    if ( $y2 > $maxy ) { $maxy = $y2; }
    if ( $y3 > $maxy ) { $maxy = $y3; }

    #cerita spesial: mencari A, B, C, D
    my $zred1 = 255;
    my $zred2 = 0;
    my $zred3 = 0;
    my $zgreen1 = 0;
    my $zgreen2 = 255;
    my $zgreen3 = 0;
    my $zblue1 = 0;
    my $zblue2 = 0;
    my $zblue3 = 255;
    
    my $ar = ($y2 - $y3) * ($zred1 - $zred3) - ($zred2 - $zred3) * ($y1 - $y3);
    my $br = ($zred2 - $zred3) * ($x1 - $x3) - ($x2 - $x3) * ($zred1 - $zred3);
    my $cr = ($x2 - $x3) * ($y1 - $y3) - ($y2 - $y3) * ($x1 - $x3);
    my $dr = -$ar * $x1 - $br * $y1 - $cr * $zred1;
    
    my $ag = ($y2 - $y3) * ($zgreen1 - $zgreen3) - ($zgreen2 - $zgreen3) * ($y1 - $y3);
    my $bg = ($zgreen2 - $zgreen3) * ($x1 - $x3) - ($x2 - $x3) * ($zgreen1 - $zgreen3);
    my $cg = ($x2 - $x3) * ($y1 - $y3) - ($y2 - $y3) * ($x1 - $x3);
    my $dg = -$ag * $x1 - $bg * $y1 - $cg * $zgreen1;
    
    my $ab = ($y2 - $y3) * ($zblue1 - $zblue3) - ($zblue2 - $zblue3) * ($y1 - $y3);
    my $bb = ($zblue2 - $zblue3) * ($x1 - $x3) - ($x2 - $x3) * ($zblue1 - $zblue3);
    my $cb = ($x2 - $x3) * ($y1 - $y3) - ($y2 - $y3) * ($x1 - $x3);
    my $db = -$ab * $x1 - $bb * $y1 - $cb * $zblue1;
    
    #IV: gambar
    for my $x ( $minx .. $maxx ) {
        for my $y ( $miny .. $maxy ) {
            if (   int( $a1 * $x + $b1 * $y + $c1 ) > 0
                && int( $a2 * $x + $b2 * $y + $c2 ) > 0
                && int( $a3 * $x + $b3 * $y + $c3 ) > 0 )
            {
                
                my $zr = (-$ar * $x - $br * $y - $dr) / $cr;
                my $zg = (-$ag * $x - $bg * $y - $dg) / $cg;
                my $zb = (-$ab * $x - $bb * $y - $db) / $cb;
                
                my $z1 = sprintf( "%2.2X", $zr );
                my $z2 = sprintf( "%2.2X", $zg );
                my $z3 = sprintf( "%2.2X", $zb );
                
                $img->put( '#' . $z1 . $z2 . $z3, -to => ( $x, $y ) );
                
            }
        }
    }

}

sub mouseClick {
    my $x = $can->pointerx - $can->rootx;
    my $y = $can->pointery - $can->rooty;

    if ( $x > 0 && $y > 0 ) {

        $arrDrawX[$count] = $x;
        $arrDrawY[$count] = $y;

        $count++;

        print("position $count at $x,$y\n");

        if ( $count eq 3 ) {
            print("drawing.. please wait\n");
            &drawSmoothTriangle(
                $arrDrawX[0], $arrDrawY[0],           
                $arrDrawX[1], $arrDrawY[1],
                $arrDrawX[2], $arrDrawY[2],
            );
            print("complete\n");
            $count = 0;
        }

    }
    else {
        $count = 0;
        print("cursor out of bounds, try again\n");
    }
}


