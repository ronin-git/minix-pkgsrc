# $NetBSD: buildlink3.mk,v 1.5 2006/07/08 23:10:38 jlam Exp $

BUILDLINK_TREE+=	synce-librapi2

.if !defined(SYNCE_LIBRAPI2_BUILDLINK3_MK)
SYNCE_LIBRAPI2_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.synce-librapi2+=	synce-librapi2>=0.9.1
BUILDLINK_PKGSRCDIR.synce-librapi2?=	../../comms/synce-librapi2

.include "../../comms/synce-libsynce/buildlink3.mk"
.endif # SYNCE_LIBRAPI2_BUILDLINK3_MK

BUILDLINK_TREE+=	-synce-librapi2
