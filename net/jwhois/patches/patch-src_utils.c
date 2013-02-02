$NetBSD$

--- src/utils.c.orig	2007-06-26 07:00:20.000000000 +0000
+++ src/utils.c
@@ -288,7 +288,7 @@ make_connect(const char *host, int port)
 
       retlen = sizeof(retval);
       error = getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &retval, &retlen);
-      if (error < 0 || retval)
+      if (error < 0 || !retval)
 	{
 	  break;
 	}
