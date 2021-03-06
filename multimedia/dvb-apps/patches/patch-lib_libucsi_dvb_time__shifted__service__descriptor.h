$NetBSD$

--- lib/libucsi/dvb/time_shifted_service_descriptor.h.orig	2011-06-28 05:50:24.000000000 +0000
+++ lib/libucsi/dvb/time_shifted_service_descriptor.h
@@ -51,7 +51,7 @@ static inline struct dvb_time_shifted_se
 	if (d->len != (sizeof(struct dvb_time_shifted_service_descriptor) - 2))
 		return NULL;
 
-	bswap16((uint8_t*) d + 2);
+	ubswap16((uint8_t*) d + 2);
 
 	return (struct dvb_time_shifted_service_descriptor*) d;
 }
