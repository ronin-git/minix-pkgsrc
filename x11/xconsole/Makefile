# $NetBSD: Makefile,v 1.9 2012/10/29 05:07:00 asau Exp $
#

DISTNAME=	xconsole-1.0.5
CATEGORIES=	x11
MASTER_SITES=	${MASTER_SITE_XORG:=app/}
EXTRACT_SUFX=	.tar.bz2

MAINTAINER=	joerg@NetBSD.org
HOMEPAGE=	http://xorg.freedesktop.org/
COMMENT=	X11 client to display console messages

GNU_CONFIGURE=	yes
USE_TOOLS+=	pkg-config

CONFIGURE_ENV+=		APP_MAN_SUFFIX=1

MAKE_FLAGS+=		appdefaultdir=${PREFIX}/lib/X11/app-defaults

.include "../../x11/libXaw/buildlink3.mk"
.include "../../x11/libXt/buildlink3.mk"

.include "../../mk/bsd.pkg.mk"
