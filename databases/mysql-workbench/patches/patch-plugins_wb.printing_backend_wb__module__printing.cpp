$NetBSD$

--- plugins/wb.printing/backend/wb_module_printing.cpp.orig	2013-03-02 20:19:58.000000000 +0000
+++ plugins/wb.printing/backend/wb_module_printing.cpp
@@ -54,7 +54,7 @@
   {\
     app_PluginRef plugin(get_grt());\
     app_PluginObjectInputRef pdef(get_grt());\
-    plugin->name("wb.print."aName);\
+    plugin->name("wb.print." aName);\
     plugin->caption(aCaption);\
     plugin->moduleName("WbPrinting");\
     plugin->moduleFunctionName(aName);\
