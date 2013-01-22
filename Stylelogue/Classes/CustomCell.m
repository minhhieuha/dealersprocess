//
//  StateTableCellView.m
//  States
//
//  Created by Julio Barros on 1/26/09.
//  Copyright 2009 E-String Technologies, Inc.. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize stateLabel;
@synthesize capitalLabel;
@synthesize rate;
@synthesize img;
@synthesize lineColor;
@synthesize viewDetail;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		width = 245;	
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	[super willTransitionToState:state];
	
	if (self.tag != 999) {
		if (state & UITableViewCellStateShowingDeleteConfirmationMask) {
			XQDebug(@"\n----->>>>????UITableViewCellStateShowingDeleteConfirmationMask\n");
			self.capitalLabel.width = 155;
			self.stateLabel.width = 155;
			return;
		}
		
		if (state & UITableViewCellStateShowingEditControlMask) {
			XQDebug(@"\n----->>>>????UITableViewCellStateShowingEditControlMask\n");
			self.capitalLabel.width = 200;
			self.stateLabel.width = 200;
			return;
		}
		
		self.capitalLabel.width = 245;
		self.stateLabel.width = 245;
	}else {
		XQDebug(@"\nChange state to delete mode<<<<\n");
		
		if (state & UITableViewCellStateShowingDeleteConfirmationMask) {
			XQDebug(@"\n----->>>>????UITableViewCellStateShowingDeleteConfirmationMask\n");
			self.rate.width = 0;
			self.capitalLabel.width = 160;
			self.stateLabel.width = 240 - 70;
			return;
		}
		
		if (state & UITableViewCellStateShowingEditControlMask) {
			XQDebug(@"\n----->>>>????UITableViewCellStateShowingEditControlMask\n");
			self.rate.width = 60;
			self.stateLabel.width = 240;
			self.capitalLabel.width = 200;
			return;
		}
		
		self.rate.width = 250;
		self.stateLabel.width = 250;
		self.capitalLabel.width = 200;
		
	}
}

- (void)dealloc {
	
	[stateLabel release];
	[capitalLabel release];
	[rate release];
	[img release];
	[lineColor release];
	[viewDetail release];
    [super dealloc];
}
@end
