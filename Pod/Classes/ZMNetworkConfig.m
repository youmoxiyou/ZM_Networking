//
//  ZMNetworkConfig.m
//  Pods
//
//  Created by Abe on 16/4/18.
//
//

#import "ZMNetworkConfig.h"

@implementation ZMNetworkConfig

+ (instancetype)sharedInstance {
    static ZMNetworkConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZMNetworkConfig new];
    });
    return instance;
}

@end
