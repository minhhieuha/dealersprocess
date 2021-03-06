//
//  ViewLikedCommentedItems.h
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 2/10/11.
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
#import "FontLabel.h"
#import "ZFont.h"
#import "ZAttributedString.h"
#import "FontManager.h"
#import "ColorDirective.h"

#import "TableCellHilightedView.h"
#import "TableViewCellBackGroundView.h"

@interface ViewLikedCommentedItems : UIViewController<EGORefreshTableHeaderDelegate,UITableViewDataSource, UITableViewDelegate,IconDownloaderDelegate, ParsingFinishDelegate, UIScrollViewDelegate> {
	
	UITableView *tableView;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *entries;
	APIController *api;
	
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
	int currentPage;
	BOOL displayMoreStyles;
}


@property(readwrite) 	int currentPage;
@property(nonatomic, retain) 	APIController *api;
@property(nonatomic, retain) 	UITableView *tableView;
@property(nonatomic, retain)	NSMutableDictionary *imageDownloadsInProgress;
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
