# $NetBSD: Makefile,v 1.3 2013/02/06 23:21:50 jperkin Exp $
#

DISTNAME=	Phone-0.3.11
PKGNAME=	deforaos-phone-0.3.11
PKGREVISION=	3
CATEGORIES=	comms net
MASTER_SITES=	http://www.defora.org/os/download/download/3721/

MAINTAINER=	khorben@defora.org
HOMEPAGE=	http://www.defora.org/
COMMENT=	DeforaOS desktop telephony

LICENSE=	gnu-gpl-v3

USE_TOOLS+=	pkg-config
USE_TOOLS+=	xgettext

MAKE_FLAGS+=	DESTDIR=${DESTDIR}
MAKE_FLAGS+=	PREFIX=${PREFIX}

.include "options.mk"

.include "../../x11/gtk2/buildlink3.mk"
.include "../../audio/pulseaudio/buildlink3.mk"
.include "../../chat/libpurple/buildlink3.mk"
.include "../../devel/sofia-sip/buildlink3.mk"
.include "../../x11/deforaos-locker/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../mk/bsd.pkg.mk"
