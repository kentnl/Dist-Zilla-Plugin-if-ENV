use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Dist::Zilla::Plugin::if::not::ENV;

our $VERSION = '0.001000';

# ABSTRACT: Load a plugin when an ENV key is NOT true.

# AUTHORITY

use Moose qw( has around with );
use Dist::Zilla::Util qw();
use Dist::Zilla::Util::ConfigDumper qw( config_dumper );

with 'Dist::Zilla::Role::PluginLoader::Configurable';

has key => ( is => ro =>, required => 1 );
around dump_config => config_dumper( __PACKAGE__, qw( key ) );

around load_plugins => sub {
  my ( $orig, $self, $loader ) = @_;
  my $key = $self->key;
  return if exists $ENV{$key} and $ENV{$key};
  return $self->$orig($loader);
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=head1 SYNOPSIS

  [if::not::ENV]
  key            = AIRPLANE
  dz_plugin      = Some::Plugin
  dz_plugin_name = NOTAIRPLANE/Some::Plugin
  >= some_plugin_argument = itsvalue
  >= some_plugin_argument = itsvalue

Then

  dzil build # Some::Plugin is loaded
  AIRPLANE=1 dzil build # Some::Plugin NOT loaded!... but still a develop dep.
  AIRPLANE=0 dzil build # Some::Plugin loaded

=head2 SEE ALSO

=over 4

=item * C<[if]> - L<< Dist::Zilla::Plugin::if|Dist::Zilla::Plugin::if >>

=item * C<[if::not]> - L<< Dist::Zilla::Plugin::if::not|Dist::Zilla::Plugin::if::not >>

=item * C<[if::ENV]> - L<< Dist::Zilla::Plugin::if::ENV|Dist::Zilla::Plugin::if::ENV >>

=item * C<PluginLoader::Configurable role> - L<<
Dist::Zilla::Role::PluginLoader::Configurable|Dist::Zilla::Role::PluginLoader::Configurable
>>

=item * C<PluginLoader role> - L<< Dist::Zilla::Role::PluginLoader|Dist::Zilla::Role::PluginLoader >>

=item * C<PluginLoader util> - L<< Dist::Zilla::Util::PluginLoader|Dist::Zilla::Util::PluginLoader >>

=back

=cut
