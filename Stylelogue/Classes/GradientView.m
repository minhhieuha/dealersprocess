//
//  GradientView.m
//  Stylelogue
//


//

#import "GradientView.h"
#import "ColorDirective.h"

@implementation GradientView

- (void)drawRect:(CGRect)rect {
    // Drawing code	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat locations[3] = { 0.0, 0.5, 1.0 };
	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGFloat topComponents[3*4] = { RGBA(0x00,0x00,0x00,1), RGBA(0x00,0x00,0x00,1), RGBA(0x00,0x00,0x00,1) };
	CGGradientRef topGradient = CGGradientCreateWithColorComponents(myColorspace, topComponents, locations, 3);
	CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, 0), CGPointMake(0,self.frame.size.height), 0);
	CGGradientRelease(topGradient);
	
	CGColorSpaceRelease(myColorspace);
	
	//To set the top line color
	CGContextSetLineWidth(context,3);
	CGContextSetRGBStrokeColor(context, RGBA(0x25, 0x25, 0x25, .7));
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, self.frame.size.width, 0);
	CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
