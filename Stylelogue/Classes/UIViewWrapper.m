//
//  UIViewWrapper.m
//  Stylelogue
//


//

#import "UIViewWrapper.h"


@implementation UIViewWrapper

@synthesize receiver;
@synthesize delegate;
@synthesize shouldJumback;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	[self.receiver touchesMoved:touches withEvent:event];
	
	shouldJumback = NO;
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	shouldJumback = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (shouldJumback) {
		if (delegate) {
			[delegate tap];
			self.receiver.tap = YES;
		}
	}
	
	self.receiver.tap = NO;
	[self.receiver touchesEnded:touches withEvent:event];
}

-(void)dealloc
{
	[super dealloc];
	[receiver release];
}
@end
