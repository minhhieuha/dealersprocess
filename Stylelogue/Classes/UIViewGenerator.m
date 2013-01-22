//
//  UIViewGenerator.m
//  trackasave
//
// on 5/27/10.
// Rubify. All rights reserved.
//

#import "UIViewGenerator.h"
#import "ColorDirective.h"

@implementation UIView(UIViewGenerator)

+ (id)viewWithBackgroundColor:(UIColor *)color
{
	id view = [[self alloc] init];
	[view setBackgroundColor:color];
	
	[view autorelease];
	return view;
}

+ (id)viewWithGrayBackground:(CGFloat)grayLevel
{
	return [self viewWithBackgroundColor:RGBCOLOR(grayLevel, grayLevel, grayLevel)];
}

+ (id)viewWithBackgroundImage:(NSString *)string
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	UIImage *image = [UIImage imageNamed:string];
	id view = [[self alloc] init];
	[view setBackgroundColor:[UIColor colorWithPatternImage:image]];
	[view setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	
	[pool release];
	[view autorelease];
	return view;
}

+ (id)viewWithStretchableBackgroundImage:(NSString *)string widthCap:(NSInteger)widthCap andHeightCap:(NSInteger)heightCap
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	UIImage *image = [[UIImage imageNamed:string] stretchableImageWithLeftCapWidth:widthCap topCapHeight:heightCap];
	UIImageView *subview = [[UIImageView alloc] initWithImage:image];
	id view = [[self alloc] init];
	
	[view addSubview:subview];
	[subview setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	[view setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	[subview clampFlexibleMiddle];
	[subview release];
	
	[pool release];
	[view autorelease];	
	return view;
}


+ (id)viewWithClearBackgroundImage:(NSString *)string
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	UIImage *image = [UIImage imageNamed:string];
	UIImageView *subview = [[UIImageView alloc] initWithImage:image];
	subview.userInteractionEnabled = NO;
	subview.exclusiveTouch = NO;
	subview.multipleTouchEnabled = NO;
	
	id view = [[self alloc] init];
	
	[view addSubview:subview];
	[subview setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	[view setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	[subview clampFlexibleMiddle];
	[subview release];
	
	[pool release];
	[view autorelease];
	return view;
}

- (void)updateStretchableBackground:(NSString *)string
{
	UIImageView *subview = [self subViewByClassName:@"UIImageView"];
	if (subview) {
		UIImage *image = [[UIImage imageNamed:string] stretchableImageWithLeftCapWidth:[subview.image leftCapWidth] topCapHeight:[subview.image topCapHeight]];
		[subview setImage:image];
	}
}

@end
