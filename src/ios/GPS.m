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
 
    if(IS_OS_8_OR_LATER) {
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
    
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
    NSNumber *isUndetermind;
    
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
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        isUndetermind = [NSNumber numberWithBool:YES];
    }
    else{
        isUndetermind = = [NSNumber numberWithBool:NO];
    }
    
    NSArray *vetor = [[NSArray alloc] initWithObjects:isGPSEnabled,isNetworkEnabled,isUndetermind,nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:vetor];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title =  @"Location service is off";
        NSString *message = @"To use location you must turn on either 'Always' or 'While Using the App' in the Location Services Settings";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        NSDate* eventDate = currentLocation.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        if (abs(howRecent) < 15.0) {
            lat = currentLocation.coordinate.latitude;
            lng = currentLocation.coordinate.longitude;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

@end
