$NetBSD$

--- pdns/misc.hh.orig	2011-11-23 15:48:44.000000000 +0000
+++ pdns/misc.hh
@@ -19,6 +19,7 @@
 #ifndef MISC_HH
 #define MISC_HH
 #include <stdint.h>
+#include <string.h>
 
 #if 0
 #define RDTSC(qp) \