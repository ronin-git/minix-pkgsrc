# $NetBSD: Makefile,v 1.19 2012/10/23 18:16:42 asau Exp $
#

DISTNAME=		Crypt-Primes-0.50
PKGNAME=		p5-${DISTNAME}
PKGREVISION=		6
SVR4_PKGNAME=		p5cpr
CATEGORIES=		security perl5
MASTER_SITES=		${MASTER_SITE_PERL_CPAN:=Crypt/}

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		http://search.cpan.org/dist/Crypt-Primes/
COMMENT=		Perl5 module for provable prime number generation

PKG_INSTALLATION_TYPES=	overwrite pkgviews

DEPENDS+=		p5-Math-Pari>=2.001804:../../math/p5-Math-Pari
DEPENDS+=		p5-Crypt-Random>=0.33:../../security/p5-Crypt-Random

USE_LANGUAGES=		# empty
PERL5_PACKLIST=		auto/Crypt/Primes/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
