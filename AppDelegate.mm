//
//  AppDelegate.m
//  OSXIPDisplayer
//
//  Created by Ben Jones on 1/27/15.
//  Copyright (c) 2015 Ben Jones. All rights reserved.
//

#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>


@implementation AppDelegate

@synthesize _statusItem;
@synthesize _cd;


- (BOOL) endsWithCharacter: (unichar) c
                 forString: (NSString*)str
{
    NSUInteger length = [str length];
    return (length > 0) && ([str characterAtIndex: length - 1] == c);
}

- (void)updateIP:(NSString*)ip {
    
    NSString* strippedIP = ip;
    if ([self endsWithCharacter: L'\n'
                        forString: strippedIP]) {
        strippedIP = [strippedIP substringToIndex:[strippedIP length]-1];
    }
    
    _statusItem.title = strippedIP;
}


-(void) handleInterfaceNotification:(NSNotification*) notification {
    [self sendGetIPRequest];
}

- (void)setupReachability:(NSString*)address {
    if(address) {
        
        SCNetworkReachabilityRef target;
        SCNetworkConnectionFlags flags = 0;
        target = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [address UTF8String]);
        
        if(target) {

            
            SCNetworkReachabilityGetFlags(target, &flags);
            SCNetworkReachabilityContext context = {0, NULL, NULL, NULL, NULL};
            context.info = (void*)CFBridgingRetain(self);
            
            // callback triggered whenever reachability has changed
            if (SCNetworkReachabilitySetCallback(target, callback, &context)) {
                if (SCNetworkReachabilityScheduleWithRunLoop(target, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode) ) {
                    NSLog(@"create and config reachability sucess") ;
                }
            }
        } else if (target != NULL) {
            CFRelease(target);
        }
    }
}

// called every time reachability changes
void callback(SCNetworkReachabilityRef target,
              SCNetworkConnectionFlags flags,
              void *info)
{
    auto self = (AppDelegate*)CFBridgingRelease(info);
    
    // check that a connection isn't required. If a connection isn't required,
    // we're probably connected;
    Boolean ok = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
    if(ok) {
        // now check that given the connection, the address can be reached
        ok = flags & kSCNetworkReachabilityFlagsReachable;
    }

    if(ok) {
        [self sendGetIPRequest];
    } else {
        [self toAwait];
    }
}


- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    _cd = [[ConnectionDelegate alloc] init];
    [_cd setCallbackObject:self];
//    _connectionDelegate = [[ConnectionDelegate alloc] init];
//    [_connectionDelegate setCallbackObject:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Set up the icon that is displayed in the status bar
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"Awaiting IP...";
    _statusItem.toolTip = @"Public IP address of this computer";
    _statusItem.image = [NSImage imageNamed:@""];
    _statusItem.alternateImage = [NSImage imageNamed:@""];
    _statusItem.highlightMode = YES;
    
    // Menu stuff
    NSMenu *menu = [[NSMenu alloc] init];
    
    // For refreshing the IP
//    [menu addItemWithTitle:@"Refresh"
//                    action:@selector(processRefresh:)
//             keyEquivalent:@""];
//    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    
    // Add a simple 'about' item
    [menu addItemWithTitle:@"About"
                    action:@selector(frontAbout:)
             keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    
    // Add an exit item to exit program
    [menu addItemWithTitle:@"Exit"
                    action:@selector(processExit:)
             keyEquivalent:@""];
    _statusItem.menu = menu;
    [self setupReachability:@"ifconfig.me"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)processExit:(id)sender {
    [NSApp terminate: nil];
}

- (void)frontAbout:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:self];
}

- (void)toAwait {
    _statusItem.title = @"Awaiting IP...";
}

- (void)sendGetIPRequest {
    [_cd sendGetIPRequest];
}

//- (void)processRefresh:(id)sender {
//    [ self sendGetIPRequest];
//}

@end
