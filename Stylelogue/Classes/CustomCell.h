//
//  StateTableCellView.h
//  States
//
//  Created by Julio Barros on 1/26/09.
//  Copyright 2009 E-String Technologies, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawLine.h"
#import "UIViewExtension.h"
#import "ColorDirective.h"
#import "FontLabel.h"


@interface CustomCell : UITableViewCell {
	IBOutlet UILabel *stateLabel;
	IBOutlet UILabel *capitalLabel;
	IBOutlet UILabel *rate;
	IBOutlet UIImageView *img;
	IBOutlet DrawLine *lineColor;	
	float width;
	IBOutlet FontLabel *viewDetail;
}

@property(nonatomic, retain) IBOutlet FontLabel *viewDetail;
@property (nonatomic,retain) IBOutlet UILabel *stateLabel;
@property (nonatomic,retain) IBOutlet UILabel *capitalLabel;

@property (nonatomic,retain) IBOutlet UILabel *rate;
@property (nonatomic,retain) IBOutlet UIImageView *img;
@property (nonatomic,retain) IBOutlet DrawLine *lineColor;

@end
