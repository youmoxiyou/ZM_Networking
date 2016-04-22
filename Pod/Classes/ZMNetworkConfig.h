//
//  ZMNetworkConfig.h
//  Pods
//
//  Created by Abe on 16/4/18.
//
//

#import <Foundation/Foundation.h>

@interface ZMNetworkConfig : NSObject

@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *cdnUrl;
//@property (strong, nonatomic, readonly) NSArray *urlFilters;
//@property (strong, nonatomic, readonly) NSArray *cacheDirPathFilters;

+ (instancetype)sharedInstance;

@end
