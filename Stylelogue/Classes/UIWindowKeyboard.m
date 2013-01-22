//
//  UIWindowKeyboard.m
//
//
// on 7/1/10.
// Rubify. All rights reserved.
//

#import "UIWindowKeyboard.h"


@implementation UIWindow(KeyboardUIView)

+ (UIView *)keyboardView
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	NSEnumerator *windowEnumerator = [windows objectEnumerator];
	UIWindow *window;
	UIView* keyboard = nil;
	
	while (!keyboard && (window = [windowEnumerator nextObject])) {
		int len = [window.subviews count];
		for(int i = 0; i < len; i++)
		{
			UIView *view = [window.subviews objectAtIndex:i];
			if(([[view description] hasPrefix:@"<UIKeyboard"] == YES) || 
				!strcmp(object_getClassName(view), "UIKeyboard") || 
			    ([[view description] hasPrefix:@"<UIPeripheralHostView"] == YES)
			   
			   ) 
			{
				keyboard = view;
				break;
			}
		}
	}
	
	return keyboard;
}

+ (void)resignAnyKeyboard
{
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	UIView   *firstResponder = [keyWindow findFirstResponder];
	[firstResponder resignFirstResponder];
}	



@end


@implementation UIView (FindAndResignFirstResponder)

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder]) {
        return self;     
    }
    for (UIView *subview in self.subviews) {
		UIView *firstResponder = [subview findFirstResponder];
        if (firstResponder) {
            return firstResponder;
		}
    }
    return nil;
}
@end
