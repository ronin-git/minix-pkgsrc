$NetBSD$

--- src/core/modules/Skybright.cpp.orig	2012-08-26 10:23:18.000000000 +0000
+++ src/core/modules/Skybright.cpp
@@ -33,6 +33,8 @@
 #undef FS
 #endif
 
+#undef FS
+
 Skybright::Skybright() : SN(1.f)
 {
 	setDate(2003, 8, 0);
