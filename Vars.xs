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

static SV* S_unset(pTHX) {
    SV *sv;
    MAGIC *mg;

    sv = newSV(0);  // Create a new undefined scalar

    sv_magicext(sv, NULL, PERL_MAGIC_ext, &unset_mg_vtbl, NULL, 0);

    // I don't think is needed, but I'm trying to figure out why this doesn't
    // work
    SvREFCNT_inc_simple_void_NN(sv);  // Increment reference count to prevent premature garbage collection

    return sv;
}
#define unset() S_unset(aTHX)

static bool S_is_unset(pTHX_ SV *sv) {
    MAGIC *mg;

    if (SvTYPE(sv) >= SVt_PVAV) {
        croak("is_unset can only be applied to scalars");
    }

    mg = mg_findext(sv, PERL_MAGIC_ext, &unset_mg_vtbl);
    return cBOOL(mg);
}
#define is_unset(sv) S_is_unset(aTHX_ sv)
#define is_set(sv) (!is_unset(sv))

MODULE = Unset::Vars    PACKAGE = Unset::Vars

PROTOTYPES: DISABLE

SV* unset()

bool is_unset(SV *sv)

bool is_set(SV *sv)
