# $NetBSD: site.config.m4,v 1.4 2006/06/07 14:48:28 joerg Exp $

# pathnames specific to pkgsrc
#
define(`confEBINDIR', `${PREFIX}/libexec/sendmail')
define(`confMBINDIR', `${PREFIX}/libexec/sendmail')
define(`confSBINDIR', `${PREFIX}/sbin')
define(`confUBINDIR', `${PREFIX}/bin')
define(`confHFDIR', `${PREFIX}/share/misc')
define(`confINSTALL_RAWMAN', 'yes')
define(`confDONT_INSTALL_CATMAN', 'yes')
define(`confMANROOT', `${PREFIX}/${PKGMANDIR}/man')
define(`confMANROOTMAN', `${PREFIX}/${PKGMANDIR}/man')
define(`confMAN1EXT', `1')
define(`confMAN3EXT', `3')
define(`confMAN4EXT', `4')
define(`confMAN5EXT', `5')
define(`confMAN8EXT', `8')
APPENDDEF(`confENVDEF', `-I${PREFIX}/include')
APPENDDEF(`confLIBS', `-L${PREFIX}/lib')
