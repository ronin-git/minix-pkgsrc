# $NetBSD: buildlink3.mk,v 1.2 2005/12/31 12:32:33 wiz Exp $

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH}+
LIBGNOMEMM_BUILDLINK3_MK:=	${LIBGNOMEMM_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	libgnomemm
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nlibgnomemm}
BUILDLINK_PACKAGES+=	libgnomemm

.if !empty(LIBGNOMEMM_BUILDLINK3_MK:M+)
BUILDLINK_DEPENDS.libgnomemm+=	libgnomemm>=2.10.0
BUILDLINK_RECOMMENDED.libgnomemm?=	libgnomemm>=2.12.0nb1
BUILDLINK_PKGSRCDIR.libgnomemm?=	../../devel/libgnomemm
.endif	# LIBGNOMEMM_BUILDLINK3_MK

.include "../../devel/libgnome/buildlink3.mk"
.include "../../x11/gtkmm/buildlink3.mk"

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
