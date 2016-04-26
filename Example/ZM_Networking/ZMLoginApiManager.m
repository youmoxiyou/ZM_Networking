//
//  ZMLoginApiManager.m
//  ZM_Networking
//
//  Created by Abe on 16/4/24.
//  Copyright © 2016年 AbeHui. All rights reserved.
//

#import "ZMLoginApiManager.h"

@implementation ZMLoginApiManager


- (NSString *)requestUrl {
    return @"/youqu/findpage_webitems_ios.htm";
}

- (NSString *)cdnUrl {
    return nil;
}

- (NSString *)baseUrl {
    return @"http://114.215.182.172:8080";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 10.0f;
}

- (id)requestArgument {
    return nil;
}

- (ZMHttpMethod)requestMethod {
    return ZMHttpMethodPost;
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
