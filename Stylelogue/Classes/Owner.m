//
//  Owner.m
//  Stylelogue
//


//

#import "Owner.h"


@implementation Owner
@synthesize fb_user_id;
@synthesize user_id;
@synthesize like_item;
@synthesize name;


-(void)dealloc
{
	
	[fb_user_id release];
	[name release];
	[super dealloc];
}
@end
