//
//  Question.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>


@interface Question : NSObject {
   
	NSString* additional_note;
    NSString* content;
    int qID;
	int number_of_opinions;
}
@property(nonatomic, retain) NSString* additional_note;
@property(nonatomic, retain) NSString* content;
@property(readwrite) int qID;
@property(readwrite) int number_of_opinions;
@end
