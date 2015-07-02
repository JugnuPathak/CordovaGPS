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
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if(IS_OS_8_OR_LATER) {
        NSLog(@"IOS 8");
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
    
    [locationManager startUpdatingLocation];
    
    NSString *latString = [NSString stringWithFormat:@"%.6f", lat];
    NSString *lngString = [NSString stringWithFormat:@"%.6f", lng];
    lat = 0.0;
    lng = 0.0;
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

#pragma mark - CLLocationManagerDelegate

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title =  @"Location service is off" ;
        NSString *message = @"To use location service you must turn on either 'Always' or 'When Using the APP' in the Location Services Settings";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        NSDate* eventDate = currentLocation.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        if (abs(howRecent) < 5.0 && (currentLocation.horizontalAccuracy >= 0 && currentLocation.horizontalAccuracy <= 20)) {
            lat = currentLocation.coordinate.latitude;
            lng = currentLocation.coordinate.longitude;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    lat = 0.0;
    lng = 0.0;
}

@end
