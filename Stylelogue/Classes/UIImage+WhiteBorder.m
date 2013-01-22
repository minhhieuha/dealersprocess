//
//  UIImage+WhiteBorder.m
//  Stylelogue
//
//  Created by Freddy Wang on 12/28/10.

//

#import "UIImage+WhiteBorder.h"
#import "ColorDirective.h"

@implementation UIImage(WhiteBorder)

#define maxval(a,b) (a>b?a:b)



- (UIImage *)brownBorderedImage:(BOOL)ok
{
	float borderWidth = 1;
	
	CGFloat scaleFactor = 1;
	if ([self respondsToSelector:@selector(scale)]) {
		scaleFactor = [UIScreen mainScreen].scale;
	}
	
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, (self.size.width+ borderWidth)*scaleFactor, (self.size.height+ borderWidth)*scaleFactor, CGImageGetBitsPerComponent(self.CGImage), 0, 
												 colourSpace, kCGImageAlphaPremultipliedLast);
	
	CGContextConcatCTM(context, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    CGColorSpaceRelease(colourSpace);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, CGRectMake(borderWidth/2, borderWidth/2, self.size.width, self.size.height));
    CGContextDrawImage(context, CGRectMake(borderWidth/2, borderWidth/2, self.size.width, self.size.height), self.CGImage);
	CGContextRestoreGState(context);
	
	CGContextSetBlendMode(context, kCGBlendModeColorDodge);
	CGContextSetStrokeColorWithColor(context, RGBACOLOR(0x5F, 0x5F, 0x5F, 1).CGColor);
	CGContextSetLineWidth(context, borderWidth);
	CGContextSetLineJoin(context, kCGLineJoinMiter);
	if (ok) {
		CGContextStrokeRect(context, CGRectMake(borderWidth/2, borderWidth/2, self.size.width, self.size.height));
	}
	
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	
	UIImage * finalImage;
	if (shadowedCGImage) {
		if ([self respondsToSelector:@selector(scale)]) {
			finalImage = [UIImage imageWithCGImage:shadowedCGImage scale:scaleFactor orientation:UIImageOrientationUp];		
		} else {
			finalImage = [UIImage imageWithCGImage:shadowedCGImage];
		}
		CGImageRelease(shadowedCGImage);
	}
	
    return finalImage;
	
}


- (UIImage *)whiteBorderedImage
{
	CGFloat scaleFactor = 1;
	if ([self respondsToSelector:@selector(scale)]) {
		scaleFactor = [UIScreen mainScreen].scale;
	}
	
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, (self.size.width)*scaleFactor, (self.size.height)*scaleFactor, CGImageGetBitsPerComponent(self.CGImage), 0, 
													   colourSpace, kCGImageAlphaPremultipliedLast);
	
	CGContextConcatCTM(context, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    CGColorSpaceRelease(colourSpace);
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, CGRectMake(3, 3, self.size.width-6, self.size.height-6));
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
	CGContextRestoreGState(context);
	
	CGContextSetBlendMode(context, kCGBlendModeColor);
	CGContextSetStrokeColorWithColor(context, RGBACOLOR(0x5F, 0x5F, 0x5F, 1).CGColor);//#5f5f5f
	CGContextSetLineWidth(context, 2);
	CGContextSetLineJoin(context, kCGLineJoinMiter);
	CGContextStrokeRect(context, CGRectMake(3, 3, self.size.width-6, self.size.height-6));
	
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	
	UIImage * finalImage;
	if (shadowedCGImage) {
		if ([self respondsToSelector:@selector(scale)]) {
			finalImage = [UIImage imageWithCGImage:shadowedCGImage scale:scaleFactor orientation:UIImageOrientationUp];		
		} else {
			finalImage = [UIImage imageWithCGImage:shadowedCGImage];
		}
		CGImageRelease(shadowedCGImage);
	}
	
    return finalImage;

}



- (UIImage *)limitedToWidth:(NSNumber *)wd andHeight:(NSNumber *)hg
{
	CGFloat scaleFactor = 1;
	if ([self respondsToSelector:@selector(scale)]) {
		scaleFactor = [UIScreen mainScreen].scale;
	}
	
	CGFloat r = 1;
	CGFloat rw = 1.0 * self.size.width / [wd floatValue];
	CGFloat rh = 1.0 * self.size.height / [hg floatValue];
	
	if (rw > 1 || rh > 1) {
		r = 1.0 / maxval(rw, rh);
	}
	
	NSLog(@"%f", self.size.width);
	NSLog(@"%f", self.size.height);
	NSLog(@"%f", [wd floatValue]);
	NSLog(@"%f", [hg floatValue]);
	NSLog(@"%f", rw);
	NSLog(@"%f", rh);
	NSLog(@"%f", r);
	
	CGFloat targetWidth = self.size.width * r;
	CGFloat targetHeight = self.size.height * r;

	NSLog(@"%f", targetWidth);
	NSLog(@"%f", targetHeight);

	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, targetWidth*scaleFactor, targetHeight*scaleFactor, 
												 CGImageGetBitsPerComponent(self.CGImage), 0, 
												 colourSpace, kCGImageAlphaPremultipliedLast);
	
	CGContextConcatCTM(context, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    CGColorSpaceRelease(colourSpace);
	
	CGContextSaveGState(context);
    CGContextDrawImage(context, CGRectMake(0, 0, targetWidth, targetHeight), self.CGImage);
	CGContextRestoreGState(context);
	
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	
	UIImage * finalImage;
	if (shadowedCGImage) {
		if ([self respondsToSelector:@selector(scale)]) {
			finalImage = [UIImage imageWithCGImage:shadowedCGImage scale:scaleFactor orientation:UIImageOrientationUp];		
		} else {
			finalImage = [UIImage imageWithCGImage:shadowedCGImage];
		}
		CGImageRelease(shadowedCGImage);
	}
	
    return finalImage;
}

@end
