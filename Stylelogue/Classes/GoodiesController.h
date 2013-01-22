//
//  GoodiesController.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>
#import "Goody.h"
#import "FontLabel.h"
#import "APIController.h"
#import "AppMainNavigationController.h"
#import "SharePhotoPageController.h"

@interface GoodiesController : UIViewController {
	
	Goody *goodies;
	UIWebView *opinionsView;
	APIController *api;
	UIButton *addToLookbook;
	UILabel *addText;
	UILabel *shareLabel;
	UIButton *shareButton;
    UIView *loginToolbar;
}

@property(nonatomic, retain)  UIView *loginToolbar;

@property(nonatomic, retain) 	UILabel *shareLabel;
@property(nonatomic, retain) 	UIButton *shareButton;
@property(nonatomic, retain) 	UILabel *addText;
@property(nonatomic, retain) 	UIButton *addToLookbook;
@property(nonatomic, retain) 	APIController *api;
@property(nonatomic, retain) 	Goody *goodies;
@property(nonatomic, retain) 	UIWebView *opinionsView;
@end
