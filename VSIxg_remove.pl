use strict;

use File::Spec;
use File::Copy;
use Digest::MD5;

my $folder = File::Spec->catfile( $ENV{ ProgramFiles }, 'SN Systems', 'Common', 'VSI', 'bin' );
if ( !-e $folder )
{
  print( "$folder does not exist!\n" );
  exit( 1 );
}

my $source = File::Spec->catfile( $folder, 'snmake.exe' );
my $target = File::Spec->catfile( $folder, 'vsimake.exe' );
if ( -e $source )
{
  if ( -e $target )
  {
    unlink( $target );

    if ( !-e $target )
    {
      print ("\nDeleted $target\n");
    }
    else
    {
      print ("\nUnable to delete $target : $!\n");
      exit 1;
    }
  }

  if ( move( $source, $target ) )
  {
    print( "\nMove $source\n -> $target\n" );
  }
  else
  {
    print( "\nUnable to move $source\n -> $target\n : $!" );
    exit 1;
  }
  
  my $xml = File::Spec->catfile( $folder, 'vsixg.xml' );
  if ( -e $xml )
  {
    unlink( $xml );

    if ( !-e $xml )
    {
      print ("\nDeleted $xml\n");
    }
    else
    {
      print ("\nUnable to delete $xml : $!\n");
      exit 1;
    }
  }  
}
else
{
  print( "vsixg.exe is not installed\n" );
}