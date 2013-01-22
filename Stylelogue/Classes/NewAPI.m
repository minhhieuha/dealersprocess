//
//  NewAPI.m
//  Stylelogue
//
//  Created by Quang Nguyen on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewAPI.h"

#pragma mark  Config Server
static NSString *UAServer = @"https://go.urbanairship.com";
#define SINGAPORE_SERVER //using project server
//#define LOCAL_SERVER

#ifdef LOCAL_SERVER
static NSString * originURL = @"http://stylelogue85.com";
#else
static NSString * originURL = @"http://stylelogue.it";
#endif
static NSString * apiKey = @"3c1a9614b932788598319be14abdf05eb0b46a6";

#define kslCreateNornalUser 1
#define kslLoginNormalUser 2
#define kslCreateFacebookUser 3
#define kcreateUser 4
#define  kslCompleteRegistration 5
#define kslLinkAccount 6

@implementation NewAPI

@synthesize delegate;
@synthesize  request, task;

-(void)dealloc
{
    [request clearDelegatesAndCancel];
    [request release];    
    [super dealloc];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (task == kslCreateNornalUser) {       
        XQDebug(@"\nResult: %@\n", [request responseString]);   
       
        [self parseUserInfo:[request responseString]];
    }else
        if (task == kslLoginNormalUser) {
            XQDebug(@"\nResult: %@\n", [request responseString]); 
            [self parseUserInfo:[request responseString]];
        }else
            if (task == kslCreateFacebookUser) {
                
                [self parseUserInfo:[request responseString]];
            }else if(task == kcreateUser)
            {
                XQDebug(@"\n======>>>>>>>----->>>>Crate facebook user response: %@\n", [request responseString]);
                SBJSON *parser = [[SBJSON alloc] init];  
                NSDictionary *dic = (NSDictionary *) [parser objectWithString: [request responseString] error:nil];
                if (delegate) {
                    [delegate checkToFacebookIsDone:dic];
                }
                [parser release];
            }else if(task == kslCompleteRegistration)
            {
                 XQDebug(@"\n======>>>Crate facebook user response: %@\n", [request responseString]);
                [self parseCompleteRegistration:[request responseString]];
            }else if(task == kslLinkAccount)
            {
                XQDebug(@"\n======>>>Crate facebook user response: %@\n", [request responseString]);
                [self parseLinkData:[request responseString]];
            }
}




-(void)requestFailed:(ASIHTTPRequest *)request
{
    XQDebug(@"\nFalse: %@\n", [request error]);
}

//
//24 - Link facebook account with norml account
//URL: POST
///users/iphone_link_account.json?json={"user":{"password":"password","fb_authentication_token":"1234567890","normal_authentication_token": "123456795"}}
//
//Successful: {"result":"successful", "message": "message", "user":{"user_id":"user_id","authentication_token":"authentication_token","email":"email","avatar":"avatar_url","name":"name"}}
//Failed: {"result":"failed","reason":"reason"}
//

static NSString *iphone_link_accountURL = @"/users/iphone_link_account.json?";
static NSString *iphone_link_accountFormat = @"{\"user\":{\"password\":\"%@\",\"fb_authentication_token\":\"%@\",\"normal_authentication_token\": \"%@\"}}";

-(void)slLinkAccount:(NSString*)password andFBAuthen:(NSString*)fbauthen andNormalAuthen:(NSString*)normalAuthen
{
    self.task = kslLinkAccount;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, iphone_link_accountURL]];
	self.request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:iphone_link_accountFormat, password, fbauthen, normalAuthen] forKey:@"json"];
    XQDebug(@"\njson: %@\n",  [NSString stringWithFormat:iphone_link_accountFormat, password, fbauthen, normalAuthen]);
	[request setDelegate:self];
	[request startAsynchronous];
}

//23 - Complete Registration after logging using facebook - if with_existing_account is set to be "false"
//URL: POST
///users/iphone_fb_afterwards_setup.json?json={"user":{"name":"James Huynh","authentication_token":"1234567890","email":"james@rubify.com","password":"password", "get_update_from_stylelogue":"true"}}
//
//Successful: {"result":"successful", "user":{"user_id":"user_id","authentication_token":"authentication_token","email":"email","avatar":"avatar_url","name":"name"}}
//Existing Email Detected:  {"result":"Existing email detected", "user":{"user_id":"user_id","authentication_token":"authentication_token","email":"email","avatar":"avatar_url","name":"name"}}
//Failed: {"result":"failed","reason":"reason"}

static NSString *iphone_fb_afterwards_setupURL  = @"/users/iphone_fb_afterwards_setup.json?";
static NSString *iphone_fb_afterwards_setupFormat = @"{\"user\":{\"name\":\"%@\",\"authentication_token\":\"%@\",\"email\":\"%@\",\"password\":\"%@\", \"get_update_from_stylelogue\":\"%@\"}}";
-(void)slCompleteRegistration:(NSString*)name andAuthenToken:(NSString*)authen andEmail:(NSString*)email andPassword:(NSString*)password andUpdate:(BOOL)update
{
    self.task = kslCompleteRegistration;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, iphone_fb_afterwards_setupURL]];
	self.request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:iphone_fb_afterwards_setupFormat, name, authen, email, password, update?@"true":@"false"] forKey:@"json"];
    XQDebug(@"\njson: %@\n",  [NSString stringWithFormat:iphone_fb_afterwards_setupFormat, name, authen, email, password, update?@"true":@"false"]);
	[request setDelegate:self];
	[request startAsynchronous];
}


//
//1 - Create User (with_existing_account can be "true" or "false")
//
//URL: POST /users/iphone_create.json?json={"user":{"fb_user_id":"fb_user_id","name":"fb_user_name","current_city":"current_city","iphone_uuid":"60 characters uuid","get_update_from_stylelogue":"true"}}
//
//Successful: {"result":"successful","user_id":"user_id","authentication_token":"authentication_token","email":"email","avatar":"avatar_url","name":"name","with_existing_account":"true"}
//Failed: {"result":"failed","reason":"reason"}
//

static NSString* createUserFunction1 = @"/users/iphone_create.json?";
static NSString* createUserValueFormat1 = @"{\"user\":{\"fb_user_id\":\"%@\",\"name\":\"%@\",\"current_city\":\"%@\",\"iphone_uuid\":\"%@\",\"get_update_from_stylelogue\":\"%@\"}}";

-(void)slcreateUser:(NSString*) fbUserID andName:(NSString*)name andCity:(NSString*)city andDeviceToken:(NSString*)DeviceToken andUpdateFromStylelogue:(BOOL)update
{
	self.task = kcreateUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, createUserFunction1]];
	self.request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:createUserValueFormat1, fbUserID, name, city, DeviceToken, update?@"true":@"false"] forKey:@"json"];
    XQDebug(@"\njson: %@\n", [NSString stringWithFormat:createUserValueFormat1, fbUserID, name, city, DeviceToken, update?@"true":@"false"] );
	[request setDelegate:self];
	[request startAsynchronous];
}

//20 - Create normal user (Tested)
//URL: POST /users/iphone_normal_create.json?json={"email":"james@rubify.com","name":"Dang Khoa","password":"123456"}&avatar=<avatar>
static NSString *createUserURL = @"/users/iphone_normal_create.json?";
static NSString *createUserValueFormat = @"{\"user\":{\"email\":\"%@\",\"name\":\"%@\",\"password\":\"%@\", \"iphone_uuid\":\"%@\", \"get_update_from_stylelogue\":\"%@\"}}";
-(void)slCreateNormalUser:(NSString*)email andName:(NSString*)name andPassword:(NSString*)password andAvatar:(UIImage*)avatar andDeviceToken:(NSString*)deviceToken andUpdateFromStylelogue:(BOOL)update
{   
    task = kslCreateNornalUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, createUserURL]];
	self.request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat: createUserValueFormat,email, name, password, deviceToken, update?@"true":@"false"] forKey:@"json"];
    XQDebug(@"\n=====>>>>>Value: %@\n", [NSString stringWithFormat: createUserValueFormat,email, name, password, deviceToken, update?@"true":@"false"]);
    if (avatar) {
        
     	CGFloat compression = 0.9f;
        NSData *data = UIImageJPEGRepresentation(avatar, compression);
        [request addData:data forKey:@"avatar"];
    }
    [request setDelegate:self];    
	[request startAsynchronous];
}

//22 - IPhone Normal Login (Tested)
//
//URL: POST
///users/iphone_normal_login.json?json={"email":"email","password":"password"}
static NSString *loginUserURL = @"/users/iphone_normal_login.json?";
static NSString *loginUserValueFormat = @"{\"email\":\"%@\",\"password\":\"%@\", \"iphone_uuid\":\"%@\"}";
-(void)slLoginNormalUser:(NSString*)email andPassword:(NSString*)password andDeviceToken:(NSString*)deviceToken
{   
    task = kslLoginNormalUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, loginUserURL]];
	self.request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat: loginUserValueFormat,email, password, deviceToken] forKey:@"json"];
    [request setDelegate:self];    
	[request startAsynchronous];
}

//21 - User Linkup with Facebook (Tested)
//
//URL: POST /users/iphone_link_up_with_facebook.json?json={"user":{"fb_user_id":"fb_user_id","current_city":"current_city"},"authentication_token":"authentication_token"}&avatar=<avatar>

static NSString *createFBUserURL = @"/users/iphone_link_up_with_facebook.json?";
static NSString *createUserFBValueFormat = @"{\"user\":{\"fb_user_id\":\"%@\",\"current_city\":\"%@\"}, \"iphone_uuid\":\"%@\"}";
-(void)slCreateFacebookUser:(NSString*)fbUserID andCurrentCity:(NSString*)current_city andDeviceToken:(NSString*)deviceToken
{   
    task = kslCreateFacebookUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, createFBUserURL]];
	self.request = [ASIFormDataRequest requestWithURL:url];
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat: createUserFBValueFormat,fbUserID,  current_city, deviceToken] forKey:@"json"];
    [request setDelegate:self];    
	[request startAsynchronous];
}

#pragma Parsing Functions

-(void) parseUserInfo:(NSString*)data
{
    XQDebug(@"\nitem for edit: %@\n", data);
    SBJSON *parser = [[SBJSON alloc] init];  
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];
    
    NSString *result = [dic objectForKey:@"result"];
    if ([result isEqualToString:@"failed"]) {
        if (delegate) {
            
            [delegate newUserHaveExisted: [dic objectForKey:@"reason"]];
        }
    }else
    {
        UserData *user = [[UserData alloc] init];
        user.name = [dic objectForKey:@"name"];
        user.avatar_url = [dic objectForKey:@"avatar_url"];
        user.authentication_token = [dic objectForKey:@"authentication_token"];
        user.email = [dic objectForKey:@"email"];
        user.user_id = [[dic objectForKey:@"user_id"] intValue];
        XQDebug(@"\nuser info: %@\n", user);
        
        if (delegate) {
            [delegate newDidLogin:user];
        }
        [user release];
    }
    [parser release];
}


-(void)parseCompleteRegistration:(NSString*)data
{
    XQDebug(@"\nitem for edit: %@\n", data);
    SBJSON *parser = [[SBJSON alloc] init];  
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];
    
    NSString *result = [dic objectForKey:@"result"];
    if ([result isEqualToString:@"failed"]) {
        if (delegate) {
            
            [delegate newUserFailed: [dic objectForKey:@"reason"]];
        }
    }else if([result isEqualToString:@"Existing email detected"])
    {
//      {"result":"Existing email detected", "user":{"user_id":"user_id","authentication_token":"authentication_token","email":"email","avatar":"avatar_url","name":"name"}}        
        dic = [dic objectForKey:@"user"];
        UserData *user = [[UserData alloc] init];
        user.name = [dic objectForKey:@"name"];
        user.avatar_url = [dic objectForKey:@"avatar_url"];
        user.authentication_token = [dic objectForKey:@"authentication_token"];
        user.email = [dic objectForKey:@"email"];
        user.user_id = [[dic objectForKey:@"user_id"] intValue];
        XQDebug(@"\nuser info: %@\n", user);
        
        if (delegate) {
            [delegate newUserHaveExisted2: user];
        }
        [user release];
    }
    else if([result isEqualToString:@"successful"])
    {
        dic = [dic objectForKey:@"user"];
        //"user":{"user_id":"user_id","authentication_token":"authentication_token","email":"email","avatar":"avatar_url","name":"name"}
        UserData *user = [[UserData alloc] init];
        user.name = [dic objectForKey:@"name"];
        user.avatar_url = [dic objectForKey:@"avatar_url"];
        user.authentication_token = [dic objectForKey:@"authentication_token"];
        user.email = [dic objectForKey:@"email"];
        user.user_id = [[dic objectForKey:@"user_id"] intValue];
        XQDebug(@"\nuser info: %@\n", user);
        
        if (delegate) {
            [delegate newDidLogin:user];
        }
        [user release];
    }
    [parser release];
}

-(void)parseLinkData:(NSString*)data
{
    
    XQDebug(@"\nitem for edit: %@\n", data);
    SBJSON *parser = [[SBJSON alloc] init];  
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];
    
    NSString *result = [dic objectForKey:@"result"];
    if ([result isEqualToString:@"failed"]) {
        if (delegate) {
            
            [delegate newUserFailed: [dic objectForKey:@"reason"]];
        }
    }else if([result isEqualToString:@"successful"])
    {
        NSString *mess = [dic objectForKey:@"message"];
        dic = [dic objectForKey:@"user"];
        UserData *user = [[UserData alloc] init];
        user.name = [dic objectForKey:@"name"];
        user.avatar_url = [dic objectForKey:@"avatar_url"];
        user.authentication_token = [dic objectForKey:@"authentication_token"];
        user.email = [dic objectForKey:@"email"];
        user.user_id = [[dic objectForKey:@"user_id"] intValue];
        XQDebug(@"\nuser info: %@\n", user);
        
        if (delegate) {
            
            [delegate newDidLogin:user andMessage: mess];
        }
        
        [user release];
    }
    [parser release];
}

@end
