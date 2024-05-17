#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

typedef struct {
    int is_unset;
} unset_t;

static int unset_mg_set(pTHX_ SV *sv, MAGIC *mg) {
    unset_t *unset_info = (unset_t *)mg->mg_ptr;
    unset_info->is_unset = 0;
    sv_unmagic(sv, PERL_MAGIC_ext);
    return 0;
}

static int unset_mg_free(pTHX_ SV *sv, MAGIC *mg) {
    Safefree(mg->mg_ptr);
    return 0;
}

static const MGVTBL unset_mg_vtbl = {
    NULL,
    unset_mg_set,
    NULL,
    NULL,
    unset_mg_free,
};

SV* get_unset(pTHX) {
    SV *sv;
    MAGIC *mg;
    unset_t *unset_info;

    sv = newSV(0);  // Create a new undefined scalar
    Newx(unset_info, 1, unset_t);
    unset_info->is_unset = 1;

    sv_magicext(sv, NULL, PERL_MAGIC_ext, &unset_mg_vtbl, (const char *)unset_info, 0);

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

    mg = mg_find(sv, PERL_MAGIC_ext);
    if (mg && mg->mg_virtual == &unset_mg_vtbl) {
        unset_t *unset_info = (unset_t *)mg->mg_ptr;
        return unset_info->is_unset;
    }

    return 0;
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

