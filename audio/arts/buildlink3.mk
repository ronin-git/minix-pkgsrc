# $NetBSD$

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
ARTS_BUILDLINK3_MK:=	${ARTS_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	arts
.endif

.if !empty(ARTS_BUILDLINK3_MK:M+)
BUILDLINK_PACKAGES+=		arts
BUILDLINK_DEPENDS.arts?=	arts>=1.1.4nb1
BUILDLINK_PKGSRCDIR.arts?=	../../audio/arts

.  include "../../audio/libaudiofile/buildilnk3.mk"
.  include "../../audio/libogg/buildilnk3.mk"
.  include "../../audio/libvorbis/buildilnk3.mk"
.  include "../../mk/ossaudio.buildilnk3.mk"
.endif	# ARTS_BUILDLINK3_MK

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
