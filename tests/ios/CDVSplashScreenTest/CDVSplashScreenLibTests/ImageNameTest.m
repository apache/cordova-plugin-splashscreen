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

- (void) currentOrientationNotSupportedHelper:(UIInterfaceOrientation)initialOrientation delegate:(id<CDVScreenOrientationDelegate>)delegate
{
    NSString* name = nil;
    CDV_iOSDevice device;
    
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

- (void) lockedOrientationHelper:(id<CDVScreenOrientationDelegate>)delegate expectedImageName:(NSString*)expectedImageName orientationName:(NSString*)orientationName device:(CDV_iOSDevice)device{
    
    NSString* name = nil;
    UIInterfaceOrientation currentOrientation;
    NSString* deviceName = device.iPad? @"iPad" : device.iPhone6Plus? @"iPhone6Plus": device.iPhone6? @"iPhone6": device.iPhone5? @"iPhone5" : @"iPhone";

    // LandscapeLeft, should always return expectedImageName
    currentOrientation = UIInterfaceOrientationLandscapeLeft;
    name = [self.plugin getImageName:currentOrientation delegate:delegate device:device];
    XCTAssertTrue([expectedImageName isEqualToString:name], @"%@ - %@ failed (%@)", orientationName, deviceName, name);
    
    // LandscapeRight - should always return expectedImageName
    currentOrientation = UIInterfaceOrientationLandscapeRight;
    name = [self.plugin getImageName:currentOrientation delegate:delegate device:device];
    XCTAssertTrue([expectedImageName isEqualToString:name], @"%@ - %@ failed (%@)", orientationName, deviceName, name);
    
    // Portrait - should always return expectedImageName
    currentOrientation = UIInterfaceOrientationPortrait;
    name = [self.plugin getImageName:currentOrientation delegate:delegate device:device];
    XCTAssertTrue([expectedImageName isEqualToString:name], @"%@ - %@ failed (%@)", orientationName, deviceName, name);
    
    // PortraitUpsideDown - should always return expectedImageName
    currentOrientation = UIInterfaceOrientationPortraitUpsideDown;
    name = [self.plugin getImageName:currentOrientation delegate:delegate device:device];
    XCTAssertTrue([expectedImageName isEqualToString:name], @"%@ - %@ failed (%@)", orientationName, deviceName, name);

}

- (void)testiPadLockedOrientation {
    
    CDV_iOSDevice device = CDV_iOSDeviceZero;
    device.iPad = YES;
    
    // One orientation
    
    PortraitOnly* delegate = [[PortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate expectedImageName:@"Default-Portrait" orientationName:@"Portrait" device:device];
    
    PortraitUpsideDownOnly* delegate2 = [[PortraitUpsideDownOnly alloc] init];
    [self lockedOrientationHelper:delegate2 expectedImageName:@"Default-Portrait" orientationName:@"Portrait" device:device];
    
    LandscapeLeftOnly* delegate3 = [[LandscapeLeftOnly alloc] init];
    [self lockedOrientationHelper:delegate3 expectedImageName:@"Default-Landscape" orientationName:@"Landscape" device:device];
    
    LandscapeRightOnly* delegate4 = [[LandscapeRightOnly alloc] init];
    [self lockedOrientationHelper:delegate4 expectedImageName:@"Default-Landscape" orientationName:@"Landscape" device:device];

    // All Portrait

    AllPortraitOnly* delegate5 = [[AllPortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate5 expectedImageName:@"Default-Portrait" orientationName:@"Portrait" device:device];

    // All Landscape
    
    AllLandscapeOnly* delegate6 = [[AllLandscapeOnly alloc] init];
    [self lockedOrientationHelper:delegate6 expectedImageName:@"Default-Landscape" orientationName:@"Landscape" device:device];
}

- (void)testiPhoneLockedOrientation {
    
    CDV_iOSDevice device = CDV_iOSDeviceZero;
    device.iPhone = YES;
    
    // One orientation
    
    PortraitOnly* delegate = [[PortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate expectedImageName:@"Default" orientationName:@"Portrait" device:device];
    
    PortraitUpsideDownOnly* delegate2 = [[PortraitUpsideDownOnly alloc] init];
    [self lockedOrientationHelper:delegate2 expectedImageName:@"Default" orientationName:@"Portrait" device:device];
    
    LandscapeLeftOnly* delegate3 = [[LandscapeLeftOnly alloc] init];
    [self lockedOrientationHelper:delegate3 expectedImageName:@"Default" orientationName:@"Landscape" device:device];
    
    LandscapeRightOnly* delegate4 = [[LandscapeRightOnly alloc] init];
    [self lockedOrientationHelper:delegate4 expectedImageName:@"Default" orientationName:@"Landscape" device:device];
    
    // All Portrait
    
    AllPortraitOnly* delegate5 = [[AllPortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate5 expectedImageName:@"Default" orientationName:@"Portrait" device:device];
    
    // All Landscape
    
    AllLandscapeOnly* delegate6 = [[AllLandscapeOnly alloc] init];
    [self lockedOrientationHelper:delegate6 expectedImageName:@"Default" orientationName:@"Landscape" device:device];
}

- (void)testiPhone5LockedOrientation {
    
    CDV_iOSDevice device = CDV_iOSDeviceZero;
    device.iPhone = YES;
    device.iPhone5 = YES;
    
    // One orientation
    
    PortraitOnly* delegate = [[PortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate expectedImageName:@"Default-568h" orientationName:@"Portrait" device:device];
    
    PortraitUpsideDownOnly* delegate2 = [[PortraitUpsideDownOnly alloc] init];
    [self lockedOrientationHelper:delegate2 expectedImageName:@"Default-568h" orientationName:@"Portrait" device:device];
    
    LandscapeLeftOnly* delegate3 = [[LandscapeLeftOnly alloc] init];
    [self lockedOrientationHelper:delegate3 expectedImageName:@"Default-568h" orientationName:@"Landscape" device:device];
    
    LandscapeRightOnly* delegate4 = [[LandscapeRightOnly alloc] init];
    [self lockedOrientationHelper:delegate4 expectedImageName:@"Default-568h" orientationName:@"Landscape" device:device];
    
    // All Portrait
    
    AllPortraitOnly* delegate5 = [[AllPortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate5 expectedImageName:@"Default-568h" orientationName:@"Portrait" device:device];
    
    // All Landscape
    
    AllLandscapeOnly* delegate6 = [[AllLandscapeOnly alloc] init];
    [self lockedOrientationHelper:delegate6 expectedImageName:@"Default-568h" orientationName:@"Landscape" device:device];
}

- (void)testiPhone6LockedOrientation {
    
    CDV_iOSDevice device = CDV_iOSDeviceZero;
    device.iPhone = YES;
    device.iPhone6 = YES;
    
    // One orientation
    
    PortraitOnly* delegate = [[PortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate expectedImageName:@"Default-667h" orientationName:@"Portrait" device:device];
    
    PortraitUpsideDownOnly* delegate2 = [[PortraitUpsideDownOnly alloc] init];
    [self lockedOrientationHelper:delegate2 expectedImageName:@"Default-667h" orientationName:@"Portrait" device:device];
    
    LandscapeLeftOnly* delegate3 = [[LandscapeLeftOnly alloc] init];
    [self lockedOrientationHelper:delegate3 expectedImageName:@"Default-667h" orientationName:@"Landscape" device:device];
    
    LandscapeRightOnly* delegate4 = [[LandscapeRightOnly alloc] init];
    [self lockedOrientationHelper:delegate4 expectedImageName:@"Default-667h" orientationName:@"Landscape" device:device];
    
    // All Portrait
    
    AllPortraitOnly* delegate5 = [[AllPortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate5 expectedImageName:@"Default-667h" orientationName:@"Portrait" device:device];
    
    // All Landscape
    
    AllLandscapeOnly* delegate6 = [[AllLandscapeOnly alloc] init];
    [self lockedOrientationHelper:delegate6 expectedImageName:@"Default-667h" orientationName:@"Landscape" device:device];
}

- (void)testiPhone6PlusLockedOrientation {
    
    CDV_iOSDevice device = CDV_iOSDeviceZero;
    device.iPhone = YES;
    device.iPhone6Plus = YES;
    
    // One orientation
    
    PortraitOnly* delegate = [[PortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate expectedImageName:@"Default-736h" orientationName:@"Portrait" device:device];
    
    PortraitUpsideDownOnly* delegate2 = [[PortraitUpsideDownOnly alloc] init];
    [self lockedOrientationHelper:delegate2 expectedImageName:@"Default-736h" orientationName:@"Portrait" device:device];
    
    LandscapeLeftOnly* delegate3 = [[LandscapeLeftOnly alloc] init];
    [self lockedOrientationHelper:delegate3 expectedImageName:@"Default-Landscape-736h" orientationName:@"Landscape" device:device];
    
    LandscapeRightOnly* delegate4 = [[LandscapeRightOnly alloc] init];
    [self lockedOrientationHelper:delegate4 expectedImageName:@"Default-Landscape-736h" orientationName:@"Landscape" device:device];
    
    // All Portrait
    
    AllPortraitOnly* delegate5 = [[AllPortraitOnly alloc] init];
    [self lockedOrientationHelper:delegate5 expectedImageName:@"Default-736h" orientationName:@"Portrait" device:device];
    
    // All Landscape
    
    AllLandscapeOnly* delegate6 = [[AllLandscapeOnly alloc] init];
    [self lockedOrientationHelper:delegate6 expectedImageName:@"Default-Landscape-736h" orientationName:@"Landscape" device:device];
}



@end
