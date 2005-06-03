# $NetBSD: builtin.mk,v 1.7 2005/06/03 16:03:09 jlam Exp $

BUILTIN_PKG:=	xcursor

BUILTIN_FIND_FILES_VAR:=	H_XCURSOR
BUILTIN_FIND_FILES.H_XCURSOR=	${X11BASE}/include/X11/Xcursor/Xcursor.h

.include "../../mk/buildlink3/bsd.builtin.mk"

###
### Determine if there is a built-in implementation of the package and
### set IS_BUILTIN.<pkg> appropriately ("yes" or "no").
###
.if !defined(IS_BUILTIN.xcursor)
IS_BUILTIN.xcursor=	no
.  if exists(${H_XCURSOR})
PKGSRC_USE_TOOLS+=	imake			# XXX
IMAKE?=			${X11BASE}/bin/imake	# XXX
_BUILTIN_IMAKE_CMD=	${IMAKE:C/^/_asdf_/1:M_asdf_*:S/^_asdf_//}
.    if exists(${_BUILTIN_IMAKE_CMD})
IS_BUILTIN.xcursor!=							\
	dir=`cd ${BUILDLINK_PKGSRCDIR.xcursor} && ${PWD_CMD}`;		\
	cd ${TMPDIR:U/tmp:Q} && 					\
	${IMAKE} -DUseInstalled -I${X11BASE}/lib/X11/config		\
		-f $$dir/builtin-imake.mk -C builtin-imake.$$$$.c	\
		-s - |							\
	${IMAKE_MAKE} -f - builtin-test
.    endif
.  endif
.endif
MAKEVARS+=	IS_BUILTIN.xcursor

###
### If there is a built-in implementation, then set BUILTIN_PKG.<pkg> to
### a package name to represent the built-in package.
###
.if !defined(BUILTIN_PKG.xcursor) && \
    !empty(IS_BUILTIN.xcursor:M[yY][eE][sS]) && \
    exists(${H_XCURSOR})
BUILTIN_VERSION.xcursor!=						\
	${AWK} '/\#define[ 	]*XCURSOR_(LIB_)?MAJOR/ { M = $$3 }	\
		/\#define[ 	]*XCURSOR_(LIB_)?MINOR/ { m = "."$$3 }	\
		/\#define[ 	]*XCURSOR_(LIB_)?REVISION/ { r = "."$$3 } \
		END { printf "%s%s%s\n", M, m, r }'			\
		${H_XCURSOR}
BUILTIN_PKG.xcursor=	xcursor-${BUILTIN_VERSION.xcursor}
.endif
MAKEVARS+=	BUILTIN_PKG.xcursor

###
### Determine whether we should use the built-in implementation if it
### exists, and set USE_BUILTIN.<pkg> appropriate ("yes" or "no").
###
.if defined(USE_BUILTIN.Xfixes) && !empty(USE_BUILTIN.Xfixes:M[nN][oO])
USE_BUILTIN.xcursor=	no
.endif
.if defined(USE_BUILTIN.Xrender) && !empty(USE_BUILTIN.Xrender:M[nN][oO])
USE_BUILTIN.xcursor=	no
.endif

.if !defined(USE_BUILTIN.xcursor)
.  if ${PREFER.xcursor} == "pkgsrc"
USE_BUILTIN.xcursor=	no
.  else
USE_BUILTIN.xcursor=	${IS_BUILTIN.xcursor}
.    if defined(BUILTIN_PKG.xcursor) && \
        !empty(IS_BUILTIN.xcursor:M[yY][eE][sS])
USE_BUILTIN.xcursor=	yes
.      for _dep_ in ${BUILDLINK_DEPENDS.xcursor}
.        if !empty(USE_BUILTIN.xcursor:M[yY][eE][sS])
USE_BUILTIN.xcursor!=							\
	if ${PKG_ADMIN} pmatch ${_dep_:Q} ${BUILTIN_PKG.xcursor:Q}; then \
		${ECHO} yes;						\
	else								\
		${ECHO} no;						\
	fi
.        endif
.      endfor
.    endif
.  endif  # PREFER.xcursor
.endif
MAKEVARS+=	USE_BUILTIN.xcursor

###
### The section below only applies if we are not including this file
### solely to determine whether a built-in implementation exists.
###
CHECK_BUILTIN.xcursor?=	no
.if !empty(CHECK_BUILTIN.xcursor:M[nN][oO])

.  if !empty(USE_BUILTIN.xcursor:M[nN][oO])
BUILDLINK_DEPENDS.xcursor+=	xcursor>=1.1.1
BUILDLINK_DEPENDS.Xrender+=	Xrender>=0.8
.    for _mkfile_ in buildlink3.mk builtin.mk
BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
.      sinclude "../../x11/Xfixes/${_mkfile_}"
BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
.    endfor
.  endif

.  if !empty(USE_BUILTIN.xcursor:M[yY][eE][sS])
BUILDLINK_PREFIX.xcursor=	${X11BASE}
BUILDLINK_FILES.xcursor+=	lib/pkgconfig/xcursor.pc
USE_BUILTIN.Xrender=		yes
.  endif

.endif	# CHECK_BUILTIN.xcursor
