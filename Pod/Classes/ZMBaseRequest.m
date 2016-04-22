//
//  ZMBaseRequest.m
//  Pods
//
//  Created by Abe on 16/4/18.
//
//

#import "AFNetworking.h"
#import "ZMBaseRequest.h"
#import "ZMNetworkAgent.h"

@implementation ZMBaseRequest

#pragma mark - Main Methods
- (void)start {
    [[ZMNetworkAgent sharedInstance] addRequest:self];
}

- (void)stop {
    self.delegate = nil;
    [[ZMNetworkAgent sharedInstance] cancleRequest:self];
}

- (void)pause {
    [[ZMNetworkAgent sharedInstance] suspendsRequest:self];
}

//TODO: block 回调 start

//TODO: block 回调 stop

- (void)clearCompletionBlock {
    
}

#pragma mark - Overriding Methods
- (NSString *)requestUrl {
    return nil;
}

- (NSString *)cdnUrl {
    return nil;
}

- (NSString *)baseUrl {
    return nil;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60.0f;
}

- (id)requestArgument {
    return nil;
}

- (ZMHttpMethod)requestMethod {
    return ZMHttpMethodGet;
}

- (ZMRequestSerializerType)requestSerializerType {
    return ZMRequestSerializerTypeHTTP;
}

- (ZMResponseSerializerType)responseSerializerType {
    return ZMResponseSerializerTypeJSON;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}

- (NSString *)resumableDownloadPath {
    return nil;
}

- (AFURLSessionDataTaskDidReceiveDataBlock)dataTaskDidReceiveDataBlock {
    return nil;
}

- (AFURLSessionDataTaskDidReceiveResponseBlock)dataTaskReceiveResponseBlock {
    return nil;
}

- (AFURLSessionTaskProgressBlock)uploadProgressBlock {
    return nil;
}

- (AFURLSessionTaskProgressBlock)downloadProgressBlock {
    return nil;
}

@end
