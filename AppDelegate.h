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

- (void)toAwait;

/// callback once IP has been retrieved
- (void)updateIP;

/// For exiting the app
- (void)processExit:(id)sender;

/// For rereshing the display of the IP
//- (void)processRefresh:(id)sender;

/// Brings an 'about' dialog to front
- (void)frontAbout:(id)sender;

@end

