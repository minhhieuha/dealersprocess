//
//  Opinion.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>
#import "Owner.h"

//{"opinion":
//	{"id":"2",
//		"content":"Hello hello hello ",
//		"posted_at":"29 Dec, 2010",
//		"owner":
//		{
//			"fb_user_id":"123456789101112",
//			"user_id":"7",
//			"like_item":"false"
//		}
//	}
//}

@interface Opinion : NSObject {
	
	int ID;
	NSString *content;
	NSString *posted_at;
	Owner *owner;
}

@property(readwrite) int ID;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *posted_at;
@property(nonatomic, retain) Owner *owner;

@end
