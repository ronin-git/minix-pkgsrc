# $NetBSD: Makefile,v 1.38 2012/12/16 01:52:21 obache Exp $

DISTNAME=	libetpan-1.1
PKGREVISION=	2
CATEGORIES=	mail
MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=libetpan/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://libetpan.sourceforge.net/
COMMENT=	Really nice mail library
LICENSE=	modified-bsd

BDB_ACCEPTED=		db3 db4 db5
USE_LANGUAGES=		c c++
USE_LIBTOOL=		yes
GNU_CONFIGURE=		yes
MAKE_JOBS_SAFE=		no

SUBST_CLASSES+=		conf
SUBST_STAGE.conf=	pre-configure
SUBST_FILES.conf=	libetpan-config.in
SUBST_SED.conf=		-e "s|@COMPILERFLAGS@|${COMPILER_RPATH_FLAG}|g"
SUBST_MESSAGE.conf=	Fixing libetpan-config.

LDFLAGS.SunOS+=		-lsocket -lnsl

.include "../../converters/libiconv/buildlink3.mk"
.include "../../security/cyrus-sasl/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../textproc/expat/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bdb.buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
