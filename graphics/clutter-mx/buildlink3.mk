# $NetBSD$

BUILDLINK_TREE+=	clutter-mx

.if !defined(CLUTTER_MX_BUILDLINK3_MK)
CLUTTER_MX_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.clutter-mx+=	clutter-mx>=1.0.3
BUILDLINK_PKGSRCDIR.clutter-mx?=	../../graphics/clutter-mx

.include "../../graphics/clutter/buildlink3.mk"
.include "../../x11/libXrandr/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif	# CLUTTER_MX_BUILDLINK3_MK

BUILDLINK_TREE+=	-clutter-mx
