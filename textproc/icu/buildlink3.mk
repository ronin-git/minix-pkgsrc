# $NetBSD$
#

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
ICU_BUILDLINK3_MK:=	${ICU_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	icu
.endif

.if !empty(ICU_BUILDLINK3_MK:M+)
BUILDLINK_PACKAGES+=			icu
BUILDLINK_DEPENDS.icu?=		icu>=2.6.1
BUILDLINK_PKGSRCDIR.icu?=		../../textproc/icu

.endif # ICU_BUILDLINK3_MK

BUILDLINK_DEPTH:=     ${BUILDLINK_DEPTH:S/+$//}
