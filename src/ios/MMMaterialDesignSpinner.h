//
//  MMMaterialDesignSpinner.h
//  Pods
//
//  Created by Michael Maxwell on 12/28/14.
//
//

#import <UIKit/UIKit.h>
#import "ActivityTracking.h"

//! Project version number for MMMaterialDesignSpinner.
FOUNDATION_EXPORT double MMMaterialDesignSpinnerVersionNumber;

//! Project version string for MMMaterialDesignSpinner.
FOUNDATION_EXPORT const unsigned char MMMaterialDesignSpinnerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Cent/PublicHeader.h>

/**
 *  A control similar to iOS' UIActivityIndicatorView modeled after Google's Material Design Activity spinner.
 */
@interface MMMaterialDesignSpinner : UIView <ActivityTracking>

/** Sets the line width of the spinner's circle. */
@property (nonatomic) CGFloat lineWidth;

/** Specifies the timing function to use for the control's animation. Defaults to kCAMediaTimingFunctionEaseInEaseOut */
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

/** Property indicating the duration of the animation, default is 1.5s. Should be set prior to -[startAnimating] */
@property (nonatomic, readwrite) NSTimeInterval duration;

/**
 *  Convenience function for starting & stopping animation with a boolean variable instead of explicit
 *  method calls.
 *
 *  @param animate true to start animating, false to stop animating.
 @note This method simply calls the startAnimating or stopAnimating methods based on the value of the animate parameter.
 */
- (void)setAnimating:(BOOL)animate;

@end
