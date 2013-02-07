# $NetBSD: buildlink3.mk,v 1.14 2012/09/15 10:06:04 obache Exp $

BUILDLINK_TREE+=	linc

.if !defined(LINC_BUILDLINK3_MK)
LINC_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.linc+=	linc>=1.1.1
BUILDLINK_ABI_DEPENDS.linc+=	linc>=1.1.1nb12
BUILDLINK_PKGSRCDIR.linc?=	../../net/linc

.include "../../devel/glib2/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.endif # LINC_BUILDLINK3_MK

BUILDLINK_TREE+=	-linc
