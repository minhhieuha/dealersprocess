//
//  UIButtonExtension.m
//  trackasave
//
// on 5/20/10.
// Rubify. All rights reserved.
//

#import "UIButtonExtension.h"
#import "ColorDirective.h"
#import "UIViewExtension.h"

@implementation UIButton(ButtonFactoryGeneration)

+ (UIButton *)buttonWithImageNamed:(NSString *)name
{
	UIImage *normalImage = [UIImage imageNamed:name];
	UIImage *pressedImage = [UIImage imageNamed:[name stringByReplacingOccurrencesOfString:@".png" withString:@".pressed.png"]];
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
	[button setImage:normalImage forState:UIControlStateNormal];
	[button setImage:pressedImage forState:UIControlStateHighlighted];
	[button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, normalImage.size.width, normalImage.size.height)];

	return [button autorelease];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{	
	//UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = frame;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}




+ (UIButton *)simpleWhiteButtonWithTitle:(NSString *)title
								   target:(id)target
								 selector:(SEL)selector
								position:(CGPoint)point
								   width:(CGFloat)buttonWidth
{	
	UIImage *image = [UIImage imageNamed:@"images/whiteButton.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/blueButton.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

+ (UIButton *)pillBlueButtonWithTitle:(NSString *)title
								  target:(id)target
								selector:(SEL)selector
								position:(CGPoint)point
								   width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/pillBlueDark.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/pillBlue.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];

	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


+ (UIButton *)graphWhiteButtonWithTitle:(NSString *)title
							   target:(id)target
							 selector:(SEL)selector
							 position:(CGPoint)point
								width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/graphWhite.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/graphWhiteActive.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:newPressedImage forState:UIControlStateSelected];

	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

+ (UIButton *)pillGreenButtonWithTitle:(NSString *)title
							   target:(id)target
							 selector:(SEL)selector
							 position:(CGPoint)point
								width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/pillGreen.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/pillGreenDark.png"];

	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];

	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


+ (UIButton *)pillGlossBlueButtonWithTitle:(NSString *)title
								target:(id)target
							  selector:(SEL)selector
							  position:(CGPoint)point
								 width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/pillGlossBlue.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/pillGlossBlueDark.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];

	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:10.0 topCapHeight:2.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

+ (UIButton *)smallRedPillButtonWithTitle:(NSString *)title
									target:(id)target
								  selector:(SEL)selector
								  position:(CGPoint)point
									 width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/smallRedPill.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/smallRedPillDarker.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];

	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


+ (UIButton *)smallGreenPillButtonWithTitle:(NSString *)title
								   target:(id)target
								 selector:(SEL)selector
								 position:(CGPoint)point
									width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/smallGreenPill.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/smallGreenPillDarker.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];

	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}



+ (UIButton *)smallBluePillButtonWithTitle:(NSString *)title
									 target:(id)target
								   selector:(SEL)selector
								   position:(CGPoint)point
									  width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/smallBluePill.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/smallBluePillDarker.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


+ (UIButton *)smallSkypeBluePillButtonWithTitle:(NSString *)title
									target:(id)target
								  selector:(SEL)selector
								  position:(CGPoint)point
									 width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/smallSkypeBluePill.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/smallSkypeBluePillDarker.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:6 topCapHeight:6];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}




+ (UIButton *)smallPillWhiteWithArrowButtonWithTitle:(NSString *)title
							   target:(id)target
							 selector:(SEL)selector
							 position:(CGPoint)point
								width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/pillWhite.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/pillWhiteDark.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, buttonWidth, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

	[button setTitleColor:RGBCOLOR(80,99,113) forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:28.0 topCapHeight:9.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:10.0 topCapHeight:9.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


+ (UIButton *)pillDropDownButtonWithTitle:(NSString *)title
											  target:(id)target
											selector:(SEL)selector
											position:(CGPoint)point
											   width:(CGFloat)buttonWidth
{
	UIImage *image = [UIImage imageNamed:@"images/pillDropDown.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/pillDropDownBlack.png"];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(point.x, point.y, 160, image.size.height);

	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];

	[button setTitleColor:RGBCOLOR(80,99,113) forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:28.0 topCapHeight:9.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:28.0 topCapHeight:9.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}



+ (UIButton *)numericPadButton:(NSString*)_image
{
	UIImage *image = [UIImage imageNamed:_image];
	UIImage *pressedImage = [UIImage imageNamed:[_image stringByReplacingOccurrencesOfString:@".png" withString:@".pressed.png"]];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	button.autoresizingMask = YES;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitleColor:RGBCOLOR(0xFF, 0xFF, 0xFF) forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithWhite:0xFF alpha:0.5] forState:UIControlStateHighlighted];
	[button setTitleShadowColor:RGBCOLOR(0x00, 0x00, 0x00) forState:UIControlStateNormal];
	//[button setTitleShadowColor:RGBCOLOR(0xFF, 0xFF, 0xFF) forState:UIControlStateHighlighted];
	//[button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
	//[button.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
	
	[button setTitle:@"" forState:UIControlStateNormal];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:0 topCapHeight:6];
	[button setBackgroundImage: newImage forState:UIControlStateNormal];
	UIImage *newPressedImage = [pressedImage stretchableImageWithLeftCapWidth:0 topCapHeight:6];
	[button setBackgroundImage: newPressedImage forState:UIControlStateHighlighted];
	
	return [button autorelease];
}

+ (UIView *)numericPadButtonAndText:(NSString*)_image text:(NSString*)text
{
	UIImage *image = [UIImage imageNamed:_image];
	//UIImage *imagePressed = [UIImage imageNamed:_image];
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	button.autoresizingMask = YES;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitleColor:RGBCOLOR(0xFF, 0xFF, 0xFF) forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithWhite:0xFF alpha:0.5] forState:UIControlStateHighlighted];
	[button setTitleShadowColor:RGBCOLOR(0x00, 0x00, 0x00) forState:UIControlStateNormal];
	//[button setTitleShadowColor:RGBCOLOR(0xFF, 0xFF, 0xFF) forState:UIControlStateHighlighted];
	//[button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
	//[button.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
	
	[button setTitle:@"" forState:UIControlStateNormal];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:0 topCapHeight:6];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	//UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:0 topCapHeight:6];
	
	button.backgroundColor = [UIColor clearColor];
	
	//	CGSize s= [[NSString stringWithString:@"some string"] sizeWithFont:textLabel.font];
	//	s.width
	
	// TODO
	// 1. Realign the buttons
	// 2. Change to the plus add to lookbook icon (icon.add.to.looksbook.png)
	// 3. Use the orange color lookbook icon if it has been added to looksbook
	// 4. User orange color comment icon if there is more than 0 comment
	// 5. I will pass you a library to shrink the text according to given width, e.g. the number says 103, it will try to shrink it down to fit that width, it will auto magically find the correct font size for that
	
	// 6. Image Preview, when click to zoom, make sure the position remain the same, don't fit to top left
	
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, button.width + 20, button.height + 50)] autorelease];
	[view setBackgroundColor:[UIColor clearColor]];
	[button setLeft:view.width/2-button.width/2];
	[view addSubview:button];
	UILabel *textLabel = [[UILabel alloc] initWithFrame:button.frame] ;
	[textLabel setTop:button.height + 5];
	[view addSubview:textLabel];
	[textLabel release];
	
	return view;
}


+ (UIButton *)tabButtonWithTitle:(NSString *)title
{
	UIImage *image = [UIImage imageNamed:@"images/tab.inactive.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"images/tab.active.png"];

	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitleColor:RGBCOLOR(0x3E, 0x3E, 0x3E) forState:UIControlStateNormal];
	[button setTitleColor:RGBCOLOR(0x66, 0x66, 0x66) forState:UIControlStateHighlighted];
	[button setTitleColor:RGBCOLOR(0x66, 0x66, 0x66) forState:UIControlStateSelected];
	[button setTitleShadowColor:RGBCOLOR(0xBB, 0xBB, 0xBB) forState:UIControlStateNormal];
	[button setTitleShadowColor:RGBCOLOR(0xFF, 0xFF, 0xFF) forState:UIControlStateHighlighted];
	[button setTitleShadowColor:RGBCOLOR(0xFF, 0xFF, 0xFF) forState:UIControlStateSelected];
	[button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[button setTitle:title forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:4 topCapHeight:6];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:4 topCapHeight:6];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:newPressedImage forState:UIControlStateSelected];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

@end
