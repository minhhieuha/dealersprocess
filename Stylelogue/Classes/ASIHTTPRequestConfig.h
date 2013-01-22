//
//  ASIHTTPRequestConfig.h
//  Part of ASIHTTPRequest -> te
//
//  Created by Ben Copsey on 14/12/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//


// ======
// NSLog output configuration options
// ======

// When set to 1 ASIHTTPRequests will print information about what a request is doing
#ifndef NSLog_REQUEST_STATUS
	#define NSLog_REQUEST_STATUS 0
#endif

// When set to 1, ASIFormDataRequests will print information about the request body to the console
#ifndef NSLog_FORM_DATA_REQUEST
	#define NSLog_FORM_DATA_REQUEST 0
#endif

// When set to 1, ASIHTTPRequests will print information about bandwidth throttling to the console
#ifndef NSLog_THROTTLING
	#define NSLog_THROTTLING 0
#endif

// When set to 1, ASIHTTPRequests will print information about persistent connections to the console
#ifndef NSLog_PERSISTENT_CONNECTIONS
	#define NSLog_PERSISTENT_CONNECTIONS 0
#endif
