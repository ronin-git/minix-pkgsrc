# $NetBSD: options.mk,v 1.1 2005/05/31 21:36:36 wiz Exp $

.include "../../mk/bsd.prefs.mk"

.if ${MACHINE_ARCH} == "i386"
PKG_OPTIONS_VAR=	PKG_OPTIONS.imlib2
PKG_SUPPORTED_OPTIONS=	mmx

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mmmx)
CONFIGURE_ARGS+=	--enable-mmx
.endif
.endif
