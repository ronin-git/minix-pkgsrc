$NetBSD$

--- kcontrol/kfontinst/kfontinst/GetPid.c.orig	2013-01-14 15:01:36.000000000 +0000
+++ kcontrol/kfontinst/kfontinst/GetPid.c
@@ -28,6 +28,10 @@
 ////////////////////////////////////////////////////////////////////////////////
 */
 
+#ifdef __NetBSD__
+#define _KMEMUSER
+#endif
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
