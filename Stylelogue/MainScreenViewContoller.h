
#import <UIKit/UIKit.h>
#import "StylelogueAppDelegate.h"
#import "GiveOpinionControllerRecent.h"
#import "MyLooksbookController.h"
#import "GoodyController.h"

#import "TableCellHilightedView.h"
#import "TableViewCellBackGroundView.h"
#import "FontLabel.h"
#import "SignUpController.h"
#import "LoginController.h"

@interface MainScreenViewContoller : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ParsingFinishDelegate> {
    
	UITableView *tableView;
    UIView *loginToolBar;
}

@property(nonatomic, retain)     UIView *loginToolBar;
@property (nonatomic, retain) UITableView *tableView ;
@end
