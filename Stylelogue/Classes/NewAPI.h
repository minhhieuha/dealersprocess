//
//  NewAPI.h
//  Stylelogue
//
//  Created by Quang Nguyen on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Goody.h"
#import "Opinion.h"
#import "Owner.h"
#import "UISilentView.h"
#import "UserData.h"

@protocol NewParsingFinishDelegate

-(void)newDidFinishParsing:(NSMutableArray*)parsedData;
-(void)newDidPostOpinion;
-(void)newDidLogin:(UserData*)info;
-(void)newDidLogin:(UserData*)info andMessage:(NSString*)mess;
-(void)newUserHaveExisted:(NSString * )mess;
-(void)newUserHaveExisted2:(UserData * )info;
-(void)newUserFailed:(NSString * )mess;
-(void)checkToFacebookIsDone:(NSDictionary*)dic;
@end

@interface NewAPI : NSObject<ASIHTTPRequestDelegate, NewParsingFinishDelegate> {
    
    id<NewParsingFinishDelegate> delegate;
	ASIFormDataRequest *request;
    int task;
}

@property(nonatomic, readwrite) int task;
@property(nonatomic, assign) id<NewParsingFinishDelegate> delegate;
@property(nonatomic, retain) ASIFormDataRequest *request;
-(void)slCompleteRegistration:(NSString*)name andAuthenToken:(NSString*)authen andEmail:(NSString*)email andPassword:(NSString*)password andUpdate:(BOOL)update;
-(void)slcreateUser:(NSString*) fbUserID andName:(NSString*)name andCity:(NSString*)city andDeviceToken:(NSString*)DeviceToken andUpdateFromStylelogue:(BOOL)update;
-(void)slCreateNormalUser:(NSString*)email andName:(NSString*)name andPassword:(NSString*)password andAvatar:(UIImage*)avatar andDeviceToken:(NSString*)deviceToken andUpdateFromStylelogue:(BOOL)update;
-(void)slLoginNormalUser:(NSString*)email andPassword:(NSString*)password andDeviceToken:(NSString*)deviceToken;
-(void)slLinkAccount:(NSString*)password andFBAuthen:(NSString*)fbauthen andNormalAuthen:(NSString*)normalAuthen;
@end
