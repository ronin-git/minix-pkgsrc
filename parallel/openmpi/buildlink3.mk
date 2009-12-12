# $NetBSD$

BUILDLINK_TREE+=	openmpi

.if !defined(OPENMPI_BUILDLINK3_MK)
OPENMPI_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.openmpi+=	openmpi>=1.2.6
BUILDLINK_PKGSRCDIR.openmpi?=	../../parallel/openmpi
.endif # OPENMPI_BUILDLINK3_MK

BUILDLINK_TREE+=	-openmpi
