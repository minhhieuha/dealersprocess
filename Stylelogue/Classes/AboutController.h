//
//  AboutController.h
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "TwitterSettings.h"
#import "UIViewExtension.h"
#import "ColorDirective.h"
#import "NSNotificationPoster.h"
#import "UISilentView.h"
#import "TableCellHilightedView.h"
#import "TableCellHilightedView.h"
#import "ViewTerms.h"
#import "ViewTerms1.h"

@interface AboutController : UIViewController {

	UITableView *tableView;
}
@property(nonatomic, retain) UITableView *tableView;

@end
