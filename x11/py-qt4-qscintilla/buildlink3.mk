# $NetBSD: buildlink3.mk,v 1.18 2013/01/26 21:36:56 adam Exp $

BUILDLINK_TREE+=	py-qt4-qscintilla

.if !defined(PY_QT4_QSCINTILLA_BUILDLINK3_MK)
PY_QT4_QSCINTILLA_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.py-qt4-qscintilla+=	${PYPKGPREFIX}-qt4-qscintilla>=2.4.3
BUILDLINK_ABI_DEPENDS.py-qt4-qscintilla+=	py27-qt4-qscintilla>=2.6.2nb6
BUILDLINK_PKGSRCDIR.py-qt4-qscintilla?=	../../x11/py-qt4-qscintilla

.include "../../x11/py-sip/buildlink3.mk"
.include "../../x11/py-qt4/buildlink3.mk"
.include "../../x11/qt4-qscintilla/buildlink3.mk"
.include "../../x11/qt4-libs/buildlink3.mk"
.endif	# PY_QT4_QSCINTILLA_BUILDLINK3_MK

BUILDLINK_TREE+=	-py-qt4-qscintilla
