# $NetBSD$

.if !defined(LIBGNOMEPRINT_BUILDLINK2_MK)
LIBGNOMEPRINT_BUILDLINK2_MK=	# defined

BUILDLINK_PACKAGES+=			libgnomeprint
BUILDLINK_DEPENDS.libgnomeprint?=	libgnomeprint>=1.116.0
BUILDLINK_PKGSRCDIR.libgnomeprint?=	../../print/libgnomeprint

EVAL_PREFIX+=			BUILDLINK_PREFIX.libgnomeprint=libgnomeprint
BUILDLINK_PREFIX.libgnomeprint_DEFAULT=	${X11PREFIX}
BUILDLINK_FILES.libgnomeprint=	bin/libgnomeprint-2.0-font-install
BUILDLINK_FILES.libgnomeprint+=	include/libgnomeprint-2.0/libgnomeprint/*
BUILDLINK_FILES.libgnomeprint+=	include/libgnomeprint-2.0/libgnomeprint/private/*
BUILDLINK_FILES.libgnomeprint+=	lib/gnome-print-2.0/drivers/*
BUILDLINK_FILES.libgnomeprint+=	lib/gnome-print-2.0/transports/*
BUILDLINK_FILES.libgnomeprint+=	lib/libgnomeprint-2.*
BUILDLINK_FILES.libgnomeprint+=	lib/pkgconfig/libgnomeprint-2.0.pc

.include "../../devel/libbonobo/buildlink2.mk"
.include "../../devel/pango/buildlink2.mk"
.include "../../devel/ptl2/buildlink2.mk"
.include "../../graphics/freetype2/buildlink2.mk"
.include "../../graphics/libart2/buildlink2.mk"

BUILDLINK_TARGETS+=	libgnomeprint-buildlink

libgnomeprint-buildlink: _BUILDLINK_USE

.endif	# LIBGNOMEPRINT_BUILDLINK2_MK
