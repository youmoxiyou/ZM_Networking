//
//  ZM_NetworkingTests.m
//  ZM_NetworkingTests
//
//  Created by AbeHui on 04/13/2016.
//  Copyright (c) 2016 AbeHui. All rights reserved.
//

@import XCTest;
#import "ZMLoginApiManager.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}
- (void)testNetwork {
    [self expectationWithDescription:@"..."];
    ZMLoginApiManager *API = [ZMLoginApiManager new];
    [API start];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        
    }];
}
@end

