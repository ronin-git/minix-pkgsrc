# $NetBSD: buildlink2.mk,v 1.2 2002/08/25 18:39:53 jlam Exp $

.if !defined(LIBMCRYPT_BUILDLINK2_MK)
LIBMCRYPT_BUILDLINK2_MK=	# defined

BUILDLINK_PACKAGES+=		libmcrypt
BUILDLINK_DEPENDS.libmcrypt?=	libmcrypt>=2.5.6
BUILDLINK_PKGSRCDIR.libmcrypt?=	../../security/libmcrypt

EVAL_PREFIX+=				BUILDLINK_PREFIX.libmcrypt=libmcrypt
BUILDLINK_PREFIX.libmcrypt_DEFAULT=	${LOCALBASE}

BUILDLINK_FILES.libmcrypt=	include/mcrypt.h
BUILDLINK_FILES.libmcrypt+=	lib/libmcrypt.*

BUILDLINK_TARGETS+=	libmcrypt-buildlink

libmcrypt-buildlink: _BUILDLINK_USE

.endif	# LIBMCRYPT_BUILDLINK2_MK
