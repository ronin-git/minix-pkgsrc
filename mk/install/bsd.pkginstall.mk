# $NetBSD: bsd.pkginstall.mk,v 1.15 2005/08/21 22:29:45 rillig Exp $
#
# This Makefile fragment is included by bsd.pkg.mk to use the common
# INSTALL/DEINSTALL scripts.  To use this Makefile fragment, simply:
#
# (1) Set the variables to customize the install scripts to the package, and
# (2) Set USE_PKGINSTALL to YES in the package Makefile.
#
# NOTE: This file must _not_ be included from anything else than bsd.pkg.mk.

.if !defined(BSD_PKG_INSTALL_MK)
BSD_PKG_INSTALL_MK=	1

.include "../../mk/bsd.prefs.mk"

# The Solaris /bin/sh does not know the ${foo#bar} shell substitution.
# This shell function serves a similar purpose, but is specialized on
# stripping ${PREFIX}/ from a pathname. 
_FUNC_STRIP_PREFIX= \
	strip_prefix() {						\
	  ${AWK} 'END {							\
	    plen = length(prefix);					\
	      if (substr(s, 1, plen) == prefix) {			\
	        s = substr(s, 1 + plen, length(s) - plen);		\
	      }								\
	      print s;							\
	    }' s="$$1" prefix=${PREFIX:Q}/ /dev/null;			\
	}

DEINSTALL_FILE=		${PKG_DB_TMPDIR}/+DEINSTALL
INSTALL_FILE=		${PKG_DB_TMPDIR}/+INSTALL

# These are the template scripts for the INSTALL/DEINSTALL scripts.  Packages
# may do additional work in the INSTALL/DEINSTALL scripts by overriding the
# variables DEINSTALL_EXTRA_TMPL and INSTALL_EXTRA_TMPL to point to
# additional script fragments.  These bits are included after the main
# install/deinstall script fragments.  Packages may also override the
# variables DEINSTALL_TMPL and INSTALL_TMPL to completely customize the
# install/deinstall logic.
#
_HEADER_TMPL?=		${.CURDIR}/../../mk/install/header
.if !defined(HEADER_EXTRA_TMPL) && exists(${.CURDIR}/HEADER)
HEADER_EXTRA_TMPL?=	${.CURDIR}/HEADER
.else
HEADER_EXTRA_TMPL?=	# empty
.endif
DEINSTALL_PRE_TMPL?=	${.CURDIR}/../../mk/install/deinstall-pre
DEINSTALL_EXTRA_TMPL?=	# empty
DEINSTALL_TMPL?=	${.CURDIR}/../../mk/install/deinstall
INSTALL_UNPACK_TMPL?=	# empty
INSTALL_TMPL?=		${.CURDIR}/../../mk/install/install
INSTALL_EXTRA_TMPL?=	# empty
INSTALL_POST_TMPL?=	${.CURDIR}/../../mk/install/install-post
_FOOTER_TMPL?=		${.CURDIR}/../../mk/install/footer

# DEINSTALL_TEMPLATES and INSTALL_TEMPLATES are the default list of source
#	files that are concatenated to form the DEINSTALL/INSTALL scripts.
#
DEINSTALL_TEMPLATES=	${_HEADER_TMPL}
DEINSTALL_TEMPLATES+=	${HEADER_EXTRA_TMPL}
DEINSTALL_TEMPLATES+=	${DEINSTALL_PRE_TMPL}
DEINSTALL_TEMPLATES+=	${DEINSTALL_EXTRA_TMPL}
DEINSTALL_TEMPLATES+=	${DEINSTALL_TMPL}
DEINSTALL_TEMPLATES+=	${_FOOTER_TMPL}
INSTALL_TEMPLATES=	${_HEADER_TMPL}
INSTALL_TEMPLATES+=	${HEADER_EXTRA_TMPL}
INSTALL_TEMPLATES+=	${INSTALL_UNPACK_TMPL}
INSTALL_TEMPLATES+=	${INSTALL_TMPL}
INSTALL_TEMPLATES+=	${INSTALL_EXTRA_TMPL}
INSTALL_TEMPLATES+=	${INSTALL_POST_TMPL}
INSTALL_TEMPLATES+=	${_FOOTER_TMPL}

# These are the list of source files that are concatenated to form the
# INSTALL/DEINSTALL scripts.
#
DEINSTALL_SRC?=		${DEINSTALL_TEMPLATES}
INSTALL_SRC?=		${INSTALL_TEMPLATES}

# FILES_SUBST lists what to substitute in DEINSTALL/INSTALL scripts and in
# rc.d scripts.
#
FILES_SUBST+=		PREFIX=${PREFIX}
FILES_SUBST+=		LOCALBASE=${LOCALBASE}
FILES_SUBST+=		X11BASE=${X11BASE}
FILES_SUBST+=		DEPOTBASE=${DEPOTBASE}
FILES_SUBST+=		VARBASE=${VARBASE}
FILES_SUBST+=		PKG_SYSCONFBASE=${PKG_SYSCONFBASE}
FILES_SUBST+=		PKG_SYSCONFDEPOTBASE=${PKG_SYSCONFDEPOTBASE}
FILES_SUBST+=		PKG_SYSCONFBASEDIR=${PKG_SYSCONFBASEDIR}
FILES_SUBST+=		PKG_SYSCONFDIR=${PKG_SYSCONFDIR}
FILES_SUBST+=		CONF_DEPENDS=${CONF_DEPENDS:C/:.*//:Q}
FILES_SUBST+=		PKGBASE=${PKGBASE}
FILES_SUBST+=		PKG_INSTALLATION_TYPE=${PKG_INSTALLATION_TYPE}

# PKG_USERS represents the users to create for the package.  It is a
#	space-separated list of elements of the form
#
#		user:group[:[userid][:[descr][:[home][:shell]]]]
#
#	Only the user and group are required; everything else is optional,
#	but the colons must be in the right places when specifying optional
#	bits.  Note that if the description contains spaces, then spaces
#	should be double backslash-escaped, e.g.
#
#		foo:foogrp::The\\ Foomister
#
# PKG_GROUPS represents the groups to create for the package.  It is a
#	space-separated list of elements of the form
#
#		group[:groupid]
#
#	Only the group is required; the groupid is optional.
#
PKG_GROUPS?=		# empty
PKG_USERS?=		# empty
_PKG_USER_HOME?=	/nonexistent
_PKG_USER_SHELL?=	${NOLOGIN}
FILES_SUBST+=		PKG_USER_HOME=${_PKG_USER_HOME}
FILES_SUBST+=		PKG_USER_SHELL=${_PKG_USER_SHELL}

# Interix is very Special in that users are groups cannot have the
# same name.  Interix.mk tries to work around this by overriding
# some specific package defaults.  If we get here and there's still a
# conflict, add a breakage indicator to make sure the package won't
# compile without changing something.
#
.if !empty(OPSYS:MInterix)
.  for user in ${PKG_USERS:C/\\\\//g:C/:.*//}
.    if !empty(PKG_GROUPS:M${user})
PKG_FAIL_REASON+=	"User and group '${user}' cannot have the same name on Interix"
.    endif
.  endfor
.endif

.if !empty(PKG_USERS) || !empty(PKG_GROUPS)
DEPENDS+=		${_USER_DEPENDS}
.endif

INSTALL_USERGROUP_FILE=	${WRKDIR}/.install-usergroup
INSTALL_UNPACK_TMPL+=	${INSTALL_USERGROUP_FILE}

${INSTALL_USERGROUP_FILE}: ../../mk/install/usergroup
	${_PKG_SILENT}${_PKG_DEBUG}${RM} -f ${.TARGET} ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${PKG_GROUPS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${PKG_USERS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "# start of install-usergroup";				\
	${ECHO} "#";							\
	${ECHO} "# Generate a +USERGROUP script that reference counts users"; \
	${ECHO} "# and groups that are required for the proper functioning"; \
	${ECHO} "# of the package.";					\
	${ECHO} "#";							\
	${ECHO} "case \$${STAGE} in";					\
	${ECHO} "PRE-INSTALL|UNPACK)";					\
	${ECHO} "	\$${CAT} > ./+USERGROUP << 'EOF_USERGROUP'";	\
	${SED} ${FILES_SUBST_SED} ../../mk/install/usergroup;		\
	${ECHO} "";							\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	eval set -- __dummy ${PKG_GROUPS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		i="$$1"; shift;						\
		${ECHO} "# GROUP: $$i";					\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	eval set -- __dummy ${PKG_USERS} __dummy;			\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		i="$$1"; shift;						\
		${ECHO} "# USER: $$i";					\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "EOF_USERGROUP";					\
	${ECHO} "	\$${CHMOD} +x ./+USERGROUP";			\
	${ECHO} "	;;";						\
	${ECHO} "esac";							\
	${ECHO} "";							\
	${ECHO} "# end of install-usergroup";				\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp ||	\
	${MV} -f ${.TARGET}.tmp ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${TOUCH} ${TOUCH_FLAGS} ${.TARGET}

# SPECIAL_PERMS are lists that look like:
#		file user group mode
#	At post-install time, file (it may be a directory) is changed to be
#	owned by user:group with mode permissions.  If a file pathname
#	is relative, then it is taken to be relative to ${PREFIX}.
#
# SPECIAL_PERMS should be used primarily to change permissions of files or
# directories listed in the PLIST.  This may be used to make certain files
# set-uid or to change the ownership or a directory.
#
# SETUID_ROOT_PERMS is a convenience definition to note an executable is
# meant to be setuid-root, and should be used as follows:
#
#	SPECIAL_PERMS+=	/path/to/suidroot ${SETUID_ROOT_PERMS}
#
SPECIAL_PERMS?=		# empty
SETUID_ROOT_PERMS?=	${ROOT_USER} ${ROOT_GROUP} 4711

INSTALL_PERMS_FILE=	${WRKDIR}/.install-perms
INSTALL_UNPACK_TMPL+=	${INSTALL_PERMS_FILE}

${INSTALL_PERMS_FILE}: ../../mk/install/perms
	${_PKG_SILENT}${_PKG_DEBUG}${RM} -f ${.TARGET} ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${SPECIAL_PERMS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "# start of install-perms";				\
	${ECHO} "#";							\
	${ECHO} "# Generate a +PERMS script that sets the special";	\
	${ECHO} "# permissions on files and directories used by the";	\
	${ECHO} "# package.";						\
	${ECHO} "#";							\
	${ECHO} "case \$${STAGE} in";					\
	${ECHO} "PRE-INSTALL|UNPACK)";					\
	${ECHO} "	\$${CAT} > ./+PERMS << 'EOF_PERMS'";		\
	${SED} ${FILES_SUBST_SED} ../../mk/install/perms;		\
	${ECHO} "";							\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${SPECIAL_PERMS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		file="$$1"; owner="$$2"; group="$$3"; mode="$$4";	\
		shift; shift; shift; shift;				\
		file=`strip_prefix "$$file"`;				\
		${ECHO} "# PERMS: $$file $$mode $$owner $$group";	\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "EOF_PERMS";						\
	${ECHO} "	\$${CHMOD} +x ./+PERMS";			\
	${ECHO} "	;;";						\
	${ECHO} "esac";							\
	${ECHO} "";							\
	${ECHO} "# end of install-perms";				\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp ||	\
	${MV} -f ${.TARGET}.tmp ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${TOUCH} ${TOUCH_FLAGS} ${.TARGET}

# CONF_FILES are pairs of example and true config files, used much like
#	MLINKS in the base system.  At post-install time, if the true config
#	file doesn't exist, then the example one is copied into place.  At
#	deinstall time, the true one is removed if it doesn't differ from the
#	example one.  REQD_FILES is the same as CONF_FILES but the value
#	of PKG_CONFIG is ignored; however, all files listed in REQD_FILES
#	should be under ${PREFIX}.
#
# CONF_FILES_MODE and REQD_FILES_MODE are the file permissions for the
# files in CONF_FILES and REQD_FILES, respectively.
#
# CONF_FILES_PERMS are lists that look like:
#
#		example_file config_file user group mode
#
#	and works like CONF_FILES, except the config files are owned by
#	user:group have mode permissions.  REQD_FILES_PERMS is the same
#	as CONF_FILES_PERMS but the value of PKG_CONFIG is ignored;
#	however, all files listed in REQD_FILES_PERMS should be under
#	${PREFIX}.
#
# RCD_SCRIPTS works lists the basenames of the rc.d scripts.  They are
#	expected to be found in ${PREFIX}/share/examples/rc.d, and
#	the scripts will be copied into ${RCD_SCRIPTS_DIR} with
#	${RCD_SCRIPTS_MODE} permissions.
#
# If any file pathnames are relative, then they are taken to be relative
# to ${PREFIX}.
#
CONF_FILES?=		# empty
CONF_FILES_MODE?=	0644
CONF_FILES_PERMS?=	# empty
RCD_SCRIPTS?=		# empty
RCD_SCRIPTS_MODE?=	0755
RCD_SCRIPTS_EXAMPLEDIR=	share/examples/rc.d
RCD_SCRIPTS_SHELL?=	${SH}
FILES_SUBST+=		RCD_SCRIPTS_SHELL=${RCD_SCRIPTS_SHELL}
MESSAGE_SUBST+=		RCD_SCRIPTS_DIR=${RCD_SCRIPTS_DIR}
MESSAGE_SUBST+=		RCD_SCRIPTS_EXAMPLEDIR=${RCD_SCRIPTS_EXAMPLEDIR}

INSTALL_FILES_FILE=	${WRKDIR}/.install-files
INSTALL_UNPACK_TMPL+=	${INSTALL_FILES_FILE}

${INSTALL_FILES_FILE}: ../../mk/install/files
	${_PKG_SILENT}${_PKG_DEBUG}${RM} -f ${.TARGET} ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${RCD_SCRIPTS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${CONF_FILES:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${REQD_FILES:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${CONF_FILES_PERMS:M*:Q}" in				\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${REQD_FILES_PERMS:M*:Q}" in				\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "# start of install-files";				\
	${ECHO} "#";							\
	${ECHO} "# Generate a +FILES script that reference counts config"; \
	${ECHO} "# files that are required for the proper functioning"; \
	${ECHO} "# of the package.";					\
	${ECHO} "#";							\
	${ECHO} "case \$${STAGE} in";					\
	${ECHO} "PRE-INSTALL|UNPACK)";					\
	${ECHO} "	\$${CAT} > ./+FILES << 'EOF_FILES'";		\
	${SED} ${FILES_SUBST_SED} ../../mk/install/files;		\
	${ECHO} "";							\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${RCD_SCRIPTS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		script="$$1"; shift;					\
		file="${RCD_SCRIPTS_DIR:S/^${PREFIX}\///}/$$script";	\
		egfile="${RCD_SCRIPTS_EXAMPLEDIR}/$$script";		\
		${ECHO} "# FILE: $$file cr $$egfile ${RCD_SCRIPTS_MODE}"; \
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${CONF_FILES};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		egfile="$$1"; file="$$2";				\
		shift; shift;						\
		egfile=`strip_prefix "$$egfile"`;			\
		file=`strip_prefix "$$file"`;				\
		${ECHO} "# FILE: $$file c $$egfile ${CONF_FILES_MODE}"; \
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${REQD_FILES};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		egfile="$$1"; file="$$2";				\
		shift; shift;						\
		egfile=`strip_prefix "$$egfile"`;			\
		file=`strip_prefix "$$file"`;				\
		${ECHO} "# FILE: $$file cf $$egfile ${REQD_FILES_MODE}"; \
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${CONF_FILES_PERMS};			\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		egfile="$$1"; file="$$2";				\
		owner="$$3"; group="$$4"; mode="$$5";			\
		shift; shift; shift; shift; shift;			\
		egfile=`strip_prefix "$$egfile"`;			\
		file=`strip_prefix "$$file"`;				\
		${ECHO} "# FILE: $$file c $$egfile $$mode $$owner $$group"; \
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${REQD_FILES_PERMS};			\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		egfile="$$1"; file="$$2";				\
		owner="$$3"; group="$$4"; mode="$$5";			\
		shift; shift; shift; shift; shift;			\
		egfile=`strip_prefix "$$egfile"`;			\
		file=`strip_prefix "$$file"`;				\
		${ECHO} "# FILE: $$file cf $$egfile $$mode $$owner $$group"; \
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "EOF_FILES";						\
	${ECHO} "	\$${CHMOD} +x ./+FILES";			\
	${ECHO} "	;;";						\
	${ECHO} "esac";							\
	${ECHO} "";							\
	${ECHO} "# end of install-files";				\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp ||	\
	${MV} -f ${.TARGET}.tmp ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${TOUCH} ${TOUCH_FLAGS} ${.TARGET}

# OWN_DIRS contains a list of directories for this package that should be
#       created and should attempt to be destroyed by the INSTALL/DEINSTALL
#	scripts.  MAKE_DIRS is used the same way, but the package admin
#	isn't prompted to remove the directory at post-deinstall time if it
#	isn't empty.  REQD_DIRS is like MAKE_DIRS but the value of PKG_CONFIG
#	is ignored; however, all directories listed in REQD_DIRS should
#	be under ${PREFIX}.
#
# OWN_DIRS_PERMS contains a list of "directory owner group mode" sublists
#	representing directories for this package that should be
#	created/destroyed by the INSTALL/DEINSTALL scripts.  MAKE_DIRS_PERMS
#	is used the same way but the package admin isn't prompted to remove
#	the directory at post-deinstall time if it isn't empty.
#	REQD_DIRS_PERMS is like MAKE_DIRS but the value of PKG_CONFIG is
#	ignored; however, all directories listed in REQD_DIRS should be
#	under ${PREFIX}.
#
# If any directory pathnames are relative, then they are taken to be
# relative to ${PREFIX}.
#
MAKE_DIRS?=		# empty
MAKE_DIRS_PERMS?=	# empty
REQD_DIRS?=		# empty
REQD_DIRS_PERMS?=	# empty
OWN_DIRS?=		# empty
OWN_DIRS_PERMS?=	# empty

INSTALL_DIRS_FILE=	${WRKDIR}/.install-dirs
INSTALL_UNPACK_TMPL+=	${INSTALL_DIRS_FILE}

${INSTALL_DIRS_FILE}: ../../mk/install/dirs
	${_PKG_SILENT}${_PKG_DEBUG}${RM} -f ${.TARGET} ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${PKG_SYSCONFSUBDIR:M*:Q}" in				\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${CONF_FILES:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${CONF_FILES_PERMS:M*:Q}" in				\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${RCD_SCRIPTS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${MAKE_DIRS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${REQD_DIRS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${OWN_DIRS:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${MAKE_DIRS_PERMS:M*:Q}" in				\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${REQD_DIRS_PERMS:M*:Q}" in				\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${OWN_DIRS_PERMS:M*:Q}" in				\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "# start of install-dirs";				\
	${ECHO} "#";							\
	${ECHO} "# Generate a +DIRS script that reference counts directories"; \
	${ECHO} "# that are required for the proper functioning of the"; \
	${ECHO} "# package.";						\
	${ECHO} "#";							\
	${ECHO} "case \$${STAGE} in";					\
	${ECHO} "PRE-INSTALL|UNPACK)";					\
	${ECHO} "	\$${CAT} > ./+DIRS << 'EOF_DIRS'";		\
	${SED} ${FILES_SUBST_SED} ../../mk/install/dirs;		\
	${ECHO} "";							\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	case "${PKG_SYSCONFSUBDIR:M*:Q}${CONF_FILES:M*:Q}${CONF_FILES_PERMS:M*Q}" in \
	"")	;;							\
	*)	${ECHO} "# DIR: ${PKG_SYSCONFDIR:S/${PREFIX}\///} m" ;;	\
	esac;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	case "${RCD_SCRIPTS:M*:Q}" in					\
	"")	;;							\
	*)	${ECHO} "# DIR: ${RCD_SCRIPTS_DIR:S/${PREFIX}\///} m" ;; \
	esac;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${MAKE_DIRS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		dir="$$1"; shift;					\
		dir=`strip_prefix "$$dir"`;				\
		${ECHO} "# DIR: $$dir m";				\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${REQD_DIRS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		dir="$$1"; shift;					\
		dir=`strip_prefix "$$dir"`;				\
		${ECHO} "# DIR: $$dir fm";				\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${OWN_DIRS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		dir="$$1"; shift;					\
		dir=`strip_prefix "$$dir"`;				\
		${ECHO} "# DIR: $$dir mo";				\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${MAKE_DIRS_PERMS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		dir="$$1"; owner="$$2"; group="$$3"; mode="$$4";	\
		shift; shift; shift; shift;				\
		dir=`strip_prefix "$$dir"`;				\
		${ECHO} "# DIR: $$dir m $$owner $$group $$mode";	\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${REQD_DIRS_PERMS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		dir="$$1"; owner="$$2"; group="$$3"; mode="$$4";	\
		shift; shift; shift; shift;				\
		dir=`strip_prefix "$$dir"`;				\
		${ECHO} "# DIR: $$dir fm $$owner $$group $$mode";	\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${OWN_DIRS_PERMS};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		dir="$$1"; owner="$$2"; group="$$3"; mode="$$4";	\
		shift; shift; shift; shift;				\
		dir=`strip_prefix "$$dir"`;				\
		${ECHO} "# DIR: $$dir mo $$owner $$group $$mode";	\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "EOF_DIRS";						\
	${ECHO} "	\$${CHMOD} +x ./+DIRS";				\
	${ECHO} "	;;";						\
	${ECHO} "esac";							\
	${ECHO} "";							\
	${ECHO} "# end of install-dirs";				\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp ||	\
	${MV} -f ${.TARGET}.tmp ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${TOUCH} ${TOUCH_FLAGS} ${.TARGET}

# PKG_SHELL contains the pathname of the shell that should be added or
#	removed from the shell database, /etc/shells.  If a pathname
#	is relative, then it is taken to be relative to ${PREFIX}.
#
PKG_SHELL?=		# empty

INSTALL_SHELL_FILE=	${WRKDIR}/.install-shell
INSTALL_UNPACK_TMPL+=	${INSTALL_SHELL_FILE}

${INSTALL_SHELL_FILE}: ../../mk/install/shell
	${_PKG_SILENT}${_PKG_DEBUG}${RM} -f ${.TARGET} ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} -f ${.TARGET}.tmp || {	\
	case "${PKG_SHELL:M*:Q}" in					\
	"")	;;							\
	*)	${TOUCH} ${TOUCH_FLAGS} ${.TARGET}.tmp ;;		\
	esac; }
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "# start of install-shell";				\
	${ECHO} "#";							\
	${ECHO} "# Generate a +SHELL script that handles shell registration."; \
	${ECHO} "#";							\
	${ECHO} "case \$${STAGE} in";					\
	${ECHO} "PRE-INSTALL|UNPACK)";					\
	${ECHO} "	\$${CAT} > ./+SHELL << 'EOF_SHELL'";		\
	${SED} ${FILES_SUBST_SED} ../../mk/install/shell;		\
	${ECHO} "";							\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${_FUNC_STRIP_PREFIX};		\
	${TEST} ! -f ${.TARGET}.tmp || {				\
	eval set -- __dummy ${PKG_SHELL};				\
	while ${TEST} $$# -gt 0; do					\
		if ${TEST} "$$1" = "__dummy"; then shift; continue; fi;	\
		shell="$$1"; shift;					\
		shell=`strip_prefix "$$shell"`;				\
		${ECHO} "# SHELL: $$shell";				\
	done;								\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp || {	\
	${ECHO} "EOF_SHELL";						\
	${ECHO} "	\$${CHMOD} +x ./+SHELL";			\
	${ECHO} "	;;";						\
	${ECHO} "esac";							\
	${ECHO} "";							\
	${ECHO} "# end of install-shell";				\
	} >> ${.TARGET}.tmp
	${_PKG_SILENT}${_PKG_DEBUG}${TEST} ! -f ${.TARGET}.tmp ||	\
	${MV} -f ${.TARGET}.tmp ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${TOUCH} ${TOUCH_FLAGS} ${.TARGET}

# PKG_CREATE_USERGROUP indicates whether the INSTALL script should
#	automatically add any needed users/groups to the system using
#	useradd/groupadd.  It is either YES or NO and defaults to YES.
#
# PKG_CONFIG indicates whether the INSTALL/DEINSTALL scripts should do
#	automatic config file and directory handling, or if it should
#	merely inform the admin of the list of required files and
#	directories needed to use the package.  It is either YES or NO
#	and defaults to YES.
#
# PKG_RCD_SCRIPTS indicates whether to automatically install rc.d scripts
#	to ${RCD_SCRIPTS_DIR}.  It is either YES or NO and defaults to
#	NO.  This variable only takes effect if ${PKG_CONFIG} == "YES".
#
# PKG_REGISTER_SHELLS indicates whether to automatically register shells
#	in /etc/shells.  It is either YES or NO and defaults to YES.
#
# These values merely set the defaults for INSTALL/DEINSTALL scripts, but
# they may be overridden by resetting them in the environment.
#
PKG_CREATE_USERGROUP?=	YES
PKG_CONFIG?=		YES
PKG_RCD_SCRIPTS?=	NO
PKG_REGISTER_SHELLS?=	YES
FILES_SUBST+=		PKG_CREATE_USERGROUP=${PKG_CREATE_USERGROUP}
FILES_SUBST+=		PKG_CONFIG=${PKG_CONFIG}
FILES_SUBST+=		PKG_RCD_SCRIPTS=${PKG_RCD_SCRIPTS}
FILES_SUBST+=		PKG_REGISTER_SHELLS=${PKG_REGISTER_SHELLS}

# Substitute for various programs used in the DEINSTALL/INSTALL scripts and
# in the rc.d scripts.
#
FILES_SUBST+=		AWK=${AWK:Q}
FILES_SUBST+=		BASENAME=${BASENAME:Q}
FILES_SUBST+=		CAT=${CAT:Q}
FILES_SUBST+=		CHGRP=${CHGRP:Q}
FILES_SUBST+=		CHMOD=${CHMOD:Q}
FILES_SUBST+=		CHOWN=${CHOWN:Q}
FILES_SUBST+=		CMP=${CMP:Q}
FILES_SUBST+=		CP=${CP:Q}
FILES_SUBST+=		DIRNAME=${DIRNAME:Q}
FILES_SUBST+=		ECHO=${ECHO:Q}
FILES_SUBST+=		ECHO_N=${ECHO_N:Q}
FILES_SUBST+=		EGREP=${EGREP:Q}
FILES_SUBST+=		EXPR=${EXPR:Q}
FILES_SUBST+=		FALSE=${FALSE:Q}
FILES_SUBST+=		FIND=${FIND:Q}
FILES_SUBST+=		GREP=${GREP:Q}
FILES_SUBST+=		GROUPADD=${GROUPADD:Q}
FILES_SUBST+=		GTAR=${GTAR:Q}
FILES_SUBST+=		HEAD=${HEAD:Q}
FILES_SUBST+=		ID=${ID:Q}
FILES_SUBST+=		INSTALL_INFO=${INSTALL_INFO:Q}
FILES_SUBST+=		LINKFARM=${LINKFARM:Q}
FILES_SUBST+=		LN=${LN:Q}
FILES_SUBST+=		LS=${LS:Q}
FILES_SUBST+=		MKDIR=${MKDIR:Q}
FILES_SUBST+=		MV=${MV:Q}
FILES_SUBST+=		PERL5=${PERL5:Q}
FILES_SUBST+=		PKG_ADMIN=${PKG_ADMIN_CMD:Q}
FILES_SUBST+=		PKG_INFO=${PKG_INFO_CMD:Q}
FILES_SUBST+=		PWD_CMD=${PWD_CMD:Q}
FILES_SUBST+=		RM=${RM:Q}
FILES_SUBST+=		RMDIR=${RMDIR:Q}
FILES_SUBST+=		SED=${SED:Q}
FILES_SUBST+=		SETENV=${SETENV:Q}
FILES_SUBST+=		SH=${SH:Q}
FILES_SUBST+=		SORT=${SORT:Q}
FILES_SUBST+=		SU=${SU:Q}
FILES_SUBST+=		TEST=${TEST:Q}
FILES_SUBST+=		TOUCH=${TOUCH:Q}
FILES_SUBST+=		TR=${TR:Q}
FILES_SUBST+=		TRUE=${TRUE:Q}
FILES_SUBST+=		USERADD=${USERADD:Q}
FILES_SUBST+=		XARGS=${XARGS:Q}

FILES_SUBST_SED=	${FILES_SUBST:S/=/@!/:S/$/!g/:S/^/ -e s!@/}

PKG_REFCOUNT_DBDIR?=	${PKG_DBDIR}.refcount

INSTALL_SCRIPTS_ENV=	PKG_PREFIX=${PREFIX}
INSTALL_SCRIPTS_ENV+=	PKG_METADATA_DIR=${_PKG_DBDIR}/${PKGNAME}
INSTALL_SCRIPTS_ENV+=	PKG_REFCOUNT_DBDIR=${PKG_REFCOUNT_DBDIR}

.PHONY: pre-install-script post-install-script

pre-install-script: generate-install-scripts
	${_PKG_SILENT}${_PKG_DEBUG}cd ${PKG_DB_TMPDIR} &&		\
		${SETENV} ${INSTALL_SCRIPTS_ENV}			\
		${_PKG_DEBUG_SCRIPT} ${INSTALL_FILE} ${PKGNAME} PRE-INSTALL

post-install-script:
	${_PKG_SILENT}${_PKG_DEBUG}cd ${PKG_DB_TMPDIR} &&		\
		${SETENV} ${INSTALL_SCRIPTS_ENV}			\
		${_PKG_DEBUG_SCRIPT} ${INSTALL_FILE} ${PKGNAME} POST-INSTALL

.PHONY: generate-install-scripts
post-build: generate-install-scripts
generate-install-scripts:	# do nothing

.if !empty(DEINSTALL_SRC)
generate-install-scripts: ${DEINSTALL_FILE}
${DEINSTALL_FILE}: ${DEINSTALL_SRC}
	${_PKG_SILENT}${_PKG_DEBUG}${MKDIR} ${.TARGET:H}
	${_PKG_SILENT}${_PKG_DEBUG}${CAT} ${.ALLSRC} |			\
		${SED} ${FILES_SUBST_SED} > ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${CHMOD} +x ${.TARGET}
.endif

.if !empty(INSTALL_SRC)
generate-install-scripts: ${INSTALL_FILE}
${INSTALL_FILE}: ${INSTALL_SRC}
	${_PKG_SILENT}${_PKG_DEBUG}${MKDIR} ${.TARGET:H}
	${_PKG_SILENT}${_PKG_DEBUG}${CAT} ${.ALLSRC} |			\
		${SED} ${FILES_SUBST_SED} > ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${CHMOD} +x ${.TARGET}
.endif

# rc.d scripts are automatically generated and installed into the rc.d
# scripts example directory at the post-install step.  The following
# variables are relevent to this process:
#
# RCD_SCRIPTS			lists the basenames of the rc.d scripts
#
# RCD_SCRIPT_SRC.<script>	the source file for <script>; this will
#				be run through FILES_SUBST to generate
#				the rc.d script (defaults to
#				${FILESDIR}/<script>.sh)
#
# If the source rc.d script is not present, then the automatic handling
# doesn't occur.

.PHONY: generate-rcd-scripts
post-build: generate-rcd-scripts
generate-rcd-scripts:	# do nothing

.PHONY: install-rcd-scripts
post-install: install-rcd-scripts
install-rcd-scripts:	# do nothing

.for _script_ in ${RCD_SCRIPTS}
RCD_SCRIPT_SRC.${_script_}?=	${FILESDIR}/${_script_}.sh
RCD_SCRIPT_WRK.${_script_}?=	${WRKDIR}/${_script_}

.  if !empty(RCD_SCRIPT_SRC.${_script_})
.    if exists(${RCD_SCRIPT_SRC.${_script_}})
generate-rcd-scripts: ${RCD_SCRIPT_WRK.${_script_}}
${RCD_SCRIPT_WRK.${_script_}}: ${RCD_SCRIPT_SRC.${_script_}}
	@${ECHO_MSG} "${_PKGSRC_IN}> Creating ${.TARGET}"
	${_PKG_SILENT}${_PKG_DEBUG}${CAT} ${.ALLSRC} |			\
		${SED} ${FILES_SUBST_SED} > ${.TARGET}
	${_PKG_SILENT}${_PKG_DEBUG}${CHMOD} +x ${.TARGET}

install-rcd-scripts: install-rcd-${_script_}
install-rcd-${_script_}: ${RCD_SCRIPT_WRK.${_script_}}
	${_PKG_SILENT}${_PKG_DEBUG}					\
	if [ -f ${RCD_SCRIPT_WRK.${_script_}} ]; then			\
		${MKDIR} ${PREFIX}/${RCD_SCRIPTS_EXAMPLEDIR};		\
		${INSTALL_SCRIPT} ${RCD_SCRIPT_WRK.${_script_}}		\
			${PREFIX}/${RCD_SCRIPTS_EXAMPLEDIR}/${_script_}; \
	fi
.    endif
.  endif
.endfor

.endif	# BSD_PKG_INSTALL_MK
