$NetBSD$

--- lib/libucsi/dvb/partial_transport_stream_descriptor.h.orig	2011-06-28 05:50:24.000000000 +0000
+++ lib/libucsi/dvb/partial_transport_stream_descriptor.h
@@ -56,7 +56,7 @@ static inline struct dvb_partial_transpo
 	if (d->len != (sizeof(struct dvb_partial_transport_stream_descriptor) - 2))
 		return NULL;
 
-	bswap64((uint8_t*) d + 2);
+	ubswap64((uint8_t*) d + 2);
 
 	return (struct dvb_partial_transport_stream_descriptor*) d;
 }
