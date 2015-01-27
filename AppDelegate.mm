//
//  AppDelegate.m
//  OSXIPDisplayer
//
//  Created by Ben Jones on 1/27/15.
//  Copyright (c) 2015 Ben Jones. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (BOOL) endsWithCharacter: (unichar) c
                 forString: (NSString*)str
{
    NSUInteger length = [str length];
    return (length > 0) && ([str characterAtIndex: length - 1] == c);
}

- (void)updateIP {
    
    NSString* strippedIP = _connectionDelegate.getIPString;
    if ([self endsWithCharacter: L'\n'
                        forString: strippedIP]) {
        strippedIP = [strippedIP substringToIndex:[strippedIP length]-1];
    }
    
    _statusItem.title = strippedIP;
}


- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    // retrieve public ip
    _connectionDelegate = [[ConnectionDelegate alloc] init];
    [_connectionDelegate setCallbackObject:self];
    [_connectionDelegate sendGetIPRequest];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Set up the icon that is displayed in the status bar
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"Awaiting IP...";
    _statusItem.toolTip = @"Public IP address of this computer";
    _statusItem.image = [NSImage imageNamed:@"statusIcon"];
    _statusItem.alternateImage = [NSImage imageNamed:@"statusIcon"];
    _statusItem.highlightMode = YES;
    
    // Menu stuff
    NSMenu *menu = [[NSMenu alloc] init];
    
    // For refreshing the IP
    [menu addItemWithTitle:@"Refresh"
                    action:@selector(processRefresh:)
             keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    
    // Add a simple 'about' item
    [menu addItemWithTitle:@"About"
                    action:@selector(orderFrontStandardAboutPanel:)
             keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    
    // Add an exit item to exit program
    [menu addItemWithTitle:@"Exit"
                    action:@selector(processExit:)
             keyEquivalent:@""];
    _statusItem.menu = menu;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)processExit:(id)sender {
    [NSApp terminate: nil];
}

- (void)processRefresh:(id)sender {
    _statusItem.title = @"Awaiting IP...";
    [_connectionDelegate sendGetIPRequest];
}

@end
