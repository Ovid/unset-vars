package Unset::Vars;

use strict;
use warnings;
require Exporter;
require XSLoader;

our @ISA = qw(Exporter);
our @EXPORT = qw(unset is_unset is_set);

our $VERSION = '0.01';

XSLoader::load('unset', $VERSION);

1;

__END__

=head1 NAME

Unset::Vars - Perl extension for declaring unset variables

=head1 SYNOPSIS

  use Unset::Vars;

  my $var = unset;

  if (is_unset($var)) {
      print "var is unset\n";
  }

  $var = "something";

  if (!is_unset($var)) {
      print "var is no longer unset\n";
  }

=head1 DESCRIPTION

Sometimes it is useful to know if a variable is not set and not just set to
C<undef>.  This module provides a way to declare a variable as unset and to
check if it is unset.

This is also useful in subroutines signatures where you want to know if a
variable was passed in or not.

    sub attribute ( $self, $var = unset ) {
        if ( is_set($var) ) {
            $self->{attribute} = $var;
        }
        else {
            return $self->{attribute};
        }
    }

In the above example, we implement the popular (if unfortunate) Perl habit of
using a single method as both a getter an setter. If C<undef> is a valid value
for C<$var>, then you would not be able to distinguish between C<undef> and
not passed in. By using C<unset> you can now tell the difference.

=head1 EXPORT

C<unset>, C<is_unset>, and C<is_set> are exported by default.

=head1 FUNCTIONS

=head2 unset

  my $var = unset;

Declares a scalar as unset. Sets the scalar to C<undef>.

=head2 is_unset

  if (is_unset($var)) {
      print "var is unset\n";
  } else {
      print "var is set\n";
  }

Returns true if the scalar is unset.

=head2 is_set

  if (is_set($var)) {
      print "var is set\n";
  } else {
      print "var is unset\n";
  }
