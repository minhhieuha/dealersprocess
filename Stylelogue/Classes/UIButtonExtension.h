//
//  UIButtonExtension.h
//  trackasave
//
// on 5/20/10.
// Rubify. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton(ButtonFactoryGeneration)

+ (UIButton *)buttonWithImageNamed:(NSString *)name;

+ (UIButton *)buttonWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor;

+ (UIButton *)simpleWhiteButtonWithTitle:(NSString *)title
								  target:(id)target
								selector:(SEL)selector
								position:(CGPoint)point
								   width:(CGFloat)buttonWidth;

+ (UIButton *)pillBlueButtonWithTitle:(NSString *)title
								  target:(id)target
								selector:(SEL)selector
								position:(CGPoint)point
								   width:(CGFloat)buttonWidth;

+ (UIButton *)pillGreenButtonWithTitle:(NSString *)title
							   target:(id)target
							 selector:(SEL)selector
							 position:(CGPoint)point
								width:(CGFloat)buttonWidth;


+ (UIButton *)pillGlossBlueButtonWithTitle:(NSString *)title
									target:(id)target
								  selector:(SEL)selector
								  position:(CGPoint)point
									 width:(CGFloat)buttonWidth;

+ (UIButton *)smallPillWhiteWithArrowButtonWithTitle:(NSString *)title
									 target:(id)target
								   selector:(SEL)selector
								   position:(CGPoint)point
									  width:(CGFloat)buttonWidth;

+ (UIButton *)pillDropDownButtonWithTitle:(NSString *)title
								   target:(id)target
								 selector:(SEL)selector
								 position:(CGPoint)point
									width:(CGFloat)buttonWidth;

+ (UIButton *)smallGreenPillButtonWithTitle:(NSString *)title
									 target:(id)target
								   selector:(SEL)selector
								   position:(CGPoint)point
									  width:(CGFloat)buttonWidth;

+ (UIButton *)smallBluePillButtonWithTitle:(NSString *)title
									target:(id)target
								  selector:(SEL)selector
								  position:(CGPoint)point
									 width:(CGFloat)buttonWidth;

+ (UIButton *)smallSkypeBluePillButtonWithTitle:(NSString *)title
									target:(id)target
								  selector:(SEL)selector
								  position:(CGPoint)point
									 width:(CGFloat)buttonWidth;

+ (UIButton *)smallRedPillButtonWithTitle:(NSString *)title
								   target:(id)target
								 selector:(SEL)selector
								 position:(CGPoint)point
									width:(CGFloat)buttonWidth;

+ (UIButton *)graphWhiteButtonWithTitle:(NSString *)title
								 target:(id)target
							   selector:(SEL)selector
							   position:(CGPoint)point
								  width:(CGFloat)buttonWidth;

+ (UIButton *)numericPadButton:(NSString*)_image;

+ (UIButton *)tabButtonWithTitle:(NSString *)title;


@end
