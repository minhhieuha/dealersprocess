//
//  LoginViewController.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>
//#import "FBConnect.h"
//#import "FBLoginButton.h"
//#import "SHKFacebook.h"
#import "StylelogueAppDelegate.h"
#import "APIController.h"
#import "Question.h"
#import "UILabelAutoAdjustHeight.h"
#import "UIViewExtension.h" 
#import <CoreLocation/CoreLocation.h>
#import "FacebookInfo.h"

@class FontLabel;
@interface LoginViewController : UIViewController<CLLocationManagerDelegate, ParsingFinishDelegate, UITableViewDelegate, UITableViewDataSource, FBSessionDelegate, FBRequestDelegate> {
	
	//SHKFacebook *facebook;
	FontLabel *loginCellTitle;
	unsigned long long FBUserID;
	UITableView *tableView;
	APIController *api;
	UILabel *la;
	UILabel *lo;
}

@property(nonatomic, retain) UILabel *la;
@property(nonatomic, retain) UILabel *lo;
@property(nonatomic, retain) 	APIController *api;
@property(nonatomic, retain) 	UITableView *tableView;
@property(readwrite) 	unsigned long long FBUserID;
//@property(nonatomic, retain) SHKFacebook *facebook;
@property(nonatomic, retain) FontLabel *loginCellTitle;
-(void)viewLoading;

@end
