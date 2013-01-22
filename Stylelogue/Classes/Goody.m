//
//  Goody.m
//  Stylelogue
//


//

#import "Goody.h"


@implementation Goody

@synthesize title;
@synthesize photo_url;
@synthesize GID;
@synthesize _description;

-(NSString*)description
{
    return [NSString stringWithFormat:@"photo: %@, cropped: %@", self.photo, self.cropped_photo];
}

-(void)dealloc
{
	[title release];
	[photo_url release];	
	[_description release];
	[super dealloc];
}

@end
