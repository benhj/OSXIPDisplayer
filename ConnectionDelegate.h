//
//  ConnectionDelegate.h
//  OSXIPDisplayer
//
//  Created by Ben Jones on 1/27/15.
//  Copyright (c) 2015 Ben Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;

@interface ConnectionDelegate : NSObject<NSURLConnectionDelegate> {
    NSURLConnection *_theConnection;
    NSMutableData* _receivedData;
    NSString* _ipString;
    AppDelegate* _callBackObject;
}

- (void) setCallbackObject:(AppDelegate*)callbackObject;
- (void) sendGetIPRequest;
- (NSString*) getIPString;

@end
