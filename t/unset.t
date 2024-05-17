#!/usr/bin/env perl

use Test::More;
use Unset::Vars;

my $var = unset;

ok is_unset($var), 'var should start as unset';

$var = "something";

ok !is_unset($var), 'var should no longer be unset';

done_testing;
