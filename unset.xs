#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static int unset_mg_set(pTHX_ SV *sv, MAGIC *mg);

static const MGVTBL unset_mg_vtbl = {
    NULL,
    unset_mg_set,
};

static int unset_mg_set(pTHX_ SV *sv, MAGIC *mg) {
    sv_unmagicext(sv, PERL_MAGIC_ext, &unset_mg_vtbl);
    return 0;
}

SV* get_unset(pTHX) {
    SV *sv;
    MAGIC *mg;

    sv = newSV(0);  // Create a new undefined scalar

    sv_magicext(sv, NULL, PERL_MAGIC_ext, &unset_mg_vtbl, NULL, 0);

    // I don't think is needed, but I'm trying to figure out why this doesn't
    // work
    SvREFCNT_inc_simple_void_NN(sv);  // Increment reference count to prevent premature garbage collection

    return sv;
}

int is_unset(pTHX_ SV *sv) {
    MAGIC *mg;

    if (SvTYPE(sv) >= SVt_PVAV) {
        croak("is_unset can only be applied to scalars");
    }

    mg = mg_findext(sv, PERL_MAGIC_ext, &unset_mg_vtbl);
    return cBOOL(mg);
}

int is_set(pTHX_ SV *sv) {
    return !is_unset(aTHX_ sv);  // Return true if SV is not unset
}

MODULE = Unset::Vars    PACKAGE = Unset::Vars

SV*
unset()
    CODE:
    RETVAL = get_unset(aTHX);
    OUTPUT:
    RETVAL

bool
is_unset(SV *sv)
    PROTOTYPE: $
    CODE:
    RETVAL = is_unset(aTHX_ sv);
    OUTPUT:
    RETVAL

bool
is_set(SV *sv)
    PROTOTYPE: $
    CODE:
    RETVAL = is_set(aTHX_ sv);
    OUTPUT:
    RETVAL

