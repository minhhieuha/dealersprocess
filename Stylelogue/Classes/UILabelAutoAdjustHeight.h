//
//  UILabelAutoAdjustHeight.h
//  trackasave
//
// on 5/27/10.
// Rubify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UILabel(AutoAdjustHeight)

- (void) adjustHeight;
- (void)positionAfter:(UILabel *)label ;
- (void)positionAfter:(UILabel *)label withGap:(CGFloat)gap;

- (CGSize)expectedSizeWithString:(NSString *)str;
+ (CGSize)expectedLabelSizeWithLabel:(UILabel *)label ofString:(NSString *)str;
+ (CGSize)expectedLabelSizeWithFont:(UIFont *)font andWidth:(CGFloat)width andString:(NSString *)str;

- (void)adjustWidth:(CGFloat)initialSize;
- (void)adjustWidth;

@end

