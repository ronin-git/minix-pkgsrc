# $NetBSD: buildlink3.mk,v 1.19 2011/11/01 06:01:11 sbd Exp $

BUILDLINK_TREE+=	wine

.if !defined(WINE_BUILDLINK3_MK)
WINE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.wine+=	wine>=1.2.0
BUILDLINK_ABI_DEPENDS.wine+=	wine>=1.2.3nb10
BUILDLINK_PKGSRCDIR.wine?=	../../emulators/wine

pkgbase:= wine
.include "../../mk/pkg-build-options.mk"

.include "../../graphics/freetype2/buildlink3.mk"
.if !empty(PKG_BUILD_OPTIONS.wine:Mopengl)
.include "../../graphics/glu/buildlink3.mk"
.include "../../graphics/glut/buildlink3.mk"
.endif
.include "../../mk/giflib.buildlink3.mk"
.include "../../mk/jpeg.buildlink3.mk"
.endif # WINE_BUILDLINK3_MK

BUILDLINK_TREE+=	-wine
