use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'unset',
    VERSION_FROM => 'lib/unset.pm',
    XS           => { 'unset.xs' => 'unset.c' },
    PM           => { 'lib/unset.pm' => '$(INST_LIBDIR)/unset.pm' },
);
