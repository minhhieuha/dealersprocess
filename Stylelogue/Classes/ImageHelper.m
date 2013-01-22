//
//  ImageHelper.m
//  Stylelogue
//


//

#import "ImageHelper.h"


@implementation ImageHelper

	+(NSString *)getStringFromImage:(UIImage *)image{
		if(image){
			NSData *dataObj = UIImagePNGRepresentation(image);
			return [dataObj base64Encoding];
		} else {
			return @"";
		}
	}

	+(UIImage *)getImageFromString:(NSString*)beforeStringImage{
		
		NSData *dataObj = [NSData dataWithBase64EncodedString:beforeStringImage];
		UIImage *beforeImage = [UIImage imageWithData:dataObj];
		return beforeImage;
	}

@end
