//
//  GPS.m
//  HelloWorld
//
//  Created by Vitor Venturin Linhalis on 16/12/14.
//
//

#import "GPS.h"
#import <Cordova/CDV.h>

@implementation GPS

CLLocationManager *locationManager;
static double lat;
static double lng;

- (void)escrever:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
 
    [locationManager startUpdatingLocation];
    
    NSString *latString = [NSString stringWithFormat:@"%.6f", lat];
    NSString *lngString = [NSString stringWithFormat:@"%.6f", lng];
    
    NSArray *vetor = [[NSArray alloc] initWithObjects:latString,lngString,nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:vetor];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)locationservice:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSNumber *isGPSEnabled;
    NSNumber *isNetworkEnabled;
    
    if([CLLocationManager locationServicesEnabled]){
      if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        isGPSEnabled = [NSNumber numberWithBool:NO];
        isNetworkEnabled = [NSNumber numberWithBool:NO];
      }
      else{
        isGPSEnabled = [NSNumber numberWithBool:YES];
        isNetworkEnabled = [NSNumber numberWithBool:YES];
      }
    }
    else{
        isGPSEnabled = [NSNumber numberWithBool:NO];
        isNetworkEnabled = [NSNumber numberWithBool:NO];
    }
    
    NSArray *vetor = [[NSArray alloc] initWithObjects:isGPSEnabled,isNetworkEnabled,nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:vetor];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        NSDate* eventDate = currentLocation.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        if (abs(howRecent) < 15.0) {
            // If the event is recent, do something with it.
            lat = currentLocation.coordinate.latitude;
            lng = currentLocation.coordinate.longitude;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

@end
