//
//  FacebookInfo.m
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookInfo.h"


@implementation FacebookInfo

@synthesize name;
@synthesize uid;
@synthesize location;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"\nname: %@\nuid: %@\nlocation: %@\n", name, uid, location];
}

- (void)dealloc {
	
	[self.name release];
	[self.uid release];
	[self.location release];
    [super dealloc];
}


@end
