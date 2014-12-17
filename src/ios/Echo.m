//
//  Echo.m
//  HelloWorld
//
//  Created by Vitor Venturin Linhalis on 16/12/14.
//
//

#import "Echo.h"
#import <Cordova/CDV.h>

@implementation Echo

- (void)echo:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *echo = @"BLA"; //[command.arguments objectAtIndex:0];
//    NSArray *vetor = [[NSArray alloc] initWithObjects:@"20",@"40",nil];
    
    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];//messageAsArray:vetor];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
