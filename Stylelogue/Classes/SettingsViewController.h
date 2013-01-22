//
//  SettingsViewController.h
//  Stylelogue
//

#import <UIKit/UIKit.h>
#import "StylelogueAppDelegate.h"
//#import "FBSession.h"
//#import "Facebook.h"
#import "TwitterSettings.h"
#import "UIViewExtension.h"
#import "ColorDirective.h"
#import "FontLabel.h"
#import "NSNotificationPoster.h"
#import "UISilentView.h"
#import "TableCellHilightedView.h"
#import "TableCellHilightedView.h"
#import "AboutController.h"

@interface SettingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	
	UITableView *tableView;
//	FBSession *fbsession;
	UISwitch *autoLogin;
	BOOL on;
	UILabel *changeText;

}


@property(nonatomic, retain) UILabel *changeText;
@property(nonatomic, retain) UITableView *tableView;
//@property(nonatomic, retain) FBSession *fbsession;
@property(nonatomic, retain) UISwitch *autoLogin;
@property(readwrite) BOOL on;

@end
