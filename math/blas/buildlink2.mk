# $NetBSD: buildlink2.mk,v 1.2 2002/08/25 19:23:06 jlam Exp $

.if !defined(BLAS_BUILDLINK2_MK)
BLAS_BUILDLINK2_MK=	# defined

BUILDLINK_PACKAGES+=		blas
BUILDLINK_DEPENDS.blas?=	blas>=1.0
BUILDLINK_PKGSRCDIR.blas?=	../../math/blas
BUILDLINK_DEPMETHOD.blas?=	build

EVAL_PREFIX+=			BUILDLINK_PREFIX.blas=blas
BUILDLINK_PREFIX.blas_DEFAULT=	${LOCALBASE}
BUILDLINK_FILES.blas=		lib/libblas* 

BUILDLINK_TARGETS+=		blas-buildlink

blas-buildlink: _BUILDLINK_USE

.endif	# BLAS_BUILDLINK2_MK
