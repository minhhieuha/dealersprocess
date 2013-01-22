//
//  GiveOpinionControllerRecent.h
//  Stylelogue
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
//#import "FBRequest.h"


@interface GiveopinionController : UIViewController< DidGetFacebookName,UITextViewDelegate,EGORefreshTableHeaderDelegate,UITableViewDataSource, UITableViewDelegate,IconDownloaderDelegate, ParsingFinishDelegate, UIScrollViewDelegate> {
	
	UITableView *tableView;

	NSMutableArray *entries;
	APIController *api;
	
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
	int currentPage;
	Item *it;
	
	UIImageView *backgroundImage;
	UIImage *selectedImage;
	UIView *textFieldRoundedWrapper;
	UITextView *textFieldForAddionalNotes;
	UIImageView *backGround;
	NSMutableDictionary *names;
	
	BOOL displayMoreStyles;
	NSMutableDictionary *imageDownloadsInProgress;
	
}

@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic, retain) 	NSMutableDictionary *names;
@property(nonatomic, retain) 	UIImageView *backGround;
@property(nonatomic, retain) 	UIView *textFieldRoundedWrapper;
@property(nonatomic, retain) 	UITextView *textFieldForAddionalNotes;

@property(nonatomic, retain) 	UIImage *selectedImage;
@property(nonatomic, retain) 	UIImageView *backgroundImage;


@property (nonatomic, retain) 	Item *it;
@property(readwrite) 	int currentPage;
@property(nonatomic, retain) 	APIController *api;
@property(nonatomic, retain) 	UITableView *tableView;
@property(nonatomic, retain) 	NSMutableArray *entries;

@property(nonatomic, retain) 	EGORefreshTableHeaderView *_refreshHeaderView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)loadImagesForOnscreenRows;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)backFunction;
-(void)cancelDownloading;

@end
