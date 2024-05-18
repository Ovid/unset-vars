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
    SV* sv = newSV(0);  // Create a new undefined scalar
    sv_magicext(sv, NULL, PERL_MAGIC_ext, &unset_mg_vtbl, NULL, 0);
    return sv;
}
#define unset() S_unset(aTHX)

#define is_unset(sv) cBOOL(mg_findext(sv, PERL_MAGIC_ext, &unset_mg_vtbl))
#define is_set(sv) (!is_unset(sv))

MODULE = Unset::Vars    PACKAGE = Unset::Vars

PROTOTYPES: DISABLE

SV* unset()

bool is_unset(SV *sv)

bool is_set(SV *sv)
