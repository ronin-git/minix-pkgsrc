$NetBSD$

--- ym2612/support.h.orig	2012-12-20 19:09:12.000000000 +0000
+++ ym2612/support.h
@@ -3,7 +3,7 @@
 #include "config.h"
 
 #define errorlog 0
-#define INLINE inline
+#define INLINE static inline
 #define HAS_YM2612 1
 #define YM2612UpdateRequest(x) 
 #define AY8910_set_clock(chip,clock) /* */
