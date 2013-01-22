//
//  Opinion.m
//  Stylelogue
//


//

#import "Opinion.h"


@implementation Opinion

@synthesize ID;
@synthesize content;
@synthesize posted_at;
@synthesize owner;


-(void)dealloc
{
	[content release];
	[posted_at release];
	[owner release];
	[super dealloc];
}

@end
