#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

typedef struct {
    int is_unset;
} unset_t;

static int unset_mg_get(pTHX_ SV *sv, MAGIC *mg) {
    PerlIO_printf(PerlIO_stderr(), "unset_mg_get: Called, sv=%p, mg=%p\n", sv, mg);
    return 0;
}

static int unset_mg_set(pTHX_ SV *sv, MAGIC *mg) {
    PerlIO_printf(PerlIO_stderr(), "unset_mg_set: Called, sv=%p, mg=%p\n", sv, mg);
    unset_t *unset_info = (unset_t *)mg->mg_ptr;
    unset_info->is_unset = 0;
    sv_unmagic(sv, PERL_MAGIC_ext);
    return 0;
}

static int unset_mg_free(pTHX_ SV *sv, MAGIC *mg) {
    PerlIO_printf(PerlIO_stderr(), "unset_mg_free: Called, sv=%p, mg=%p\n", sv, mg);
    Safefree(mg->mg_ptr);
    return 0;
}

static const MGVTBL unset_mg_vtbl = {
    unset_mg_get,
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

    PerlIO_printf(PerlIO_stderr(), "get_unset: Allocated unset_info, address=%p\n", unset_info);

    mg = sv_magicext(sv, NULL, PERL_MAGIC_ext, &unset_mg_vtbl, NULL, 0);
    if (mg) {
        mg->mg_ptr = (char *)unset_info;
        PerlIO_printf(PerlIO_stderr(), "get_unset: Attached magic to SV, mg_ptr=%p\n", mg->mg_ptr);
    } else {
        PerlIO_printf(PerlIO_stderr(), "get_unset: Failed to attach magic to SV\n");
    }

    SvREFCNT_inc_simple_void_NN(sv);  // Increment reference count to prevent premature garbage collection
    PerlIO_printf(PerlIO_stderr(), "get_unset: Incremented reference count, SvREFCNT=%u\n", SvREFCNT(sv));

    return sv;
}

int is_unset(pTHX_ SV *sv) {
    MAGIC *mg;

    PerlIO_printf(PerlIO_stderr(), "is_unset: Checking SV=%p\n", sv);

    if (SvTYPE(sv) >= SVt_PVAV) {
        croak("is_unset can only be applied to scalars");
    }

    mg = mg_find(sv, PERL_MAGIC_ext);
    if (mg) {
        PerlIO_printf(PerlIO_stderr(), "is_unset: Found magic, mg_ptr=%p, mg_virtual=%p\n", mg->mg_ptr, mg->mg_virtual);
        if (mg->mg_virtual == &unset_mg_vtbl) {
            unset_t *unset_info = (unset_t *)mg->mg_ptr;
            PerlIO_printf(PerlIO_stderr(), "is_unset: Found unset_mg_vtbl magic, is_unset=%d, address=%p\n", unset_info->is_unset, unset_info);
            return unset_info->is_unset;
        } else {
            PerlIO_printf(PerlIO_stderr(), "is_unset: Found magic, but not unset_mg_vtbl\n");
        }
    } else {
        PerlIO_printf(PerlIO_stderr(), "is_unset: No magic found\n");
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
    CODE:
    RETVAL = is_unset(aTHX_ sv);
    OUTPUT:
    RETVAL

bool
is_set(SV *sv)
    CODE:
    RETVAL = is_set(aTHX_ sv);
    OUTPUT:
    RETVAL

