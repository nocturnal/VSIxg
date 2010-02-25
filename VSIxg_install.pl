use strict;

use File::Spec;
use File::Copy;
use File::Basename;
use Digest::MD5;

my @vsixgMD5 =
(
  '3b948aed44560185e51a4a03800df71c', # initial release
);

my @vsimakeMD5 = 
(
  'a87c57ed4c7046a748ca296e2d99f1bc', # GNU Make 3.80 SN Build 1.18
);

sub GetMD5
{
  my $file = shift;
  
  if ( !open( FILE, '<' . $file ) )
  {
    print "ERROR: Could not open $file for reading.\n";
    exit;
  }

  if ( $^O eq 'MSWin32' )
  {
    binmode( FILE, ':crlf' ); # set to binary mode
  }
  else
  {
    binmode( FILE );
  }

  my $md5 = Digest::MD5->new();

  $md5->addfile( *FILE );

  return $md5->hexdigest();
}

my $folder = File::Spec->catfile( $ENV{ ProgramFiles }, 'SN Systems', 'Common', 'VSI', 'bin' );
if ( !-e $folder )
{
  print( "$folder does not exist!\n" );
  exit( 1 );
}

my $targetMD5 = GetMD5( File::Spec->catfile( $folder, "vsimake.exe" ) );
foreach my $md5 ( @vsixgMD5 )
{
  if ( $md5 == $targetMD5 )
  {
    print( "vsixg.exe is already installed\n" );
    exit 0;
  }
}

my $vsimakeValid = 0;
foreach my $md5 ( @vsimakeMD5 )
{
  if ( $md5 == $targetMD5 )
  {
    $vsimakeValid = 1;
    last;
  }
}

my $sourceMD5 = GetMD5( File::Spec->catfile( dirname( $0 ), "vsixg.exe" ) );

my $vsixgValid = 0;
foreach my $md5 ( @vsixgMD5 )
{
  if ( $md5 == $sourceMD5 )
  {
    $vsixgValid = 1;
    last;
  }
}

if ( !$vsixgValid )
{
  print( "vsixg.exe is not a known build of vsixg.exe!\n" );
  exit 1;
}

my $source = File::Spec->catfile( $folder, 'vsimake.exe' );
my $target = File::Spec->catfile( $folder, 'snmake.exe' );
if ( move( $source, $target ) )
{
  print( "\nMove $source\n -> $target\n" );
}
else
{
  print( "\nUnable to move $source\n -> $target\n : $!" );
  exit 1;
}

$source = File::Spec->catfile( dirname( $0 ), 'vsixg.exe' );
$target = File::Spec->catfile( $folder, 'vsimake.exe' );
if ( copy( $source, $target ) )
{
  print( "\nCopy $source\n -> $target\n" );
}
else
{
  print( "\nUnable to copy $source\n -> $target\n : $!" );
  exit 1;
}

$source = File::Spec->catfile( dirname( $0 ), 'vsixg.xml' );
$target = File::Spec->catfile( $folder, 'vsixg.xml' );
if ( copy( $source, $target ) )
{
  print( "\nCopy $source\n -> $target\n" );
}
else
{
  print( "\nUnable to copy $source\n -> $target\n : $!" );
  exit 1;
}
