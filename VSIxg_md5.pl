use strict;

use Digest::MD5;

if ( scalar( @ARGV ) != 1 )
{
  print "Usage: md5 <filename>\n\n";
  exit;
}

my $fh;
if ( !open( $fh, '<' . $ARGV[0] ) )
{
  print "ERROR: Could not open $ARGV[0] for reading.\n";
  exit;
}

if ( $^O eq 'MSWin32' )
{
  binmode( $fh, ':crlf' ); # set to binary mode
}
else
{
  binmode( $fh );
}

my $md5 = Digest::MD5->new();

$md5->addfile( *$fh );

my $md5_hex = $md5->hexdigest();

print qq{
  File: $ARGV[0]
  Hex Digest: $md5_hex
};

close( $fh );

exit;