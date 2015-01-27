//
//  ConnectionDelegate.m
//  OSXIPDisplayer
//
//  Created by Ben Jones on 1/27/15.
//  Copyright (c) 2015 Ben Jones. All rights reserved.
//

#import "ConnectionDelegate.h"
#import "AppDelegate.h"

@implementation ConnectionDelegate

- (void) setCallbackObject:(AppDelegate*)callbackObject {
    _callBackObject = callbackObject;
}

- (void) sendGetIPRequest {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ifconfig.me/ip"]];
    
    
    // create the connection with the request
    // and start loading the data
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if (!conn) {
        // Release the receivedData object.
        _receivedData = nil;
        
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    _receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_receivedData appendData:data];
    _ipString = [[NSString alloc] initWithData:_receivedData
                                      encoding:NSASCIIStringEncoding];
    
    [_callBackObject updateIP];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

- (NSString*) getIPString {
    return _ipString;
}

@end
