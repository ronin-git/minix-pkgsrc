$NetBSD$

--- client.cc.orig	2011-11-25 13:56:08.000000000 +0000
+++ client.cc
@@ -6,6 +6,7 @@
  */
  
 #include "aewm.hh"
+#include <cstring>
 
 Client::Client(Display *d, Window new_client)
 {
