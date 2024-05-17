# NAME

`Unset::Vars` - Perl extension for declaring unset variables

# SYNOPSIS

```perl
  use Unset::Vars;

  my $var = unset;

  if (is_unset($var)) {
      print "var is unset\n";
  }

  $var = "something";

  if (!is_unset($var)) {
      print "var is no longer unset\n";
  }
```

# DESCRIPTION

Sometimes it is useful to know if a variable is not set and not just set to
`undef`.  This module provides a way to declare a variable as unset and to
check if it is unset.

This is also useful in subroutines signatures where you want to know if a
variable was passed in or not.

```perl
    sub attribute ( $self, $var = unset ) {
        if ( is_set($var) ) {
            $self->{attribute} = $var;
        }
        else {
            return $self->{attribute};
        }
    }
```

In the above example, we implement the popular (if unfortunate) Perl habit of
using a single method as both a getter an setter. If `undef` is a valid value
for C<$var>, then you would not be able to distinguish between `undef` and
not passed in. By using `unset` you can now tell the difference.

# EXPORT

`unset`, `is_unset`, and `is_set` are exported by default.

# FUNCTIONS

## unset

```perl
  my $var = unset;
```

Declares a scalar as unset. Sets the scalar to `undef`.

## is_unset

```perl
  if (is_unset($var)) {
      print "var is unset\n";
  } else {
      print "var is set\n";
  }
```

Returns true if the scalar is unset.

## is_set

```perl
  if (is_set($var)) {
      print "var is set\n";
  } else {
      print "var is unset\n";
  }
```

Returns true if the variable is set (which might be true even if the
variable is undefined).
