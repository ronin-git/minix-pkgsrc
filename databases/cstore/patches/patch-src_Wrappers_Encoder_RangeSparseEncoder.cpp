$NetBSD$

Add missing header.

--- src/Wrappers/Encoder/RangeSparseEncoder.cpp.orig	2006-09-07 23:39:00.000000000 +0000
+++ src/Wrappers/Encoder/RangeSparseEncoder.cpp
@@ -31,6 +31,7 @@
 // Encodes Sparse Pages
 
 #include "RangeSparseEncoder.h"
+#include <stdlib.h>
 
 RangeSparseEncoder::RangeSparseEncoder(Operator* dataSrc_, int colIndex_, int fieldSize, int bfrSizeInBits_) : Encoder(dataSrc_, colIndex_)
 {
