//
//  ZMNetworkAgent.h
//  Pods
//
//  Created by Abe on 16/4/18.
//
//

#import <Foundation/Foundation.h>

@class ZMBaseRequest;
@interface ZMNetworkAgent : NSObject

+ (instancetype)sharedInstance;

- (void)addRequest:(ZMBaseRequest *)request;

- (void)suspendsRequest:(ZMBaseRequest *)request;

- (void)cancleRequest:(ZMBaseRequest *)request;
@end
