# $NetBSD: Makefile,v 1.1.1.1 2009/04/25 12:36:01 rh Exp $
#

DISTNAME=	xml2-0.4
CATEGORIES=	textproc
MASTER_SITES=	http://download.ofb.net/gale/

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://www.ofb.net/~egnor/xml2/
COMMENT=	Tools to convert XML and HTML to and from a line-oriented format
LICENSE=	gnu-gpl-v2

GNU_CONFIGURE=	yes
USE_TOOLS+=	pkg-config

.include "../../textproc/libxml/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
