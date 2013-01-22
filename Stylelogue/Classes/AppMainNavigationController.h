//
//  AppMainNavigationController.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>
#import "UANavigationBarRedraw.h"
//#import "SHKFacebook.h"
#import "APIController.h"



@protocol DidGetFacebookName

-(void)didGetFacebookName:(NSArray*)array;
-(void)failedToGetFacebookName;

@end



@interface AppMainNavigationController : UINavigationController {
	
	NSString *userID;
	NSMutableArray *questions;
//	SHKFacebook *facebook;
//	FBSession *session;
	id<DidGetFacebookName> delegate;
	int goFrom;
	NSString *facebookName;
	NSString *deviceToken;
}

@property(nonatomic, copy)  NSString* deviceToken;
//@property(nonatomic, retain) 	FBSession *session;
@property(nonatomic, retain) 	NSString *facebookName;
@property(readwrite) 	int goFrom;
@property(nonatomic, assign) 	id<DidGetFacebookName> delegate;
//@property(nonatomic, retain) 	SHKFacebook *facebook;
@property(nonatomic, copy) 	NSString *userID;
@property(nonatomic, copy)	NSString *userName;
@property(nonatomic, retain) 	NSMutableArray *questions;

@end
