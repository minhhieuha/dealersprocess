//
//  NSString+Formatter.h
//
//
// on 8/4/10.
// Rubify. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(Formatter)
- (NSString *)decimalString;
- (NSString *)decimalWithUnitString;
- (NSString *)twoPointDecimalString;
- (NSString *)noDecimalCommaString;
@end
