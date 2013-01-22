//
//  UIWindowKeyboard.h
//
//
// on 7/1/10.
// Rubify. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWindow(KeyboardUIView)

+ (UIView *)keyboardView;
+ (void)resignAnyKeyboard;

@end
