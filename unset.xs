#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

typedef struct {
    bool is_unset;
} unset_magic;

static int unset_get_magic(pTHX_ SV *sv, MAGIC *mg) {
    // If magic is applied, the variable appears undef
    if (((unset_magic *)mg->mg_ptr)->is_unset) {
        sv_setsv(sv, &PL_sv_undef);
    }
    return 0;
}

static int unset_set_magic(pTHX_ SV *sv, MAGIC *mg) {
    // If we set the variable, we remove the magic
    ((unset_magic *)mg->mg_ptr)->is_unset = 0;
    sv_unmagic(sv, 'u');
    return 0;
}

static int unset_free_magic(pTHX_ SV *sv, MAGIC *mg) {
    Safefree(mg->mg_ptr);
    return 0;
}

// Define the magic vtbl
static const MGVTBL unset_magic_vtbl = {
    unset_get_magic,
    unset_set_magic,
    NULL,           // len
    NULL,           // clear
    unset_free_magic,
	NULL,           // copy
    NULL,           // local
};

SV *unset() {
	MAGIC *mg;
    unset_magic *unset_info;
    SV *sv = newSV(0);

    Newx(unset_info, 1, unset_magic);
    unset_info->is_unset = 1;

    sv_magicext(sv, NULL, PERL_MAGIC_ext, &unset_magic_vtbl, (const char *)unset_info, 0);

    return sv;
}

bool is_unset(SV *sv) {
    MAGIC *mg = mg_find(sv, PERL_MAGIC_ext);
    if (mg && ((unset_magic *)mg->mg_ptr)->is_unset) {
        return 1;
    }
    return 0;
}

MODULE = unset            PACKAGE = unset

PROTOTYPES: ENABLE

SV *
unset()

bool
is_unset(SV *sv)

