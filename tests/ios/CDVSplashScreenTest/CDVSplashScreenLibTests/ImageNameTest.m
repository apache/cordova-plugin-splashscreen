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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Cordova/CDVScreenOrientationDelegate.h>
#import "CDVSplashScreen.h"
#import "ImageNameTestDelegates.h"

const CDV_iOSDevice CDV_iOSDeviceZero = { 0, 0, 0, 0, 0, 0 };

@interface ImageNameTest : XCTestCase

@property (nonatomic, strong) CDVSplashScreen* plugin;

@end

@interface CDVSplashScreen ()

// expose private interface
- (NSString*)getImageName:(UIInterfaceOrientation)currentOrientation delegate:(id<CDVScreenOrientationDelegate>)orientationDelegate device:(CDV_iOSDevice)device;

@end

@implementation ImageNameTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.plugin = [[CDVSplashScreen alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) portraitHelper:(UIInterfaceOrientation)initialOrientation delegate:(id<CDVScreenOrientationDelegate>)delegate
{
    NSString* name = nil;
    CDV_iOSDevice device;
    
    // Portrait, non-iPad, non-iPhone5
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone5 = NO;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default" isEqualToString:name], @"Portrait - 3.5\" iPhone failed (%@)", name);
    
    // Portrait, iPad, non-iPhone5
    device = CDV_iOSDeviceZero; device.iPad = YES; device.iPhone5 = NO;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-Portrait" isEqualToString:name], @"Portrait - iPad failed (%@)", name);
    
    // Portrait, non-iPad, iPhone5
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone5 = YES;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-568h" isEqualToString:name], @"Portrait - iPhone 5 failed (%@)", name);

    // Portrait, non-iPad, iPhone6
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone6 = YES;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-667h" isEqualToString:name], @"Portrait - iPhone 6 failed (%@)", name);

    // Portrait, non-iPad, iPhone6Plus
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone6Plus = YES;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-736h" isEqualToString:name], @"Portrait - iPhone 6Plus failed (%@)", name);
}

- (void) landscapeHelper:(UIInterfaceOrientation)initialOrientation delegate:(id<CDVScreenOrientationDelegate>)delegate
{
    NSString* name = nil;
    CDV_iOSDevice device;
    
    // Landscape, non-iPad, non-iPhone5 (does NOT support landscape)
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone5 = NO;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default" isEqualToString:name], @"Landscape - 3.5\" iPhone failed (%@)", name );
    
    // Landscape, iPad, non-iPhone5 (supports landscape)
    device = CDV_iOSDeviceZero; device.iPad = YES; device.iPhone5 = NO;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-Landscape" isEqualToString:name], @"Landscape - iPad failed (%@)", name);
    
    // Landscape, non-iPad, iPhone5 (does NOT support landscape)
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone5 = YES;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-568h" isEqualToString:name], @"Landscape - iPhone5 failed (%@)", name);

    // Landscape, non-iPad, iPhone6 (does NOT support landscape)
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone6 = YES;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-667h" isEqualToString:name], @"Landscape - iPhone6 failed (%@)", name);

    // Landscape, non-iPad, iPhone6Plus (does support landscape)
    device = CDV_iOSDeviceZero; device.iPad = NO; device.iPhone6Plus = YES;
    name = [self.plugin getImageName:initialOrientation delegate:delegate device:device];
    XCTAssertTrue([@"Default-Landscape-736h" isEqualToString:name], @"Landscape - iPhone6Plus failed (%@)", name);

}

- (void)testPortraitOnly {
    
    PortraitOnly* delegate = [[PortraitOnly alloc] init];
    [self portraitHelper:UIInterfaceOrientationPortrait delegate:delegate];
}

- (void)testPortraitUpsideDownOnly {
    
    PortraitUpsideDownOnly* delegate = [[PortraitUpsideDownOnly alloc] init];
    [self portraitHelper:UIInterfaceOrientationPortraitUpsideDown delegate:delegate];
}

- (void)testAllPortraitOnly {
    
    AllPortraitOnly* delegate = [[AllPortraitOnly alloc] init];
    [self portraitHelper:UIInterfaceOrientationPortrait delegate:delegate];
    [self portraitHelper:UIInterfaceOrientationPortraitUpsideDown delegate:delegate];
}

- (void)testLandscapeLeftOnly {
    
    LandscapeLeftOnly* delegate = [[LandscapeLeftOnly alloc] init];
    [self landscapeHelper:UIInterfaceOrientationLandscapeLeft delegate:delegate];
}

- (void)testLandscapeRightOnly {
    
    LandscapeRightOnly* delegate = [[LandscapeRightOnly alloc] init];
    [self landscapeHelper:UIInterfaceOrientationLandscapeRight delegate:delegate];
}

- (void)testAllLandscapeOnly {
    
    AllLandscapeOnly* delegate = [[AllLandscapeOnly alloc] init];
    [self landscapeHelper:UIInterfaceOrientationLandscapeLeft delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeRight delegate:delegate];
}

- (void)testAllOrientations {
    
    AllOrientations* delegate = [[AllOrientations alloc] init];
    // try all orientations
    [self portraitHelper:UIInterfaceOrientationPortrait delegate:delegate];
    [self portraitHelper:UIInterfaceOrientationPortraitUpsideDown delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeLeft delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeRight delegate:delegate];
}

- (void)testPortraitAndLandscapeLeft {
    
    PortraitAndLandscapeLeftOnly* delegate = [[PortraitAndLandscapeLeftOnly alloc] init];
    // try all orientations
    [self portraitHelper:UIInterfaceOrientationPortrait delegate:delegate];
    [self portraitHelper:UIInterfaceOrientationPortraitUpsideDown delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeLeft delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeRight delegate:delegate];
}

- (void)testPortraitAndLandscapeRight {
    
    PortraitAndLandscapeRightOnly* delegate = [[PortraitAndLandscapeRightOnly alloc] init];
    // try all orientations
    [self portraitHelper:UIInterfaceOrientationPortrait delegate:delegate];
    [self portraitHelper:UIInterfaceOrientationPortraitUpsideDown delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeLeft delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeRight delegate:delegate];
}

- (void)testPortraitUpsideDownAndLandscapeLeft {
    
    PortraitUpsideDownAndLandscapeLeftOnly* delegate = [[PortraitUpsideDownAndLandscapeLeftOnly alloc] init];
    // try all orientations
    [self portraitHelper:UIInterfaceOrientationPortrait delegate:delegate];
    [self portraitHelper:UIInterfaceOrientationPortraitUpsideDown delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeLeft delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeRight delegate:delegate];
}

- (void)testPortraitUpsideDownAndLandscapeRight {
    
    PortraitUpsideDownAndLandscapeRightOnly* delegate = [[PortraitUpsideDownAndLandscapeRightOnly alloc] init];
    // try all orientations
    [self portraitHelper:UIInterfaceOrientationPortrait delegate:delegate];
    [self portraitHelper:UIInterfaceOrientationPortraitUpsideDown delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeLeft delegate:delegate];
    [self landscapeHelper:UIInterfaceOrientationLandscapeRight delegate:delegate];
}

@end
