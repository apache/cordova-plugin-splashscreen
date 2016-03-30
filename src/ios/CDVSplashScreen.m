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

#import "CDVSplashScreen.h"
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVScreenOrientationDelegate.h>
#import "CDVViewController+SplashScreen.h"

#import "MMMaterialDesignSpinner.h"
#import "ActivityTracking.h"
#import "CDVSplashScreenSystemVersion.h"

#define kSplashScreenDurationDefault 3000.0f
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CDVSplashScreen ()
@property (readwrite, assign) BOOL isIOS8;
@property (assign) BOOL firstPageLoaded;
@property (assign) BOOL removeKVOListeners;

@end
@implementation CDVSplashScreen

- (void)pluginInitialize
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        self.isIOS8 = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageStartedLoading) name:CDVPluginResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad) name:CDVPageDidLoadNotification object:nil];
    
    [self setVisible:YES];
}

- (void)show:(CDVInvokedUrlCommand*)command
{
    [self setVisible:YES];
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
    [CDVSplashScreen cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide:) object:nil];
    [self setVisible:NO andForce:YES];
}

- (void)onPageLoading:(CDVInvokedUrlCommand*)command
{
    [self pageStartedLoading];
}

- (void)onPageLoaded:(CDVInvokedUrlCommand*)command
{
    [self pageDidLoad];
}

- (void)pageStartedLoading
{
    [self setVisible:YES];
    
    id autoHideSplashScreenTimeoutValue = [self.commandDelegate.settings objectForKey:[@"SplashScreenTimeout" lowercaseString]];
    if (autoHideSplashScreenTimeoutValue) {
        float autoHideSplashScreenTimeout = [autoHideSplashScreenTimeoutValue floatValue] / 1000;
        [self performSelector:@selector(hide:) withObject:nil afterDelay:autoHideSplashScreenTimeout];
    }
}

- (void)pageDidLoad
{
    id autoHideSplashScreenValue = [self.commandDelegate.settings objectForKey:[@"AutoHideSplashScreen" lowercaseString]];
    
    // if value is missing, default to yes
    if ((autoHideSplashScreenValue == nil) || [autoHideSplashScreenValue boolValue]) {
        [self setVisible:NO];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    [self updateImage];
}

- (void)createViews
{
    /*
     * The Activity View is the top spinning throbber in the status/battery bar. We init it with the default Grey Style.
     *
     *     whiteLarge = UIActivityIndicatorViewStyleWhiteLarge
     *     white      = UIActivityIndicatorViewStyleWhite
     *     gray       = UIActivityIndicatorViewStyleGray
     *
     */
    
    // Determine whether rotation should be enabled for this device
    // Per iOS HIG, landscape is only supported on iPad and iPhone 6+
    CDV_iOSDevice device = [self getCurrentDevice];
    BOOL autorotateValue = (device.iPad || device.iPhone6Plus) ?
    [(CDVViewController *)self.viewController shouldAutorotateDefaultValue] :
    NO;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && SYSTEM_VERSION_LESS_THAN(@"8.4")) { // there is a bug for rotation for iPhones on iOS 8 so enabling autorotation together with the fixes implemented in the methods updateBounds and setVisible solved the bug
        
        BOOL isIOS8_0 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && SYSTEM_VERSION_LESS_THAN(@"8.1");
        BOOL shouldDeviceRotate = (!device.iPhone5 && !device.iPhone4 && !device.iPhone6);
        autorotateValue = (shouldDeviceRotate || isIOS8_0)? YES : autorotateValue;
    }
    
    [(CDVViewController *)self.viewController setEnabledAutorotation:autorotateValue];
    self.viewController.view.userInteractionEnabled = NO;  // disable user interaction while splashscreen is shown
    [self setupSplashScreenViews];
    
    self.firstPageLoaded = YES;
    _destroyed = NO;
}

- (void)setupSplashScreenViews
{
    NSString* topActivityIndicator = [self.commandDelegate.settings objectForKey:[@"TopActivityIndicator" lowercaseString]];
    UIActivityIndicatorViewStyle topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    
    if ([topActivityIndicator isEqualToString:@"whiteLarge"])
    {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    else if ([topActivityIndicator isEqualToString:@"white"])
    {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    }
    else if ([topActivityIndicator isEqualToString:@"gray"])
    {
        topActivityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    }
    
    UIView* parentView = self.viewController.view;
    id showMaterialSpinner = [self.commandDelegate.settings objectForKey: [@"MaterialLikeSpinner" lowercaseString]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && showMaterialSpinner && [showMaterialSpinner boolValue])
    {
        id showMaterialSpinnerTrackRadius = [self.commandDelegate.settings objectForKey: [@"MaterialLikeSpinnerTrackRadius" lowercaseString]];
        CGFloat trackDiameter = showMaterialSpinnerTrackRadius ? ([showMaterialSpinnerTrackRadius floatValue] * 2) : 40 ;
        
        // Initialize the progress view
        MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, trackDiameter, trackDiameter)];
        
        // Set the line width of the spinner
        id showMaterialSpinnerTrackWidth = [self.commandDelegate.settings objectForKey: [@"MaterialLikeSpinnerTrackWidth" lowercaseString]];
        spinnerView.lineWidth = showMaterialSpinnerTrackWidth ? [showMaterialSpinnerTrackWidth floatValue] : 2.0f;
        
        // Set the tint color of the spinner
        id showMaterialSpinnerTintHexColor = [self.commandDelegate.settings objectForKey: [@"MaterialLikeSpinnerTrackTintHexColor" lowercaseString]];
        unsigned int spinnerColorConvertedFromHexString = 0;
        if (showMaterialSpinnerTintHexColor) {
            NSScanner *scanner = [NSScanner scannerWithString:showMaterialSpinnerTintHexColor];
            [scanner setScanLocation:1]; // bypass '#' character
            [scanner scanHexInt:&spinnerColorConvertedFromHexString];
        }
        
        spinnerView.tintColor = showMaterialSpinnerTintHexColor ? UIColorFromRGB(spinnerColorConvertedFromHexString) : [UIColor lightGrayColor];
        _activityView = spinnerView;
    }
    else
    {
        _activityView = (UIView<ActivityTracking> *)[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:topActivityIndicatorStyle];
    }
    
    _activityView.center = CGPointMake(parentView.bounds.size.width / 2, parentView.bounds.size.height / 2);
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [_activityView startAnimating];
    
    // Set the frame & image later.
    _imageView = [[UIImageView alloc] init];
    [parentView addSubview:_imageView];
    
    id showSplashScreenSpinnerValue = [self.commandDelegate.settings objectForKey:[@"ShowSplashScreenSpinner" lowercaseString]];
    // backwards compatibility - if key is missing, default to true
    if ((showSplashScreenSpinnerValue == nil) || [showSplashScreenSpinnerValue boolValue])
    {
        [parentView addSubview:_activityView];
    }
    
    // Frame is required when launching in portrait mode.
    // Bounds for landscape since it captures the rotation.
    [parentView addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [parentView addObserver:self forKeyPath:@"bounds" options:0 context:nil];
    self.removeKVOListeners = YES;
    
    [self updateImage];
}

- (void)hideViews
{
    [_imageView setAlpha:0];
    [_activityView setAlpha:0];
}
- (void)destroyViews
{
    _destroyed = YES;
    [(CDVViewController *)self.viewController setEnabledAutorotation:[(CDVViewController *)self.viewController shouldAutorotateDefaultValue]];
    
    [_imageView removeFromSuperview];
    [_activityView removeFromSuperview];
    _imageView = nil;
    _activityView = nil;
    _curImageName = nil;
    
    self.viewController.view.userInteractionEnabled = YES;  // re-enable user interaction upon completion
    
    if (self.removeKVOListeners) {
        self.removeKVOListeners = NO;
        [self.viewController.view removeObserver:self forKeyPath:@"frame"];
        [self.viewController.view removeObserver:self forKeyPath:@"bounds"];
    }
    
    [CDVSplashScreen cancelPreviousPerformRequestsWithTarget:self];
}

- (CDV_iOSDevice) getCurrentDevice
{
    CDV_iOSDevice device;
    
    UIScreen* mainScreen = [UIScreen mainScreen];
    CGFloat mainScreenHeight = mainScreen.bounds.size.height;
    CGFloat mainScreenWidth = mainScreen.bounds.size.width;
    
    int limit = MAX(mainScreenHeight,mainScreenWidth);
    
    device.iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    device.iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    device.retina = ([mainScreen scale] == 2.0);
    device.iPhone4 = (device.iPhone && limit == 480.0);
    device.iPhone5 = (device.iPhone && limit == 568.0);
    // note these below is not a true device detect, for example if you are on an
    // iPhone 6/6+ but the app is scaled it will prob set iPhone5 as true, but
    // this is appropriate for detecting the runtime screen environment
    device.iPhone6 = (device.iPhone && limit == 667.0);
    device.iPhone6Plus = (device.iPhone && limit == 736.0);
    device.iPadPro = (device.iPad && limit == 1366.0);
    
    return device;
}

- (NSString*)getImageName:(UIInterfaceOrientation)currentOrientation delegate:(id<CDVScreenOrientationDelegate>)orientationDelegate device:(CDV_iOSDevice)device
{
    // Use UILaunchImageFile if specified in plist.  Otherwise, use Default.
    NSString* imageName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UILaunchImageFile"];
    
    NSUInteger supportedOrientations = [orientationDelegate supportedInterfaceOrientations];
    
    // Checks to see if the developer has locked the orientation to use only one of Portrait or Landscape
    BOOL supportsLandscape = (supportedOrientations & UIInterfaceOrientationMaskLandscape);
    BOOL supportsPortrait = (supportedOrientations & UIInterfaceOrientationMaskPortrait || supportedOrientations & UIInterfaceOrientationMaskPortraitUpsideDown);
    // this means there are no mixed orientations in there
    BOOL isOrientationLocked = !(supportsPortrait && supportsLandscape);
    
    if (imageName)
    {
        imageName = [imageName stringByDeletingPathExtension];
    }
    else
    {
        imageName = @"Default";
    }
    
    // Add Asset Catalog specific prefixes
    if ([imageName isEqualToString:@"LaunchImage"])
    {
        if (device.iPhone4 || device.iPhone5 || device.iPad) {
            imageName = [imageName stringByAppendingString:@"-700"];
        } else if(device.iPhone6) {
            imageName = [imageName stringByAppendingString:@"-800"];
        } else if(device.iPhone6Plus) {
            imageName = [imageName stringByAppendingString:@"-800"];
            if (currentOrientation == UIInterfaceOrientationPortrait || currentOrientation == UIInterfaceOrientationPortraitUpsideDown)
            {
                imageName = [imageName stringByAppendingString:@"-Portrait"];
            }
        }
    }
    
    if (device.iPhone5)
    { // does not support landscape
        imageName = [imageName stringByAppendingString:@"-568h"];
    }
    else if (device.iPhone6)
    { // does not support landscape
        imageName = [imageName stringByAppendingString:@"-667h"];
    }
    else if (device.iPhone6Plus)
    { // supports landscape
        if (isOrientationLocked)
        {
            imageName = [imageName stringByAppendingString:(supportsLandscape ? @"-Landscape" : @"")];
        }
        else
        {
            switch (currentOrientation)
            {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    imageName = [imageName stringByAppendingString:@"-Landscape"];
                    break;
                default:
                    break;
            }
        }
        imageName = [imageName stringByAppendingString:@"-736h"];
        
    }
    else if (device.iPad)
    {   // supports landscape
        if (isOrientationLocked)
        {
            imageName = [imageName stringByAppendingString:(supportsLandscape ? @"-Landscape" : @"-Portrait")];
        }
        else
        {
            switch (currentOrientation)
            {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    imageName = [imageName stringByAppendingString:@"-Landscape"];
                    break;
                    
                case UIInterfaceOrientationPortrait:
                case UIInterfaceOrientationPortraitUpsideDown:
                default:
                    imageName = [imageName stringByAppendingString:@"-Portrait"];
                    break;
            }
        }
        if (device.iPadPro) {
            imageName = [imageName stringByAppendingString:@"-1336"];
        }
    }
    
    return imageName;
}

- (UIInterfaceOrientation)getCurrentOrientation
{
    UIInterfaceOrientation iOrientation = [UIApplication sharedApplication].statusBarOrientation;
    UIDeviceOrientation dOrientation = [UIDevice currentDevice].orientation;
    
    bool landscape;
    
    if (dOrientation == UIDeviceOrientationUnknown || dOrientation == UIDeviceOrientationFaceUp || dOrientation == UIDeviceOrientationFaceDown) {
        // If the device is laying down, use the UIInterfaceOrientation based on the status bar.
        landscape = UIInterfaceOrientationIsLandscape(iOrientation);
    } else {
        // If the device is not laying down, use UIDeviceOrientation.
        landscape = UIDeviceOrientationIsLandscape(dOrientation);
        
        // There's a bug in iOS!!!! http://openradar.appspot.com/7216046
        // So values needs to be reversed for landscape!
        if (dOrientation == UIDeviceOrientationLandscapeLeft)
        {
            iOrientation = UIInterfaceOrientationLandscapeRight;
        }
        else if (dOrientation == UIDeviceOrientationLandscapeRight)
        {
            iOrientation = UIInterfaceOrientationLandscapeLeft;
        }
        else if (dOrientation == UIDeviceOrientationPortrait)
        {
            iOrientation = UIInterfaceOrientationPortrait;
        }
        else if (dOrientation == UIDeviceOrientationPortraitUpsideDown)
        {
            iOrientation = UIInterfaceOrientationPortraitUpsideDown;
        }
    }
    
    return iOrientation;
}

// Sets the view's frame and image.
- (void)updateImage
{
    NSString* imageName = [self getImageName:[self getCurrentOrientation] delegate:(id<CDVScreenOrientationDelegate>)self.viewController device:[self getCurrentDevice]];
    
    if (![imageName isEqualToString:_curImageName])
    {
        UIImage* img = [UIImage imageNamed:imageName];
        _imageView.image = img;
        _curImageName = imageName;
    }
    
    // Check that splash screen's image exists before updating bounds
    if (_imageView.image)
    {
        [self updateBounds];
    }
    else
    {
        NSLog(@"WARNING: The splashscreen image named %@ was not found", imageName);
    }
}

- (void)updateBounds
{
    UIImage* img = _imageView.image;
    CGRect imgBounds = (img) ? CGRectMake(0, 0, img.size.width, img.size.height) : CGRectZero;
    
    CGSize screenSize = [self.viewController.view convertRect:[UIScreen mainScreen].bounds fromView:nil].size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGAffineTransform imgTransform = CGAffineTransformIdentity;
    
    /* If and only if an iPhone application is landscape-only as per
     * UISupportedInterfaceOrientations, the view controller's orientation is
     * landscape. In this case the image must be rotated in order to appear
     * correctly.
     */
    CDV_iOSDevice device = [self getCurrentDevice];
    
    if ((UIInterfaceOrientationIsLandscape(orientation) && !device.iPhone6Plus && !device.iPad) && ((!device.iPhone5 && !device.iPhone4) || self.isIOS8))
    {
        imgTransform = CGAffineTransformMakeRotation(M_PI / 2);
        imgBounds.size = CGSizeMake(imgBounds.size.height, imgBounds.size.width);
    }
    
    // There's a special case when the image is the size of the screen.
    if (CGSizeEqualToSize(screenSize, imgBounds.size))
    {
        CGRect statusFrame = [self.viewController.view convertRect:[UIApplication sharedApplication].statusBarFrame fromView:nil];
        if (!(IsAtLeastiOSVersion(@"7.0")))
        {
            imgBounds.origin.y -= statusFrame.size.height;
        }
    }
    else if (imgBounds.size.width > 0)
    {
        CGRect viewBounds = self.viewController.view.bounds;
        CGFloat imgAspect = imgBounds.size.width / imgBounds.size.height;
        CGFloat viewAspect = viewBounds.size.width / viewBounds.size.height;
        // This matches the behaviour of the native splash screen.
        CGFloat ratio;
        if (viewAspect > imgAspect)
        {
            ratio = viewBounds.size.width / imgBounds.size.width;
        }
        else
        {
            ratio = viewBounds.size.height / imgBounds.size.height;
        }
        imgBounds.size.height *= ratio;
        imgBounds.size.width *= ratio;
    }
    
    _imageView.transform = imgTransform;
    _imageView.frame = imgBounds;
}

- (void)setVisible:(BOOL)visible
{
    [self setVisible:visible andForce:NO];
}

- (void)setVisible:(BOOL)visible andForce:(BOOL)force
{
    @synchronized (self) {
        if (visible != _visible || force)
        {
            _visible = visible;
            
            id fadeSplashScreenValue = [self.commandDelegate.settings objectForKey:[@"FadeSplashScreen" lowercaseString]];
            id fadeSplashScreenDuration = [self.commandDelegate.settings objectForKey:[@"FadeSplashScreenDuration" lowercaseString]];
            
            float fadeDuration = fadeSplashScreenDuration == nil ? kSplashScreenDurationDefault : [fadeSplashScreenDuration floatValue];
            
            id splashDurationString = [self.commandDelegate.settings objectForKey: [@"SplashScreenDelay" lowercaseString]];
            float splashDuration = splashDurationString == nil ? kSplashScreenDurationDefault : [splashDurationString floatValue];
            
            id autoHideSplashScreenValue = [self.commandDelegate.settings objectForKey:[@"AutoHideSplashScreen" lowercaseString]];
            BOOL autoHideSplashScreen = true;
            
            if (autoHideSplashScreenValue != nil) {
                autoHideSplashScreen = [autoHideSplashScreenValue boolValue];
            }
            
            if (!autoHideSplashScreen) {
                // CB-10412 SplashScreenDelay does not make sense if the splashscreen is hidden manually
                splashDuration = 0;
            }
            
            
            if (fadeSplashScreenValue == nil)
            {
                fadeSplashScreenValue = @"true";
            }
            
            if (![fadeSplashScreenValue boolValue])
            {
                fadeDuration = 0;
            }
            else if (fadeDuration < 30)
            {
                // [CB-9750] This value used to be in decimal seconds, so we will assume that if someone specifies 10
                // they mean 10 seconds, and not the meaningless 10ms
                fadeDuration *= 1000;
            }
            
            if (_visible)
            {
                if (_imageView == nil)
                {
                    [self createViews];
                }
            }
            else if (fadeDuration == 0 && splashDuration == 0)
            {
                [self destroyViews];
            }
            else
            {
                __weak __typeof(self) weakSelf = self;
                float effectiveSplashDuration;
                
                // [CB-10562] AutoHideSplashScreen may be "true" but we should still be able to hide the splashscreen manually.
                if (!autoHideSplashScreen || force) {
                    effectiveSplashDuration = (fadeDuration) / 1000;
                } else {
                    effectiveSplashDuration = (splashDuration - fadeDuration) / 1000;
                }
                NSAssert(effectiveSplashDuration < 8, @"effectiveSplashDuration should be less than 8s...");
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t) effectiveSplashDuration * NSEC_PER_SEC), dispatch_get_main_queue(), CFBridgingRelease(CFBridgingRetain(^(void) {
                    if (self.isIOS8) {
                        [(CDVViewController *)self.viewController setEnabledAutorotation:[(CDVViewController *)self.viewController shouldAutorotateDefaultValue]];
                        [UIViewController attemptRotationToDeviceOrientation];
                    }
                    if (!_destroyed) {
                        [UIView transitionWithView:self.viewController.view
                                          duration:(fadeDuration / 1000)
                                           options:UIViewAnimationOptionTransitionNone
                                        animations:^(void) {
                                            CDVSplashScreen *strongSelf = weakSelf;
                                            [strongSelf hideViews];
                                        }
                                        completion:^(BOOL finished) {
                                            CDVSplashScreen *strongSelf = weakSelf;
                                            
                                            // Always destroy views, otherwise you could have an
                                            // invisible splashscreen that is overlayed over your active views
                                            // which causes that no touch events are passed
                                            if (!_destroyed) {
                                                [strongSelf destroyViews];
                                                // TODO: It might also be nice to have a js event happen here -jm
                                            }
                                        }
                         ];
                    }
                })));
            }
        }
    }
}

@end
