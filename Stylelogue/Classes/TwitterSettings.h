//
//  TwitterSettings.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>
#import "StylelogueAppDelegate.h"
#import "TwitterSettings.h"
#import "FontLabel.h"


@interface TwitterSettings : UIViewController<UITextFieldDelegate> {
	
	UITextField *userName;
	UITextField *passWord;
	UITableView *tableView;
	UISwitch *autoLogin;
	NSString* _userName;
	NSString* _password;
	
	BOOL _authen;
	BOOL _autoLogin;
}

@property(readwrite) BOOL _authen;
@property(readwrite) BOOL _autoLogin;
@property(nonatomic, retain) NSString* _userName;
@property(nonatomic, retain) NSString* _password;
@property(nonatomic, retain) UISwitch *autoLogin;
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UITextField *userName;
@property(nonatomic, retain) UITextField *passWord;
@end
