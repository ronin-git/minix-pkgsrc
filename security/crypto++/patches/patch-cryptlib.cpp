$NetBSD$

--- cryptlib.cpp.orig	2012-12-21 21:38:50.000000000 +0000
+++ cryptlib.cpp
@@ -29,7 +29,7 @@ CRYPTOPP_COMPILE_ASSERT(sizeof(dword) ==
 #endif
 
 const std::string BufferedTransformation::NULL_CHANNEL;
-const NullNameValuePairs g_nullNameValuePairs;
+NullNameValuePairs g_nullNameValuePairs;
 
 BufferedTransformation & TheBitBucket()
 {
