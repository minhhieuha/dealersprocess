//
//  FontLabelExtension.h
//  Stylelogue
//
//  Created by Freddy Wang on 12/29/10.

//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "ZFont.h"
#import "ZAttributedString.h"
#import "FontManager.h"
#import "ColorDirective.h"

@interface FontLabel(LabelExtension)

+(FontLabel *)titleLabelNamed:(NSString *)string;

+(FontLabel*)makeFontLabel:(NSString*) mess1 mess2:(NSString*)mess2;

@end
