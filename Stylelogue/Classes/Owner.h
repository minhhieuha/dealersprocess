//
//  Owner.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>


@interface Owner : NSObject {
	
	NSString* fb_user_id;
    int user_id;
	BOOL like_item;
	NSString *name;
}

@property(nonatomic, retain) NSString *name;
@property(readwrite) BOOL like_item;
@property(nonatomic, retain) NSString* fb_user_id;
@property(readwrite) int user_id;

@end
