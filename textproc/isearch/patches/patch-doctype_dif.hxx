$NetBSD$

Chase after the C++ standard:
   - string constants are const char *

--- doctype/dif.hxx.orig	2000-10-12 20:55:25.000000000 +0000
+++ doctype/dif.hxx
@@ -98,7 +98,7 @@ public:
   void group();
   void groupbody();
   void textML();
-  void parserError(char *);
+  void parserError(const char *);
   void writeField(char *fld, long start, long stop);
 
   /* 
