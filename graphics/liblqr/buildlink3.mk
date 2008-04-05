# $NetBSD$

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
LIBLQR_BUILDLINK3_MK:=	${LIBLQR_BUILDLINK3_MK}+

.if ${BUILDLINK_DEPTH} == "+"
BUILDLINK_DEPENDS+=	liblqr
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nliblqr}
BUILDLINK_PACKAGES+=	liblqr
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}liblqr

.if ${LIBLQR_BUILDLINK3_MK} == "+"
BUILDLINK_API_DEPENDS.liblqr+=	liblqr>=0.1.0.2
BUILDLINK_PKGSRCDIR.liblqr?=	../../graphics/liblqr
.endif	# LIBLQR_BUILDLINK3_MK

.include "../../devel/glib2/buildlink3.mk"

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
