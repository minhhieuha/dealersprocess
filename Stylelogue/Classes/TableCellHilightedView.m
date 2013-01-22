//
//  TableCellHilightedView.m
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableCellHilightedView.h"


@implementation TableCellHilightedView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = RGBACOLOR(0x06,0x06,0x06,1);
		UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"images/arrow.new.png"]];

		if (frame.origin.x == -666) {
			[indicator setTop:frame.size.height - indicator.height - 27];			
		}else
		if (frame.origin.x == -111) {
			[indicator setTop:frame.size.height - indicator.height - 1];			
		}else
			if (frame.origin.x == -555) {
				[indicator setTop:frame.size.height - indicator.height - 8];			
			}else
			if (frame.origin.x == -222) {
			
			self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"images/cell.divider.png"]];
			self.alpha = 0.8;
			[indicator setTop:frame.size.height - indicator.height - 5];			
		}
		else {
			[indicator setTop:frame.size.height - indicator.height - 5];
		}
		
		[indicator setLeft:320 - indicator.height - indicator.height/2];
		[self addSubview:indicator];
		[indicator release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
