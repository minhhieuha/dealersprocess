//
//  Question.m
//  Stylelogue
//


//

#import "Question.h"


@implementation Question


@synthesize additional_note;
@synthesize content;
@synthesize qID;
@synthesize number_of_opinions;

-(void)dealloc
{
	
	[additional_note release];
	[content release];	
	
	[super dealloc];
}
@end
