# $NetBSD: Makefile,v 1.4 2013/02/16 11:22:59 wiz Exp $
#

DISTNAME=	Mailer-0.1.5
PKGNAME=	deforaos-mailer-0.1.5
PKGREVISION=	2
CATEGORIES=	mail
MASTER_SITES=	http://www.defora.org/os/download/download/3704/

MAINTAINER=	khorben@defora.org
HOMEPAGE=	http://www.defora.org/
COMMENT=	DeforaOS desktop e-mail client
LICENSE=	gnu-gpl-v3

BUILD_DEPENDS+=	libxslt-[0-9]*:../../textproc/libxslt
BUILD_DEPENDS+=	docbook-xsl-[0-9]*:../../textproc/docbook-xsl

USE_TOOLS+=	pkg-config
USE_TOOLS+=	xgettext

MAKE_JOBS_SAFE=	no

MAKE_FLAGS+=	DESTDIR=${DESTDIR}
MAKE_FLAGS+=	PREFIX=${PREFIX}
AUTO_MKDIRS=	yes

CONFLICTS=	john-[0-9]*

post-install:
	${MV} ${DESTDIR}${PREFIX}/share/man/man1/compose.1 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1/compose.1
	${MV} ${DESTDIR}${PREFIX}/share/man/man1/mailer.1 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1/mailer.1
	${RMDIR} ${DESTDIR}${PREFIX}/share/man/man1
	${RMDIR} ${DESTDIR}${PREFIX}/share/man

.include "options.mk"

.include "../../security/openssl/buildlink3.mk"
.include "../../x11/deforaos-libdesktop/buildlink3.mk"
.include "../../textproc/gtk-doc/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../mk/bsd.pkg.mk"
