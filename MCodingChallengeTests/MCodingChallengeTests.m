//
//  MCodingChallengeTests.m
//  MCodingChallengeTests
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserSearchDetailsViewController.h"

@interface MCodingChallengeTests : XCTestCase

@end

@implementation MCodingChallengeTests{
    
@private
UserSearchDetailsViewController *vc;
}

- (void)setUp {
    [super setUp];
    NSLog(@"%@ setUp", self.name);
    vc = [[UserSearchDetailsViewController alloc]init];
    XCTAssertNotNil(vc, @"Cannot create viewController instance");

}

- (void)tearDown {
    [super tearDown];
     NSLog(@"%@ tearDown", self.name);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
