//
//  ChamleonHTTPRequestDelegate.h
//  Part of ChamleonHTTPRequest -> http://allseeing-i.com/ChamleonHTTPRequest
//
//  Created by Ben Copsey on 13/04/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//

@class ChamleonHTTPRequest;

@protocol ChamleonHTTPRequestDelegate <NSObject>

@optional

// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
- (void)requestStarted:(ChamleonHTTPRequest *)request;
- (void)request:(ChamleonHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)request:(ChamleonHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;
- (void)requestFinished:(ChamleonHTTPRequest *)request;
- (void)requestFailed:(ChamleonHTTPRequest *)request;
- (void)requestRedirected:(ChamleonHTTPRequest *)request;

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector
- (void)request:(ChamleonHTTPRequest *)request didReceiveData:(NSData *)data;

// If a delegate implements one of these, it will be asked to supply credentials when none are available
// The delegate can then either restart the request ([request retryUsingSuppliedCredentials]) once credentials have been set
// or cancel it ([request cancelAuthentication])
- (void)authenticationNeededForRequest:(ChamleonHTTPRequest *)request;
- (void)proxyAuthenticationNeededForRequest:(ChamleonHTTPRequest *)request;

@end


@protocol ChamleonProgressDelegate <NSObject>

@optional

// These methods are used to update UIProgressViews (iPhone OS) or NSProgressIndicators (Mac OS X)
// If you are using a custom progress delegate, you may find it eChamleoner to implement didReceiveBytes / didSendBytes instead
#if TARGET_OS_IPHONE
- (void)setProgress:(float)newProgress;
#else
- (void)setDoubleValue:(double)newProgress;
- (void)setMaxValue:(double)newMax;
#endif

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ChamleonHTTPRequest *)request didReceiveBytes:(long long)bytes;

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(ChamleonHTTPRequest *)request didSendBytes:(long long)bytes;

// Called when a request needs to change the length of the content to download
- (void)request:(ChamleonHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength;

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ChamleonHTTPRequest *)request incrementUploadSizeBy:(long long)newLength;
@end


// Cache policies control the behaviour of a cache and how requests use the cache
// When setting a cache policy, you can use a combination of these values as a bitmask
// For example: [request setCachePolicy:ChamleonAskServerIfModifiedCachePolicy|ChamleonFallbackToCacheIfLoadFailsCachePolicy|ChamleonDoNotWriteToCacheCachePolicy];
// Note that some of the behaviours below are mutally exclusive - you cannot combine ChamleonAskServerIfModifiedWhenStaleCachePolicy and ChamleonAskServerIfModifiedCachePolicy, for example.
typedef enum _ChamleonCachePolicy {
    
	// The default cache policy. When you set a request to use this, it will use the cache's defaultCachePolicy
	// ChamleonDownloadCache's default cache policy is 'ChamleonAskServerIfModifiedWhenStaleCachePolicy'
	ChamleonUseDefaultCachePolicy = 0,
    
	// Tell the request not to read from the cache
	ChamleonDoNotReadFromCacheCachePolicy = 1,
    
	// The the request not to write to the cache
	ChamleonDoNotWriteToCacheCachePolicy = 2,
    
	// Ask the server if there is an updated version of this resource (using a conditional GET) ONLY when the cached data is stale
	ChamleonAskServerIfModifiedWhenStaleCachePolicy = 4,
    
	// Always ask the server if there is an updated version of this resource (using a conditional GET)
	ChamleonAskServerIfModifiedCachePolicy = 8,
    
	// If cached data exists, use it even if it is stale. This means requests will not talk to the server unless the resource they are requesting is not in the cache
	ChamleonOnlyLoadIfNotCachedCachePolicy = 16,
    
	// If cached data exists, use it even if it is stale. If cached data does not exist, stop (will not set an error on the request)
	ChamleonDontLoadCachePolicy = 32,
    
	// Specifies that cached data may be used if the request fails. If cached data is used, the request will succeed without error. Usually used in combination with other options above.
	ChamleonFallbackToCacheIfLoadFailsCachePolicy = 64
} ChamleonCachePolicy;

// Cache storage policies control whether cached data persists between application launches (ChamleonCachePermanentlyCacheStoragePolicy) or not (ChamleonCacheForSessionDurationCacheStoragePolicy)
// Calling [ChamleonHTTPRequest clearSession] will remove any data stored using ChamleonCacheForSessionDurationCacheStoragePolicy
typedef enum _ChamleonCacheStoragePolicy {
	ChamleonCacheForSessionDurationCacheStoragePolicy = 0,
	ChamleonCachePermanentlyCacheStoragePolicy = 1
} ChamleonCacheStoragePolicy;


@protocol ChamleonCacheDelegate <NSObject>

@required

// Should return the cache policy that will be used when requests have their cache policy set to ChamleonUseDefaultCachePolicy
- (ChamleonCachePolicy)defaultCachePolicy;

// Returns the date a cached response should expire on. Pass a non-zero max age to specify a custom date.
- (NSDate *)expiryDateForRequest:(ChamleonHTTPRequest *)request maxAge:(NSTimeInterval)maxAge;

// Updates cached response headers with a new expiry date. Pass a non-zero max age to specify a custom date.
- (void)updateExpiryForRequest:(ChamleonHTTPRequest *)request maxAge:(NSTimeInterval)maxAge;

// Looks at the request's cache policy and any cached headers to determine if the cache data is still valid
- (BOOL)canUseCachedDataForRequest:(ChamleonHTTPRequest *)request;

// Removes cached data for a particular request
- (void)removeCachedDataForRequest:(ChamleonHTTPRequest *)request;

// Should return YES if the cache considers its cached response current for the request
// Should return NO is the data is not cached, or (for example) if the cached headers state the request should have expired
- (BOOL)isCachedDataCurrentForRequest:(ChamleonHTTPRequest *)request;

// Should store the response for the passed request in the cache
// When a non-zero maxAge is passed, it should be used as the expiry time for the cached response
- (void)storeResponseForRequest:(ChamleonHTTPRequest *)request maxAge:(NSTimeInterval)maxAge;

// Removes cached data for a particular url
- (void)removeCachedDataForURL:(NSURL *)url;

// Should return an NSDictionary of cached headers for the passed URL, if it is stored in the cache
- (NSDictionary *)cachedResponseHeadersForURL:(NSURL *)url;

// Should return the cached body of a response for the passed URL, if it is stored in the cache
- (NSData *)cachedResponseDataForURL:(NSURL *)url;

// Returns a path to the cached response data, if it exists
- (NSString *)pathToCachedResponseDataForURL:(NSURL *)url;

// Returns a path to the cached response headers, if they url
- (NSString *)pathToCachedResponseHeadersForURL:(NSURL *)url;

// Returns the location to use to store cached response headers for a particular request
- (NSString *)pathToStoreCachedResponseHeadersForRequest:(ChamleonHTTPRequest *)request;

// Returns the location to use to store a cached response body for a particular request
- (NSString *)pathToStoreCachedResponseDataForRequest:(ChamleonHTTPRequest *)request;

// Clear cached data stored for the passed storage policy
- (void)clearCachedResponsesForStoragePolicy:(ChamleonCacheStoragePolicy)cachePolicy;

@end

