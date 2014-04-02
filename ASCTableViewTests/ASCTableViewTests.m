//
//  ASCTableViewTests.m
//  ASCTableViewTests
//
//  Created by wenlonggao on 14-4-2.
//  Copyright (c) 2014年 wenlonggao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASCZhihuNewsManager.h"

@interface ASCTableViewTests : XCTestCase

@end

@implementation ASCTableViewTests

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
    id result = [ASCZhihuNewsManager fetchLastNewsMap];
    if (result) {
        return;
    }
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
