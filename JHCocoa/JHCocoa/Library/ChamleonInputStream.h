//
//  ChamleonInputStream.h
//  Part of ChamleonHTTPRequest -> http://allseeing-i.com/ChamleonHTTPRequest
//
//  Created by Ben Copsey on 10/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChamleonHTTPRequest;

// This is a wrapper for NSInputStream that pretends to be an NSInputStream itself
// Subclassing NSInputStream seems to be tricky, and may involve overriding undocumented methods, so we'll cheat instead.
// It is used by ChamleonHTTPRequest whenever we have a request body, and handles measuring and throttling the bandwidth used for uploading

@interface ChamleonInputStream : NSObject {
	NSInputStream *stream;
	ChamleonHTTPRequest *request;
}
+ (id)inputStreamWithFileAtPath:(NSString *)path request:(ChamleonHTTPRequest *)request;
+ (id)inputStreamWithData:(NSData *)data request:(ChamleonHTTPRequest *)request;

@property (retain, nonatomic) NSInputStream *stream;
@property (assign, nonatomic) ChamleonHTTPRequest *request;
@end
