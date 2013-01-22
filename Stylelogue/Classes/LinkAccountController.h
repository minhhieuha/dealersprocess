//
//  LinkAccountController.h
//  Stylelogue
//
//  Created by Quang Nguyen on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExtension.h"
#import "StylelogueAppDelegate.h"
#import "UserData.h"
#import "NewAPI.h"
#import "ForgotPasswordController.h"

@interface LinkAccountController : UIViewController<UITextFieldDelegate, NewParsingFinishDelegate, UIAlertViewDelegate> {
 
    
    UITextField *password;
    UserData *user;
    NewAPI *newAPI;
}

@property(nonatomic, retain)     NewAPI *newAPI;
@property(nonatomic, retain)     UserData *user;
@property(nonatomic, retain)     UITextField *password;

- (id)initWithUserData:(UserData*)user;
@end
