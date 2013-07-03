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

#define SETRC(rc) \
    { \
        SV * i = get_sv("Unqlite::rc", GV_ADD); \
        SvIV_set(i, rc); \
    }

/*
    { HV * const stash = gv_stashpvn("Unqlite", strlen("Unqlite"), TRUE); \
    (void)hv_store(stash, "rc", 2, newSViv(rc), 0); } */


MODULE = Unqlite    PACKAGE = Unqlite

PROTOTYPES: DISABLE

BOOT:
    HV* stash = gv_stashpvn("Unqlite", strlen("Unqlite"), TRUE);
    newCONSTSUB(stash, "UNQLITE_OK", newSViv(UNQLITE_OK));
    newCONSTSUB(stash, "UNQLITE_NOMEM", newSViv(UNQLITE_NOMEM));
    newCONSTSUB(stash, "UNQLITE_ABORT", newSViv(UNQLITE_ABORT));
    newCONSTSUB(stash, "UNQLITE_IOERR", newSViv(UNQLITE_IOERR));
    newCONSTSUB(stash, "UNQLITE_CORRUPT", newSViv(UNQLITE_CORRUPT));
    newCONSTSUB(stash, "UNQLITE_LOCKED", newSViv(UNQLITE_LOCKED));
    newCONSTSUB(stash, "UNQLITE_BUSY", newSViv(UNQLITE_BUSY));
    newCONSTSUB(stash, "UNQLITE_DONE", newSViv(UNQLITE_DONE));
    newCONSTSUB(stash, "UNQLITE_PERM", newSViv(UNQLITE_PERM));
    newCONSTSUB(stash, "UNQLITE_NOTIMPLEMENTED", newSViv(UNQLITE_NOTIMPLEMENTED));
    newCONSTSUB(stash, "UNQLITE_NOTFOUND", newSViv(UNQLITE_NOTFOUND));
    newCONSTSUB(stash, "UNQLITE_NOOP", newSViv(UNQLITE_NOOP));
    newCONSTSUB(stash, "UNQLITE_INVALID", newSViv(UNQLITE_INVALID));
    newCONSTSUB(stash, "UNQLITE_EOF", newSViv(UNQLITE_EOF));
    newCONSTSUB(stash, "UNQLITE_UNKNOWN", newSViv(UNQLITE_UNKNOWN));
    newCONSTSUB(stash, "UNQLITE_LIMIT", newSViv(UNQLITE_LIMIT));
    newCONSTSUB(stash, "UNQLITE_EXISTS", newSViv(UNQLITE_EXISTS));
    newCONSTSUB(stash, "UNQLITE_EMPTY", newSViv(UNQLITE_EMPTY));
    newCONSTSUB(stash, "UNQLITE_COMPILE_ERR", newSViv(UNQLITE_COMPILE_ERR));
    newCONSTSUB(stash, "UNQLITE_VM_ERR", newSViv(UNQLITE_VM_ERR));
    newCONSTSUB(stash, "UNQLITE_FULL", newSViv(UNQLITE_FULL));
    newCONSTSUB(stash, "UNQLITE_CANTOPEN", newSViv(UNQLITE_CANTOPEN));
    newCONSTSUB(stash, "UNQLITE_READ_ONLY", newSViv(UNQLITE_READ_ONLY));
    newCONSTSUB(stash, "UNQLITE_LOCKERR", newSViv(UNQLITE_LOCKERR));

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
    SETRC(rc);
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
    SETRC(rc);
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
    SETRC(rc);
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
    SETRC(rc);
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
    SETRC(rc);
    if (rc!=UNQLITE_OK) {
        RETVAL = &PL_sv_undef;
        goto last;
    }
    Newxz(buf, nbytes, char);
    rc = unqlite_kv_fetch(pdb, key_c, key_l, buf, &nbytes);
    SETRC(rc);
    sv = newSVpv(buf, nbytes);
    Safefree(buf);
    RETVAL = sv;
    last:
OUTPUT:
    RETVAL

void
DESTROY(self)
    SV * self;
PREINIT:
    int rc;
CODE:
    unqlite *pdb = XS_STATE(unqlite*, self);
    rc = unqlite_close(pdb);
    SETRC(rc);

