//
//  UANavigationBarRedraw.m
//  trackasave
//
// on 5/16/10.
// Rubify. All rights reserved.
//

#import "UANavigationBarRedraw.h"
#import "ColorDirective.h"

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
	
	// emulate the tint colored bar
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat locations[2] = { 0.0, 0.7, 1.0 };
	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGFloat topComponents[8] = { RGBA(0x00,0x00,0x00,1), RGBA(0x00,0x00,0x00,1), RGBA(0x00,0x00,0x00,1) };
	CGGradientRef topGradient = CGGradientCreateWithColorComponents(myColorspace, topComponents, locations, 2);
	CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, 0), CGPointMake(0,self.frame.size.height), 0);
	CGGradientRelease(topGradient);
	
	CGColorSpaceRelease(myColorspace);

	CGContextSetLineWidth(context,2);
	CGContextSetRGBStrokeColor(context, 0x22, 0x22, 0x22, 0.1); 
	
	CGContextMoveToPoint(context, 0, self.frame.size.height);
	CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
	CGContextStrokePath(context);	
}

@end


//@implementation UIToolbar (UINavigationBarCategory)
//
//- (void)drawRect:(CGRect)rect {
//	
//	NSLog(@"\n- (void)drawRect:(CGRect)rect {\n");
//	// emulate the tint colored bar
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGFloat locations[2] = { 0.0, 0.7, 1.0 };
//	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
//	
//	CGFloat topComponents[8] = { RGBA(0xff,0x00,0x00,1), RGBA(0xff,0x00,0x00,1), RGBA(0xff,0x00,0x00,1) };
//	CGGradientRef topGradient = CGGradientCreateWithColorComponents(myColorspace, topComponents, locations, 2);
//	CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, 0), CGPointMake(0,self.frame.size.height), 0);
//	CGGradientRelease(topGradient);
//	
//	CGColorSpaceRelease(myColorspace);
//
//	// top Line
//	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
//	CGContextMoveToPoint(context, 0, 0);
//	CGContextAddLineToPoint(context, self.frame.size.width, 0);
//	CGContextStrokePath(context);
//	
//	// bottom line
//	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
//	CGContextMoveToPoint(context, 0, self.frame.size.height);
//	CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
//	CGContextStrokePath(context);
//	
//}
//
//@end
