//
//  ViewDetailController.h
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
#import "EasyTableView.h"
#import "GradientView.h"
#import "UIViewWrapper.h"
#import "UIButtonExtension.h"
#import "UILabelAutoAdjustHeight.h"
#import "GiveopinionController.h"
#import "ColorDirective.h"
#import "ViewLog.h"
//#import "StylelogueAppDelegate.h"

@interface ViewDetailController : UIViewController<EasyTableViewDelegate, UIViewExtendDelegate, IconDownloaderDelegate, UIScrollViewDelegate> {
	
	NSMutableArray* entries;
	EasyTableView *horizontalView;
	UIButton *opinionButton;
	UIButton *removeButton;
	UIButton *likeButton;
	NSMutableDictionary *imageDownloadsInProgress;
	APIController *api;
	int index;
	
	UIViewWrapper *fullScreenView;
	UIImageViewExtension *fullScreenImage;
	UIView *backGround;
	BOOL lock;
	CGRect r;
	UILabel *addLabel;
	UILabel *removeLabel;	
	UILabel *likeLabel;
	BOOL allowLock;
    UIView *loginToolbar;
}

@property(nonatomic, retain)  UIView *loginToolbar;

@property(readwrite) BOOL allowLock;
@property(nonatomic, retain) UILabel *addLabel;
@property(nonatomic, retain) UILabel *removeLabel;	
@property(nonatomic, retain) UILabel *likeLabel;

@property(readwrite) 	CGRect r;
@property(readwrite) 	BOOL lock;
@property(nonatomic, retain) UIView *backGround;
@property (nonatomic, retain) UIViewWrapper *fullScreenView;
@property (nonatomic, retain) UIImageViewExtension *fullScreenImage;

@property(readwrite) 	int index;
@property(nonatomic, retain)    APIController *api;
@property(nonatomic, retain)    NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic, retain) 	EasyTableView *horizontalView;
@property(nonatomic, retain) 	NSMutableArray* entries;

@property(nonatomic, retain) UIButton *opinionButton;
@property(nonatomic, retain) UIButton *removeButton;
@property(nonatomic, retain) UIButton *likeButton;


-(IBAction)readButtonClicked:(id)sender;
-(IBAction)removeButtonClicked:(id)sender;
-(IBAction)likeButtonClicked:(id)sender;
- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath;
-(void)gotoSharePage;
-(void)cancelDownloading;

@end
