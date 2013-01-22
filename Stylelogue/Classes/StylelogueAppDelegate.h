//
//  StylelogueAppDelegate.h
//  Stylelogue
//
//  Created by Freddy Wang on 12/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMainNavigationController.h"
#import "MainScreenViewContoller.h"
#import "SettingsViewController.h"
#import "StylelogueViewController.h"
#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "ImageHelper.h"
#import "Item.h"
#import "Owner.h"
#import "Question.h"
#import "Opinion.h"
#import "Goody.h"
#import "SHKActivityIndicator.h"
#import <CoreLocation/CoreLocation.h>
#import "ViewLikedCommentedItems.h"
#import "FacebookInfo.h"
#import "SaveArrayCustomObject.h"
#import "UserData.h"
#import "LinkAccountController.h"

@class LoginViewController;
@class MainScreenViewContoller;
@interface StylelogueAppDelegate : NSObject < FBDialogDelegate,UIApplicationDelegate, ASIHTTPRequestDelegate, ParsingFinishDelegate, CLLocationManagerDelegate, FBRequestDelegate>{
    
	UIWindow *window;
    StylelogueViewController *viewController;
	AppMainNavigationController *mainNavController;
	APIController *api;
	
	NSString *deviceToken;
	NSString *deviceAlias;
	CLLocationManager *locationManager;
	double latitude;
	double longitude;
	id<CLLocationManagerDelegate> delegate;
	BOOL didEnterToBackground;
	Facebook *facebook;
	
	FacebookInfo *fbuserinfo;
	BOOL uploading;
    UserData *user;
    MainScreenViewContoller *mainMenu;
    LoginViewController *loginController;
}

@property(nonatomic, retain)     LoginViewController *loginController;
@property(nonatomic, retain)  MainScreenViewContoller *mainMenu;
@property(nonatomic, retain)  UserData *user;
@property(nonatomic, retain ) FacebookInfo *fbuserinfo;
@property(nonatomic, retain) Facebook *facebook;
@property(nonatomic, assign) 	id<CLLocationManagerDelegate> delegate;
@property(readwrite) double latitude;
@property(readwrite) double longitude;
@property(nonatomic, retain) 	CLLocationManager *locationManager;
@property(nonatomic, retain) NSString *deviceToken;
@property(nonatomic, retain) NSString *deviceAlias;
@property(nonatomic, assign) APIController *api;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StylelogueViewController *viewController;
@property (nonatomic, retain) AppMainNavigationController *mainNavController;

-(void)cancelDownLoad;
-(void)getDataFromWebService:(int)num pageNum:(int)page which:(int)which;
-(void)createItem:(id<ASIHTTPRequestDelegate>)delegate user:(NSString*)userID thumbnail:(NSString*)thumbnailImage originImage:(NSString*)image longitude:(float)lo latitude:(float)la question:(NSString*)q additionalNote:(NSString*)note;
-(void)createUser;
- (NSString *)urlEncodeValue:(NSString *)str;

-(void)listRecentItemOfCurrentUser:(NSString*)userID numberItemPerpage:(int)num pageNum:(int)page;
-(void)listHostItemOfCurrentUser:(NSString*)userID numberItemPerpage:(int)num pageNum:(int)page;
-(void)listItemOfLooksbook:(NSString*)userID numberItemPerpage:(int)num pageNum:(int)page;
-(void)addOpinionForItem:(int)item questionID:(int)questionID content:(NSString*)content;
-(void)listOpinionsOfQuestion:(int)questionID numberOpinionsPerpage:(int)num pageNum:(int)page delegate:(id<ASIHTTPRequestDelegate>)delegate;
-(void)addOpinionForItem:(int)item questionID:(int)questionID content:(NSString*)content delegate:(id<ASIHTTPRequestDelegate>)delegate; 
-(void)listGoodies:(int)questionID numberOpinionsPerpage:(int)num pageNum:(int)page delegate:(id<ASIHTTPRequestDelegate>)delegate;

-(NSMutableArray*)parseItems:(NSString*)data;
-(NSMutableArray*)parseQuestions:(NSString*)data;
-(NSMutableArray*)parseOpinions:(NSString*)data;
-(NSMutableArray*)parseGoodies:(NSString*)data;


-(void)deleteItems:(NSString*)items;
-(void)likeItem:(int)item;
-(void)unlikeItem:(int)item;
-(void)likeGoody;
-(void)unlikeGoody;
-(void)addToLookbook:(int)item;
-(void)removeFromLookbook:(int)item;
-(void)listQuestion:(int)num page:(int)page;

-(void)uploadPhotoToServerInBackground:(UIImage*)thumnail originImage:(UIImage*)origin question:(NSString*)question additionalNote:(NSString*)additionalNote;

-(void)popViewsToSelectImage;
-(void)popViewsToLogin;
-(void)popToMainMenu;
- (void)uploadPhoto:(NSString*)img comment:(NSString*)comment description:(NSString*)description;
+(NSString*)base64forData:(NSData*)theData;
-(void)loadUserInfo;
-(void)saveUserInfo:(UserData*)info;

@end

