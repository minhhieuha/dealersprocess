//
//  UIImageViewExtension.m
//  Stylelogue
//
//

#import "UIImageViewExtension.h"


@implementation UIImageViewExtension

@synthesize tap;

- (NSInteger)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
	
	CGFloat deltaX = fabsf(point1.x - point2.x);
	
	CGFloat deltaY = fabsf(point1.y - point2.y);
	
	CGFloat distance = sqrt((deltaY*deltaY)+(deltaX*deltaX));
	
	return distance;
	
}



- (CGFloat)angleBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2

{ 
	
	CGFloat deltaY = point1.y - point2.y;
	
	CGFloat deltaX = point1.x - point2.x;
	
	CGFloat angle = atan2(deltaY, deltaX);
	
	return angle;
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	

	if( [touches count] == 1 ) {
		
		float difx = [[touches anyObject] locationInView:self].x - [[touches anyObject] previousLocationInView:self].x;
		
		float dify = [[touches anyObject] locationInView:self].y - [[touches anyObject] previousLocationInView:self].y;
		
		
		
		CGAffineTransform newTransform1 = CGAffineTransformTranslate(self.transform, difx, dify);
		
		self.transform = newTransform1;
		
	} else   if( [touches count] == 2 ) {
		
		int prevmidx = ([[[touches allObjects] objectAtIndex:0] previousLocationInView:self].x + [[[touches allObjects] objectAtIndex:1] previousLocationInView:self].x) / 2;
		
		int prevmidy = ([[[touches allObjects] objectAtIndex:0] previousLocationInView:self].y + [[[touches allObjects] objectAtIndex:1] previousLocationInView:self].y) / 2;
		
		int curmidx = ([[[touches allObjects] objectAtIndex:0] locationInView:self].x + [[[touches allObjects] objectAtIndex:1] locationInView:self].x) / 2;
		
		int curmidy = ([[[touches allObjects] objectAtIndex:0] locationInView:self].y + [[[touches allObjects] objectAtIndex:1] locationInView:self].y) / 2;
		
		int difx = curmidx - prevmidx;
		
		int dify = curmidy - prevmidy;
		
		
		CGPoint prevPoint1 = [[[touches allObjects] objectAtIndex:0] previousLocationInView:self];
		
		CGPoint prevPoint2 = [[[touches allObjects] objectAtIndex:1] previousLocationInView:self];
		
		CGPoint curPoint1 = [[[touches allObjects] objectAtIndex:0] locationInView:self];
		
		CGPoint curPoint2 = [[[touches allObjects] objectAtIndex:1] locationInView:self];
		
		float prevDistance = [self distanceBetweenPoint1:prevPoint1 andPoint2:prevPoint2];
		
		float newDistance = [self distanceBetweenPoint1:curPoint1 andPoint2:curPoint2];
		
		float sizeDifference = (newDistance / prevDistance);
		
		
		if (self.tag != 0) {
			
			XQDebug(@"\nDistance: %f\n",sizeDifference);
			if (sizeDifference > 1 && self.width >=  self.image.size.width*2) {
				return;
			}
		}
		
		CGAffineTransform newTransform1 = CGAffineTransformTranslate(self.transform, difx, dify);
		
		self.transform = newTransform1;
		
		
		CGAffineTransform newTransform2 = CGAffineTransformScale(self.transform, sizeDifference, sizeDifference);
		
		self.transform = newTransform2;
		

		float prevAngle = [self angleBetweenPoint1:prevPoint1 andPoint2:prevPoint2];
		
		float curAngle = [self angleBetweenPoint1:curPoint1 andPoint2:curPoint2];
		
		float angleDifference = curAngle - prevAngle;
		
		
		
		//CGAffineTransform newTransform3 = CGAffineTransformRotate(self.transform, angleDifference);
		
//		if (self.tag == 0) {
//			self.transform = newTransform3;
//		}
		
		}
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{ 

	if (self.tag != 0) {
		
		if (self.width <= 320)
		{	
			self.frame = CGRectMake(0,0,320,480);
		}
	}
	
	if (self.tag == 1 && !tap) {
		
		if (self.top >= 0 && self.top + self.height <= 480 && self.left >= 0 && self.left + self.width <= 320) {
			return;
		}
	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		
		if (self.top >= 0) {
			
			self.top = 0;
		}
		else if (self.top + self.height <= 480) {
			
			self.top = 480 - self.height;
		}
	
		if (self.left >= 0) {
			
			self.left = 0;
		}
		else if (self.left + self.width <= 320) {
			
			self.left = 320 - self.width;
		}
		
		[UIView commitAnimations];
		
	}
}

@end















