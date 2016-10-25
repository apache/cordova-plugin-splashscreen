/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "CDVSplashScreen.h"
#import <Cordova/CDVViewController.h>
#import "TestCDVSplashScreen.h"

@interface ViewFrameObservingTest : XCTestCase
@property (nonatomic, strong) CDVSplashScreen* plugin;
@end

@interface CDVSplashScreen (Private)

- (void)createViews;
- (void)destoyViews;

@end

@interface CDVTestViewController : UIViewController // CDVViewController
@property (nonatomic, assign) BOOL enabledAutorotation;
@property (nonatomic, readonly) BOOL shouldAutorotateDefaultValue;
@end

@implementation CDVTestViewController
@end

@implementation ViewFrameObservingTest

- (void)setUp {
    [super setUp];
    self.plugin = [[CDVSplashScreen alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.plugin = nil;
}

- (void)testCorrectKVOObservingRemoval {
    XCTAssertNoThrow([self kvoExample]);
}

- (void)testCorrectKVOObservingOfView {
    TestCDVSplashScreen * testPlugin = [[TestCDVSplashScreen alloc] init];
    self.plugin = testPlugin;
    CDVTestViewController * controller = [CDVTestViewController new];

    self.plugin.viewController = controller;
    [self.plugin createViews];
    XCTAssertTrue(testPlugin.updateImageCalled, @"Should update image right after views creation");

    testPlugin.updateImageCalled = NO;
    controller.view.frame = CGRectMake(0,0,100,100);
    XCTAssertTrue(testPlugin.updateImageCalled, @"Should update image when view frame changes");

    testPlugin.updateImageCalled = NO;
    controller.view.bounds = CGRectMake(0,0,100,100);
    XCTAssertTrue(testPlugin.updateImageCalled, @"Should update image when view bounds changes");
}


- (void)kvoExample {
    @autoreleasepool {
        CDVTestViewController * controller = [CDVTestViewController new];
        self.plugin.viewController = controller;
        [self.plugin createViews];
    }
}

@end
