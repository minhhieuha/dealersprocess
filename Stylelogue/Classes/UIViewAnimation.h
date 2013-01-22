//
//  CAAnimationEffect.h
//  trackasave
//
// on 5/28/10.
// Rubify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView(CAExtendAnimation)

- (void)fadeIn;
- (void)fadeOut;
- (void)pullUp;
- (void)fadeInWithTiming:(NSNumber *)timeInterval;
- (void)fadeOutWithTiming:(NSNumber *)timeInterval;
- (void)pullUpWithTiming:(NSNumber *)timeInterval;
- (void)pullDownToTop:(NSNumber *)topOffset;
- (void)pullDownWithTiming:(NSNumber *)timeInterval toTopOffset:(NSNumber *)topOffset;

@end
