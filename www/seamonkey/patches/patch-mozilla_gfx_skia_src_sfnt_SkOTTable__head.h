$NetBSD$

--- mozilla/gfx/skia/src/sfnt/SkOTTable_head.h.orig	2013-01-06 06:26:15.000000000 +0000
+++ mozilla/gfx/skia/src/sfnt/SkOTTable_head.h
@@ -12,7 +12,7 @@
 #include "SkOTTableTypes.h"
 #include "SkTypedEnum.h"
 
-#pragma pack(push, 1)
+#pragma pack(1)
 
 struct SkOTTableHead {
     static const SK_OT_CHAR TAG0 = 'h';
@@ -140,7 +140,7 @@ struct SkOTTableHead {
     } glyphDataFormat;
 };
 
-#pragma pack(pop)
+#pragma pack()
 
 
 #include <stddef.h>
