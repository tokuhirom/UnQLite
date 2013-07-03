#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT /* we want efficiency */
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#define NEED_newSVpvn_flags
#include "ppport.h"
#include <unqlite.h>

#define XS_STATE(type, x)     (INT2PTR(type, SvROK(x) ? SvIV(SvRV(x)) : SvIV(x)))

/* #define XS_STRUCT2OBJ(sv, class, obj)     if (obj == NULL) {         sv_setsv(sv, &PL_sv_undef);     } else {         sv_setref_pv(sv, class, (void *) obj);     } */
#define XS_STRUCT2OBJ(sv, class, obj) \
    sv = newSViv(PTR2IV(obj));  \
        sv = newRV_noinc(sv); \
            sv_bless(sv, gv_stashpv(class, 1)); \
                SvREADONLY_on(sv);



MODULE = Unqlite    PACKAGE = Unqlite

PROTOTYPES: DISABLE

SV*
open(klass, filename, mode=UNQLITE_OPEN_CREATE)
    const char *klass;
    const char *filename;
    int mode;
PREINIT:
    SV *sv;
    unqlite *pdb;
    int rc;
CODE:
    rc = unqlite_open(&pdb, filename, mode);
    if (rc == UNQLITE_OK) {
        XS_STRUCT2OBJ(sv, klass, pdb);
        RETVAL = sv;
    } else {
        RETVAL = &PL_sv_undef;
    }
OUTPUT:
    RETVAL

SV*
kv_store(self, key_sv, data_sv)
    SV *self;
    SV *key_sv;
    SV *data_sv;
PREINIT:
    char *key_c;
    STRLEN key_l;
    char *data_c;
    STRLEN data_l;
    int rc;
CODE:
    unqlite *pdb = XS_STATE(unqlite*, self);
    key_c = SvPV(key_sv, key_l);
    data_c = SvPV(data_sv, data_l);
    rc = unqlite_kv_store(pdb, key_c, key_l, data_c, data_l);
    if (rc==UNQLITE_OK) {
        RETVAL = &PL_sv_yes;
    } else {
        RETVAL = &PL_sv_undef;
    }
OUTPUT:
    RETVAL

SV*
kv_append(self, key_sv, data_sv)
    SV *self;
    SV *key_sv;
    SV *data_sv;
PREINIT:
    char *key_c;
    STRLEN key_l;
    char *data_c;
    STRLEN data_l;
    int rc;
CODE:
    unqlite *pdb = XS_STATE(unqlite*, self);
    key_c = SvPV(key_sv, key_l);
    data_c = SvPV(data_sv, data_l);
    rc = unqlite_kv_append(pdb, key_c, key_l, data_c, data_l);
    if (rc==UNQLITE_OK) {
        RETVAL = &PL_sv_yes;
    } else {
        RETVAL = &PL_sv_undef;
    }
OUTPUT:
    RETVAL

SV*
kv_delete(self, key_sv)
    SV *self;
    SV *key_sv;
PREINIT:
    char *key_c;
    STRLEN key_l;
    int rc;
CODE:
    unqlite *pdb = XS_STATE(unqlite*, self);
    key_c = SvPV(key_sv, key_l);
    rc = unqlite_kv_delete(pdb, key_c, key_l);
    if (rc==UNQLITE_OK) {
        RETVAL = &PL_sv_yes;
    } else {
        RETVAL = &PL_sv_undef;
    }
OUTPUT:
    RETVAL

SV*
kv_fetch(self, key_sv)
    SV *self;
    SV *key_sv;
PREINIT:
    char *key_c;
    STRLEN key_l;
    char *buf;
    int rc;
    unqlite_int64 nbytes;
    SV *sv;
CODE:
    unqlite *pdb = XS_STATE(unqlite*, self);
    key_c = SvPV(key_sv, key_l);

    /* Allocate a buffer big enough to hold the record content */
    rc = unqlite_kv_fetch(pdb, key_c, key_l, NULL, &nbytes);
    if (rc!=UNQLITE_OK) {
        RETVAL = &PL_sv_undef;
        goto last;
    }
    Newxz(buf, nbytes, char);
    unqlite_kv_fetch(pdb, key_c, key_l, buf, &nbytes);
    sv = newSVpv(buf, nbytes);
    Safefree(buf);
    RETVAL = sv;
    last:
OUTPUT:
    RETVAL

void
DESTROY(self)
    SV * self;
CODE:
    unqlite *pdb = XS_STATE(unqlite*, self);
    unqlite_close(pdb);

