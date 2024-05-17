package Unset::Vars;

use strict;
use warnings;
require Exporter;
require XSLoader;

our @ISA = qw(Exporter);
our @EXPORT = qw(unset is_unset);

our $VERSION = '0.01';

XSLoader::load('unset', $VERSION);

1;
