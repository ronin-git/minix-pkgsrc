# $NetBSD: buildlink3.mk,v 1.2 2004/03/05 19:25:43 jlam Exp $

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
XOSD_BUILDLINK3_MK:=	${XOSD_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	xosd
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nxosd}
BUILDLINK_PACKAGES+=	xosd

.if !empty(XOSD_BUILDLINK3_MK:M+)
BUILDLINK_DEPENDS.xosd+=	xosd>=2.2.12
BUILDLINK_PKGSRCDIR.xosd?=	../../x11/xosd
.endif	# XOSD_BUILDLINK3_MK

BUILDLINK_DEPTH:=     ${BUILDLINK_DEPTH:S/+$//}
