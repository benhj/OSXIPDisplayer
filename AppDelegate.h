//
//  AppDelegate.h
//  OSXIPDisplayer
//
//  Created by Ben Jones on 1/27/15.
//  Copyright (c) 2015 Ben Jones. All rights reserved.
//

#import "ConnectionDelegate.h"
#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    NSStatusItem* _statusItem;
    ConnectionDelegate* _connectionDelegate;
    
}

/// callback once IP has been retrieved
- (void)updateIP;

/// update the IP every 60 seconds
- (void)ipUpdater;

/// For exiting the app
- (void)processExit:(id)sender;

@end

