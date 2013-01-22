//
//  SaveArrayCustomObject.h
//  Fashnet
//
//  Created by Quang Nguyen on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SaveArrayCustomObject : NSObject {
    
}

+(void)save:(NSMutableArray*)array key:(NSString*)key;
+(NSArray*)load:(NSString*)key;


+(void)saveObject:(id)object key:(NSString*)key;
+(id)loadObject:(NSString*)key;


+(id)loadObjectWithFile:(NSString*)file;
+(void)saveObjectToFile:(id)object file:(NSString*)file;

@end
