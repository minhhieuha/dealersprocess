//
//  CAAnimationEffect.m
//  trackasave
//
// on 5/28/10.
// Rubify. All rights reserved.
//

#import "UIViewAnimation.h"
#import "UIViewExtension.h"
#define CGAutorelease(x) (__typeof(x))[NSMakeCollectable(x) autorelease]
#define floatNum(x) [NSNumber numberWithFloat:x]

@implementation UIView(CAExtendAnimation)

- (void)fadeIn
{
	[self fadeInWithTiming:floatNum(0.25)];
}

- (void)fadeOut
{
	[self fadeOutWithTiming:floatNum(0.5)];
}

- (void)pullUp
{
	[self pullUpWithTiming:floatNum(0.15)];
}

- (void)pullDownToTop:(NSNumber *)topOffset
{
	[self pullDownWithTiming:floatNum(0.2) toTopOffset:topOffset];
}

- (void)yellowFade
{
	[self yellowFadeWithTiming:floatNum(0.9)];
}

- (void)fadeInWithTiming:(NSNumber *)timeInterval
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];

	[self setHidden:NO];
	CALayer *touchedLayer = [self layer];
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil];
	alphaAnimation.duration = [timeInterval floatValue];
	alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[touchedLayer removeAllAnimations];
	[touchedLayer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
	[self setAlpha:1];
	
	[pool drain];
}

- (void)fadeOutWithTiming:(NSNumber *)timeInterval
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];

	CALayer *touchedLayer = [self layer];
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.0], nil];
	alphaAnimation.duration = [timeInterval floatValue];
	alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[touchedLayer removeAllAnimations];
	[touchedLayer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
	[self setAlpha:0];
	
	[self performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.6];	
	
	[pool drain];
}


- (void)pullUpWithTiming:(NSNumber *)timeInterval
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	CALayer *touchedLayer = [self layer];
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.duration = [timeInterval floatValue]+0.05;
	positionAnimation.repeatCount = 0;
	positionAnimation.autoreverses = NO;
	
	CGMutablePathRef positionPath = CGAutorelease(CGPathCreateMutable());
    CGPathMoveToPoint(positionPath, NULL, touchedLayer.position.x, touchedLayer.position.y);
    CGPathAddLineToPoint(positionPath, NULL, touchedLayer.position.x, touchedLayer.position.y - self.frame.size.height - self.frame.origin.y - 300);
    positionAnimation.path = positionPath;
	
	positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[touchedLayer removeAllAnimations];
	[touchedLayer addAnimation:positionAnimation forKey:@"positionAnimation"];
	
	[self performSelector:@selector(hideView) withObject:NULL afterDelay:[timeInterval floatValue]];
	//[self performSelector:@selector(removeFromSuperview) withObject:NULL afterDelay:timeInterval+0.5];
	
	[pool drain];
}

- (void)pullDownWithTiming:(NSNumber *)timeInterval toTopOffset:(NSNumber *)topOffset
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	[self setTop:[topOffset floatValue] - self.height - 100];
	[self setHidden:NO];
	
	CALayer *touchedLayer = [self layer];
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.duration = [timeInterval floatValue]+0.05;
	positionAnimation.repeatCount = 0;
	positionAnimation.autoreverses = NO;
	
	CGMutablePathRef positionPath = CGAutorelease(CGPathCreateMutable());
    CGPathMoveToPoint(positionPath, NULL, touchedLayer.position.x, touchedLayer.position.y);
    CGPathAddLineToPoint(positionPath, NULL, touchedLayer.position.x, touchedLayer.position.y + self.height + 100);
    positionAnimation.path = positionPath;
	
	positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[touchedLayer removeAllAnimations];
	[touchedLayer addAnimation:positionAnimation forKey:@"positionAnimation"];
	
	[self setTop:[topOffset floatValue]];
	
	[pool drain];	
}


- (void)yellowFadeWithTiming:(NSNumber *)timeInterval
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	CALayer *touchedLayer = [self layer];
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:1], 
							 [NSNumber numberWithFloat:0.05], 
							 [NSNumber numberWithFloat:0.85], 
							 [NSNumber numberWithFloat:0.05], 
							 [NSNumber numberWithFloat:0.8], 
							 [NSNumber numberWithFloat:0.05], 
							 [NSNumber numberWithFloat:0.5], 
							 [NSNumber numberWithFloat:0.0], 
							 nil];
	alphaAnimation.duration = [timeInterval floatValue];
	alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[touchedLayer removeAllAnimations];
	[touchedLayer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
	
	[pool drain];
}


- (void)hideView
{
	[self setHidden:YES];
}

@end
