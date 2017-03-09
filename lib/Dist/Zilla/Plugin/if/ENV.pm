use 5.006;    # our
use strict;
use warnings;

package Dist::Zilla::Plugin::if::ENV;

our $VERSION = '0.001001';

# ABSTRACT: Load a plugin when an ENV key is true.

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
  return unless exists $ENV{$key};
  return unless $ENV{$key};
  return $self->$orig($loader);
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=head1 SYNOPSIS

  [if::ENV]
  key            = UBERTESTING
  dz_plugin      = Some::Plugin
  dz_plugin_name = UBERTEST/Some::Plugin
  >= some_plugin_argument = itsvalue
  >= some_plugin_argument = itsvalue

Then

  dzil build # Some::Plugin not loaded, but declared as a develop dep anyway
  UBERTESTING=1 dzil build # Some::Plugin loaded!
  UBERTESTING=0 dzil build # Some::Plugin NOT loaded

=head2 SEE ALSO

=over 4

=item * C<[if]> - L<< Dist::Zilla::Plugin::if|Dist::Zilla::Plugin::if >>

=item * C<[if::not]> - L<< Dist::Zilla::Plugin::if::not|Dist::Zilla::Plugin::if::not >>

=item * C<[if::not::ENV]> - L<< Dist::Zilla::Plugin::if::not::ENV|Dist::Zilla::Plugin::if::not::ENV >>

=item * C<PluginLoader::Configurable role> - L<<
Dist::Zilla::Role::PluginLoader::Configurable|Dist::Zilla::Role::PluginLoader::Configurable
>>

=item * C<PluginLoader role> - L<< Dist::Zilla::Role::PluginLoader|Dist::Zilla::Role::PluginLoader >>

=item * C<PluginLoader util> - L<< Dist::Zilla::Util::PluginLoader|Dist::Zilla::Util::PluginLoader >>

=back

=cut
