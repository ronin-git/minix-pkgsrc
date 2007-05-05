# $NetBSD$

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH}+
PY24_SSLCRYPTO_BUILDLINK3_MK:=	${PY24_SSLCRYPTO_BUILDLINK3_MK}+

.if ${BUILDLINK_DEPTH} == "+"
BUILDLINK_DEPENDS+=	py24-SSLCrypto
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Npy24-SSLCrypto}
BUILDLINK_PACKAGES+=	py24-SSLCrypto
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}py24-SSLCrypto

.if ${PY24_SSLCRYPTO_BUILDLINK3_MK} == "+"
BUILDLINK_API_DEPENDS.py24-SSLCrypto+=	py24-SSLCrypto>=0.1.1
BUILDLINK_PKGSRCDIR.py24-SSLCrypto?=	../../security/py-SSLCrypto
.endif	# PY24_SSLCRYPTO_BUILDLINK3_MK

#.include "../../security/openssl/buildlink3.mk"

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH:S/+$//}
