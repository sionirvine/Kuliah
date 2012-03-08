#! /usr/bin/perl -w

use OpenGL qw(:all);    # Use the OpenGL module
use strict;             # Use strict typechecking

my $Tex_File = "asd.jpg";
my $img = new OpenGL::Image(source=>$Tex_File);
# ASCII constant for the escape key
use constant ESCAPE => 27;

# Global variable for our window
my $window;

my @arrVertex1 = ();
my @arrVertex2 = ();
my @arrVertex3 = ();

my @arrFace1 = ();
my @arrFace2 = ();
my @arrFace3 = ();

my $ctrFace = 0;

my $camx = 0;
my $camy = 0;
my $zoom = -6;

my $ra = 0;
my $rb = 0;
my $rc = 0;
my $rd = 0;

my $LightAmbient  = [ 0.5, 0.5, 0.5, 1.0 ];
my $LightDiffuse  = [ 1.0, 1.0, 1.0, 1.0 ];
my $LightPosition = [ 0.0, 0.0, 2.0, 1.0 ];

my @ref = ();

sub ImageLoad {
    my $filename = shift;

    my $surface =
      new OpenGL::Image(source=> $filename);

    my $width   = $surface->width();
    my $height  = $surface->height();
    my $bytespp = $surface->bytes_per_pixel();
    my $size    = $width * $height * $bytespp;

    my $surface_pixels = $surface->pixels();
    my $surface_size   = $width * $height * $surface->bytes_per_pixel();
    my $raw_pixels     = $surface_pixels;

    #do a conversion (the pixel data is accessable as a simple string)

    my $pixels     = $raw_pixels;
    my $pre_conv   = $pixels;       #rotate image 180 degrees!
    my $new_pixels = "";
    for ( my $y = 0 ; $y < $height ; $y++ ) {
        my $y_pos =
          $y * $width * $bytespp;    #calculate offset into the image (a string)
        my $row =
          substr( $pre_conv, $y_pos, $width * $bytespp );   #extract 1 pixel row
        $row =~ s/\G(.)(.)(.)/$3$2$1/gms
          ;    #turn the BMP BGR order into OpenGL RGB order;
        $new_pixels .= reverse $row;
    }

    $raw_pixels = $new_pixels;    #put transformed data into C array.
    push @ref, $raw_pixels, $surface;

    #we could have created another SDL surface frm the '$raw_pixel's... oh well.
    return ( $raw_pixels, $width, $height, $size );
}

sub LoadGLTextures {

    # Load Texture
    my ( $pixels, $width, $height, $size ) = ImageLoad("test.jpg");

    # Create Texture

    glGenTextures(1);

    # texture 1 (poor quality scaling)
    ##glBindTexture(GL_TEXTURE_2D, 1);			# 2d texture (x and y size)

    ##glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST); # cheap scaling when image bigger than texture
    ##glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST); # cheap scaling when image smalled than texture

# 2d texture, level of detail 0 (normal), 3 components (red, green, blue), x size from image, y size from image,
# border 0 (normal), rgb color data, unsigned byte data, and finally the data itself.
#glTexImage2D(GL_TEXTURE_2D, 0, 3, image1->w, image1->h, 0, GL_RGB, GL_UNSIGNED_BYTE, image1->pixels);

    ##glTexImage2D(GL_TEXTURE_2D,
##		  0,						#level (0 normal, heighr is form mip-mapping)
##		  3,						#internal format (3=GL_RGB)
##		  $width,$height,
##		  0,						# border
##		  GL_RGB,					#format RGB color data
##		  GL_UNSIGNED_BYTE,				#unsigned bye data
##		  $pixels);				#ptr to texture data

    # texture 2 (linear scaling)
    glBindTexture( GL_TEXTURE_2D, 2 );    # 2d texture (x and y size)
    glTexParameter( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );    # scale linearly when image bigger than texture
    glTexParameter( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );    # scale linearly when image smalled than texture
     #glTexImage2D(GL_TEXTURE_2D, 0, 3, image1->w, image1->h, 0, GL_RGB, GL_UNSIGNED_BYTE, image1->pixels);

    glTexImage2D( GL_TEXTURE_2D,
        0,    #level (0 normal, heighr is form mip-mapping)
        3,    #internal format (3=GL_RGB)
        $width, $height,
        0,                   # border
        GL_RGB,              #format RGB color data
        GL_UNSIGNED_BYTE,    #unsigned bye data
        $pixels
    );                       #ptr to texture data

    # texture 3 (mipmapped scaling)
##   glBindTexture(GL_TEXTURE_2D, 3);			# 2d texture (x and y size)
##   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); # scale linearly when image bigger than texture
##   glTexParameter(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST); # scale linearly + mipmap when image smalled than texture
#glTexImage2D(GL_TEXTURE_2D, 0, 3, image1->w, image1->h, 0, GL_RGB, GL_UNSIGNED_BYTE, image1->pixels);

##   glTexImage2D(GL_TEXTURE_2D,
##		  0,						#level (0 normal, heighr is form mip-mapping)
##		  3,						#internal format (3=GL_RGB)
##		  $width,$height,
##		  0,						# border
##		  GL_RGB,					#format RGB color data
##		  GL_UNSIGNED_BYTE,				#unsigned bye data
##		  $pixels);				#ptr to texture data

# 2d texture, 3 colors, width, height, RGB in that order, byte data, and the data.
##   gluBuild2DMipmaps(GL_TEXTURE_2D, 3, $width, $height, GL_RGB, GL_UNSIGNED_BYTE, $pixels);

    my $glerr = glGetError();
    die "Problem setting up 2d Texture (dimensions not a power of 2?)):"
      . gluErrorString($glerr) . "\n"
      if $glerr;

}

# A general GL initialization function
# Called right after our OpenGL window is created
# Sets all of the initial parameters
sub InitGL {

    # Shift the width and height off of @_, in that order
    my ( $width, $height ) = @_;

    # Set the background "clearing color" to black
    glClearColor( 0.0, 0.0, 0.0, 0.0 );

    # Enables smooth color shading
    glShadeModel(GL_SMOOTH);

    # Enables clearing of the Depth buffer
    glClearDepth(1.0);

    # Enables depth testing with that type
    glEnable(GL_DEPTH_TEST);

    glEnable(GL_CULL_FACE);

    # The type of depth test to do
    glDepthFunc(GL_LEQUAL);

    glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );

    glEnable(GL_TEXTURE_2D);

    # load file obj

    open FILE, "pro.obj" or die $!;

    while ( my $lines = <FILE> ) {

        my $tipe = substr( $lines, 0, 1 );
        my @temp = split( / /, $lines );

        if ( $tipe eq "v" ) {
            push( @arrVertex1, $temp[1] );
            push( @arrVertex2, $temp[2] );
            push( @arrVertex3, $temp[3] );

        }
        elsif ( $tipe eq "f" ) {
            push( @arrFace1, $temp[1] );
            push( @arrFace2, $temp[2] );
            push( @arrFace3, $temp[3] );

            $ctrFace++;
        }
    }

    close(FILE);

    #glLight(GL_LIGHT1, GL_AMBIENT, @$LightAmbient);  # add lighting. (ambient)
    #glLight(GL_LIGHT1, GL_DIFFUSE, @$LightDiffuse);  # add lighting. (diffuse).
    #glLight(GL_LIGHT1, GL_POSITION,@$LightPosition); # set light position.
    #glEnable(GL_LIGHT1);

    # Reset the projection matrix
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;

    # Calculate the aspect ratio of the Window
    gluPerspective( 45.0, $width / $height, 0.1, 100.0 );

    # Reset the modelview matrix
    glMatrixMode(GL_MODELVIEW);

    LoadGLTextures();
}

# The function called when our window is resized
# This shouldn't happen, because we're fullscreen
sub ReSizeGLScene {

    # Shift width and height off of @_, in that order
    my ( $width, $height ) = @_;

    # Prevent divide by zero error if window is too small
    if ( $height == 0 ) { $height = 1; }

    # Reset the current viewport and perspective transformation
    glViewport( 0, 0, $width, $height );

    # Re-initialize the window (same lines from InitGL)
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    gluPerspective( 45.0, $width / $height, 0.1, 100.0 );
    glMatrixMode(GL_MODELVIEW);
}

# The main drawing function.
sub DrawGLScene {

    # Clear the screen and the depth buffer
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

    # Reset the view
    glLoadIdentity;

    # Move to the left 1.5 units and into the screen 6.0 units
    glTranslatef( $camx, $camy, $zoom );

    glRotatef( $ra, $rb, $rc, $rd );

    for my $i ( 0 .. $ctrFace - 1 ) {
        my $face1 = $arrFace1[$i] - 1;
        my $face2 = $arrFace2[$i] - 1;
        my $face3 = $arrFace3[$i] - 1;

        glBegin(GL_TRIANGLES);

        glColor3f( 255, 0, 0 );
        glVertex3f( $arrVertex1[$face1], $arrVertex2[$face1],
            $arrVertex3[$face1] );
        glVertex3f( $arrVertex1[$face2], $arrVertex2[$face2],
            $arrVertex3[$face2] );
        glVertex3f( $arrVertex1[$face3], $arrVertex2[$face3],
            $arrVertex3[$face3] );

        #print ( $arrVertex1[ $face1 ] );
        glEnd();
    }

    # Since this is double buffered, swap the buffers.
    # This will display what just got drawn.
    glutSwapBuffers;
}

# The function called whenever a key is pressed.
sub keyPressed {

    # Shift the unsigned char key, and the x,y placement off @_, in
    # that order.
    my ( $key, $x, $y ) = @_;

    # Avoid thrashing this procedure
    # Note standard Perl does not support usleep
    # For finer resolution sleep than seconds, try:
    #    'select undef, undef, undef, 0.1;'
    # to sleep for (at least) 0.1 seconds
    # sleep(100);

    # If f key pressed, undo fullscreen and resize to 640x480
    if ( $key == ord('f') ) {

        # Use reshape window, which undoes fullscreen
        glutReshapeWindow( 640, 480 );
    }

    if ( $key == ord('=') ) { $zoom++; }
    if ( $key == ord('-') ) { $zoom--; }
    if ( $key == ord('w') ) { $camy--; }
    if ( $key == ord('a') ) { $camx++; }
    if ( $key == ord('s') ) { $camy++; }
    if ( $key == ord('d') ) { $camx--; }
    if ( $key == ord('u') ) { $ra++; }
    if ( $key == ord('i') ) { $rb++; }
    if ( $key == ord('o') ) { $rc++; }
    if ( $key == ord('p') ) { $rd++; }
    if ( $key == ord('j') ) { $ra--; }
    if ( $key == ord('k') ) { $rb--; }
    if ( $key == ord('l') ) { $rc--; }
    if ( $key == ord(';') ) { $rd--; }

    # If escape is pressed, kill everything.
    if ( $key == ESCAPE ) {

        # Shut down our window
        glutDestroyWindow($window);

        # Exit the program...normal termination.
        exit(0);
    }

    print("asd");
}

# --- Main program ---

# Initialize GLUT state
glutInit;

# Select type of Display mode:
# Double buffer
# RGB color (Also try GLUT_RGBA)
# Alpha components removed (try GLUT_ALPHA)
# Depth buffer */
glutInitDisplayMode( GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH );

# Get a 640 x 480 window
glutInitWindowSize( 640, 480 );

# The window starts at the upper left corner of the screen
glutInitWindowPosition( 0, 0 );

# Open the window
$window = glutCreateWindow("Jeff Molofee's GL Code Tutorial ... NeHe '99");

# Register the function to do all our OpenGL drawing.
glutDisplayFunc( \&DrawGLScene );

# Go fullscreen.  This is as soon as possible.
#glutFullScreen;

# Even if there are no events, redraw our gl scene.
glutIdleFunc( \&DrawGLScene );

# Register the function called when our window is resized.
glutReshapeFunc( \&ReSizeGLScene );

# Register the function called when the keyboard is pressed.
glutKeyboardFunc( \&keyPressed );

# Initialize our window.
InitGL( 640, 480 );

# Start Event Processing Engine
glutMainLoop;

return 1;

