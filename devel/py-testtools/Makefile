# $NetBSD: Makefile,v 1.7 2012/10/31 11:19:35 asau Exp $
#

DISTNAME=	testtools-0.9.24
PKGNAME=	${PYPKGPREFIX}-${DISTNAME}
CATEGORIES=	devel
MASTER_SITES=	http://launchpad.net/testtools/0.9/${PKGVERSION_NOREV}/+download/ \
		http://launchpadlibrarian.net/126150325/

MAINTAINER=	obache@NetBSD.org
HOMEPAGE=	http://launchpad.net/testtools
COMMENT=	Extensions to the Python standard library unit testing framework
LICENSE=	mit AND python-software-foundation

USE_LANGUAGES=	# none

PYTHON_VERSIONS_INCLUDE_3X=	yes

.include "../../lang/python/distutils.mk"
.include "../../mk/bsd.pkg.mk"
