# $NetBSD: buildlink3.mk,v 1.11 2012/04/27 12:31:40 obache Exp $

BUILDLINK_TREE+=	sqlite3

.if !defined(SQLITE3_BUILDLINK3_MK)
SQLITE3_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.sqlite3+=	sqlite3>=3.0.8
BUILDLINK_ABI_DEPENDS.sqlite3+=	sqlite3>=3.7.15.2nb1
BUILDLINK_PKGSRCDIR.sqlite3?=	../../databases/sqlite3

pkgbase:= sqlite3
.include "../../mk/pkg-build-options.mk"

.if !empty(PKG_BUILD_OPTIONS.sqlite3:Micu)
.include "../../textproc/icu/buildlink3.mk"
.endif

.endif # SQLITE3_BUILDLINK3_MK

BUILDLINK_TREE+=	-sqlite3
