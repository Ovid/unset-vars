use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Unset::Vars',
    VERSION_FROM => 'lib/Unset/Vars.pm',
    XS           => { 'unset.xs' => 'unset.c' },
    PM           => { 'lib/Unset/Vars.pm' => '$(INST_LIBDIR)/Unset/Vars.pm' },
	OBJECT       => '$(O_FILES)',
);
