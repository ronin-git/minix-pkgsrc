$NetBSD$

--- lib/Support/Unix/Program.inc.orig	Thu Nov 24 15:07:52 2011
+++ lib/Support/Unix/Program.inc
@@ -376,7 +376,11 @@ Program::Wait(const sys::Path &path,
     }
   } else if (WIFSIGNALED(status)) {
     if (ErrMsg) {
+#ifdef __minix
+      *ErrMsg = "Signaled";
+#else
       *ErrMsg = strsignal(WTERMSIG(status));
+#endif
 #ifdef WCOREDUMP
       if (WCOREDUMP(status))
         *ErrMsg += " (core dumped)";