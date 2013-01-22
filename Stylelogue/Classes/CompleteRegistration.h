
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
#import "LinkAccountController.h"

@interface CompleteRegistration :  UIViewController< UIImagePickerControllerDelegate , UITableViewDataSource, UITableViewDelegate , NewParsingFinishDelegate, UIScrollViewDelegate, UIActionSheetDelegate> {
    
    UITableView *tableView;
    APIController *api;
    
    BOOL _reloading;
    int currentPage;
    
    BOOL displayMoreStyles;
    UITextField *email;
    UITextField *username;
    UITextField *password;
    UIButton *picture;
    UIImage *image;
    UISwitch *sw;
    NewAPI *newAPI;
}

@property(nonatomic, retain)     NewAPI *newAPI;
@property(nonatomic, retain)     UISwitch *sw;
@property(nonatomic, retain) 	UITextField *email;
@property(nonatomic, retain) 	UITextField *username;
@property(nonatomic, retain) 	UITextField *password;
@property(nonatomic, retain) 	UIButton *picture;
@property(nonatomic, retain) 	UIImage *image;

@property(readwrite) int    currentPage;
@property(nonatomic, retain) 	APIController *api;
@property(nonatomic, retain) 	UITableView *tableView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)loadImagesForOnscreenRows;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)backFunction;
-(void)cancelDownloading;

@end

