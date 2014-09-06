use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Dist::Zilla::Plugin::if::ENV;

our $VERSION = '0.001000';

# ABSTRACT: Load a plugin when an ENV key is true.

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

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

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::if::ENV - Load a plugin when an ENV key is true.

=head1 VERSION

version 0.001000

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
