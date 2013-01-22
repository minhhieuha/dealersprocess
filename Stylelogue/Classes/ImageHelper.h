//
//  ImageHelper.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>


@interface ImageHelper : NSObject {

}

+(NSString *)getStringFromImage:(UIImage *)image;
+(UIImage *)getImageFromString:(NSString*)beforeStringImage;
@end
