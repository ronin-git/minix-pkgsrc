# $NetBSD: Makefile,v 1.2 2012/10/23 17:18:37 asau Exp $
#

DISTNAME=		modcap.c
PKGNAME=		modcap-0.0.5
PKGREVISION=		1
CATEGORIES=		net security
MASTER_SITES=		http://www.emcy.it/Linux/files/
EXTRACT_SUFX=		# empty

MAINTAINER=		agc@NetBSD.org
COMMENT=		Command line utility to modify pcap capture files
LICENSE=		gnu-gpl-v2

AUTO_MKDIRS=		yes

WRKSRC=			${WRKDIR}

do-build:
	cd ${WRKSRC} && ${CC} -I${PREFIX}/include modcap.c -lm -lpcap -o modcap

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/modcap ${DESTDIR}${PREFIX}/bin/

.include "../../net/libpcap/buildlink3.mk"

.include "../../mk/bsd.pkg.mk"
