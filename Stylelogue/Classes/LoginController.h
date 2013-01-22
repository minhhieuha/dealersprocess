
//
//  Created by Nguyen Xuan Quang on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "ViewDetailController.h"
#import "Item.h"
#import "SharePhotoPageController.h"
#import "IconDownloader.h"
#import "GiveOpinionControllerHot.h"
#import "APIController.h"
#import "EGORefreshTableHeaderView.h"
#import "UIViewExtension.h"
#import "ColorDirective.h"
#import "TakePhotoLandingController.h"
#import "MyLooksbookController.h"
#import "TableCellHilightedView.h"
#import "TableViewCellBackGroundView.h"
#import "NewAPI.h"
#import "SaveArrayCustomObject.h"
#import "CompleteRegistration.h"
#import "ForgotPasswordController.h"


@interface LoginController :  UIViewController<UITableViewDataSource, UITableViewDelegate , ParsingFinishDelegate, UIScrollViewDelegate, FBSessionDelegate, FBRequestDelegate> {
    
    UITableView *tableView;
    APIController *api;
    
    BOOL _reloading;
    int currentPage;
    
    BOOL displayMoreStyles;
    UITextField *email;
    UITextField *password;
    UIImage *image;
    APIController *newAPI;
}

@property(nonatomic, retain)     APIController *newAPI;
@property(nonatomic, retain) 	UITextField *email;
@property(nonatomic, retain) 	UITextField *password;
@property(nonatomic, retain) 	UIImage *image;

@property(readwrite) int    currentPage;
@property(nonatomic, retain) 	APIController *api;
@property(nonatomic, retain) 	UITableView *tableView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)loadImagesForOnscreenRows;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)backFunction;
- (void)cancelDownloading;

@end

