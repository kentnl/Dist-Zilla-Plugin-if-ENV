
use strict;
use warnings;

use Test::More 0.96;
use Test::DZil qw( simple_ini );
use Dist::Zilla::Util::Test::KENTNL 1.003001 qw( dztest );

# ABSTRACT: Test basic loading

my $test = dztest();
$ENV{AIRPLANE} = 1;    # This should not load

$test->add_file( 'sample.txt', q[] );
$test->add_file(
  'dist.ini',
  simple_ini(
    ['MetaConfig'],
    [
      'if::not::ENV',
      {
        key       => 'AIRPLANE',
        dz_plugin => 'GatherDir',
      }
    ]
  )
);
$test->build_ok;
is( $test->built_file('sample.txt'), undef, 'sample.txt should not gathers with airplane mode' );
note explain $test->builder->log_messages;
note explain [ grep { $_->{class} !~ /FinderCode/ } @{ $test->distmeta->{x_Dist_Zilla}->{plugins} } ];

done_testing;

