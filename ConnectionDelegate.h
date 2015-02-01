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
    NSString* _ipString;
}

@property (nonatomic, strong) NSURLConnection* _theConnection;
@property (nonatomic, strong) AppDelegate* _callBackObject;
@property (nonatomic, strong) NSMutableData* _receivedData;

- (void) setCallbackObject:(AppDelegate*)callbackObject;
- (void) sendGetIPRequest;

@end
