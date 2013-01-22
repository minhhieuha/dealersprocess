//
//  Item.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "Owner.h"
#import "EasyTableView.h"

@interface Item : NSObject {
	
 	NSString* photo;
	int itemID;
	int number_of_likes;
	Owner *owner;
	float latitude;
	BOOL current_user_like;
	float longitude;
	Question *question;
	NSString *cropped_photo;
	UIImage *icon;
	UIImage *originPhoto;
	int flag;

	int index;
	BOOL current_user_lookbook;
	NSString *loading_photo;
	NSString *type;
	BOOL originImageHaveLoaded;
	int number_of_added_to_lookbook;
	
	NSString *created_at;
	NSString *author_fb_user_id;
	NSString *message;
	NSString *give_opinion_url;
}

@property(nonatomic, retain) 	NSString *give_opinion_url;
@property(nonatomic, retain)  NSString *message;
@property(nonatomic, retain) 	NSString *author_fb_user_id;
@property(nonatomic, retain) 	NSString *created_at;

@property(readwrite) int number_of_added_to_lookbook;
@property(readwrite) BOOL originImageHaveLoaded;
@property(nonatomic, retain) 	NSString *type;
@property(nonatomic, retain) 	NSString *loading_photo;
@property(readwrite) BOOL current_user_lookbook;
@property(readwrite) int index;

@property(readwrite) int flag;
@property(nonatomic, retain) NSString* photo;
@property(readwrite) int itemID;
@property(readwrite) int number_of_likes;
@property(nonatomic, retain) Owner *owner;
@property(readwrite) float latitude;
@property(readwrite) BOOL current_user_like;
@property(readwrite) float longitude;
@property(nonatomic, retain) Question *question;
@property(nonatomic, retain) NSString *cropped_photo;
@property(nonatomic, retain) UIImage *icon;
@property(nonatomic, retain) UIImage *originPhoto;

@end
