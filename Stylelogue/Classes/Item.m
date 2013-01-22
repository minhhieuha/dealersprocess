#import "Item.h"

@implementation Item

@synthesize flag;
@synthesize photo;
@synthesize itemID;
@synthesize number_of_likes;
@synthesize owner;
@synthesize created_at;
@synthesize latitude;
@synthesize current_user_like;
@synthesize longitude;
@synthesize question;
@synthesize cropped_photo;
@synthesize icon;
@synthesize originPhoto;
@synthesize index;
@synthesize current_user_lookbook;
@synthesize loading_photo;
@synthesize type;
@synthesize originImageHaveLoaded;
@synthesize number_of_added_to_lookbook;
@synthesize author_fb_user_id;
@synthesize message;
@synthesize give_opinion_url;


-(void)dealloc
{
	[photo release];	
	[owner release];
	[created_at release];
	[question release];
	[cropped_photo release];	
	[icon release];
	[originPhoto release];
	[loading_photo release];
	[type release];
	[author_fb_user_id release];
	[message release];
	[give_opinion_url release];
	
	[super dealloc];
}
@end
