#!/usr/bin/env perl


use Test::More;
use Unset::Vars;

my $var = unset;

ok is_unset($var), 'var should start as unset';
ok !is_unset($var), 'var should not be set';

$var = "something";

ok !is_unset($var), 'var should no longer be unset';
ok is_set($var), 'var should be set';

done_testing;
