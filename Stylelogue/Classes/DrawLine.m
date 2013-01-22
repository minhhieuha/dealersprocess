//
//  DrawLine.m
//  WebViewForOpinion
//


//

#import "DrawLine.h"
#import "ColorDirective.h"

#define c(x) ((componentsAnimateEnd[x]-componentsAnimateStart[x])*colorShift+componentsAnimateStart[x])

@implementation DrawLine

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		colorAdder = 0.1;
		colorShift = 0;
		[self setBackgroundColor:[UIColor clearColor]];
		//[[[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(updateAnimation) userInfo:nil repeats:YES] retain] fire];
    }
    return self;
}

- (void)updateAnimation
{
	colorShift += colorAdder;
	if (colorShift >= 1) {
		colorAdder = -0.1;
		colorShift = 1;
	}
	if (colorShift <= 0) {
		colorAdder = 0.1;
		colorShift = 0;
	}
	[self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	//[super drawRect:rect];

	CGFloat pad = 0;
	CGFloat diameter = self.frame.size.height - pad*2;
	CGFloat length = self.frame.size.width - diameter - pad*2;
	CGContextRef myContext =  UIGraphicsGetCurrentContext();
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddArc(path, NULL, pad + diameter/2, pad + diameter/2, diameter/2, M_PI/2, 1.5*M_PI, NO);
	CGPathAddRect(path, NULL, CGRectMake(pad + diameter/2, pad, length, diameter));
	CGPathAddArc(path, NULL, pad + diameter/2 + length, pad + diameter/2, diameter/2, 1.5*M_PI, 2.5*M_PI, NO);
	CGContextSetRGBFillColor(myContext, 0, 0, 0, 0.3);
	CGContextAddPath(myContext, path);
	
	CGContextSetLineWidth(myContext, 2);
	CGContextSetStrokeColorWithColor(myContext, [UIColor blackColor].CGColor);
	CGContextSetShadow(myContext, CGSizeMake(0, 0), 3);

	CGContextFillPath(myContext);
	CGPathRelease(path);
	
	pad = 0;
	path = CGPathCreateMutable();
	CGPathAddArc(path, NULL, pad + diameter/2, pad + diameter/2, diameter/2, M_PI/2, 1.5*M_PI, NO);
	CGPathAddRect(path, NULL, CGRectMake(pad + diameter/2, pad, length, diameter));
	CGPathAddArc(path, NULL, pad + diameter/2 + length, pad + diameter/2, diameter/2, 1.5*M_PI, 2.5*M_PI, NO);
	
	CGContextAddPath(myContext, path);

	CGContextClip(myContext);
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	
	CGFloat componentsAnimateStart[8] = {
		RGBA(0xff, 0xf7, 0x05, 1.0),  // Start color
		RGBA(0xff, 0x8c, 0x00, 1.0) }; // End color

	CGFloat componentsAnimateEnd[8] = {
		RGBA(0xff, 0xb1, 0x00, 1.0),  // Start color
		RGBA(0xff, 0xf6, 0x05, 1.0) }; // End color
	
	CGFloat componentsAnimateResult[8] = {
		c(0), c(1), c(2), c(3),  // Start color
		c(4), c(5), c(6), c(7) }; // End color
	
	
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, componentsAnimateResult,
													  locations, num_locations);
	CGPoint myStartPoint, myEndPoint;
	myStartPoint.x = 0.0;
	myStartPoint.y = 0.0;
	XQDebug(@"\nWidth: %f\n", rect.size.width);
	myEndPoint.x = rect.size.width;
	myEndPoint.y = 0.0;
	
	CGContextDrawLinearGradient (myContext, myGradient, myStartPoint, myEndPoint, 0);
	CGGradientRelease(myGradient);
	CGPathRelease(path);
	CGColorSpaceRelease(myColorspace);

}


- (void)dealloc {
    [super dealloc];
}


@end
