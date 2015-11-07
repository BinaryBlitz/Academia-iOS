//
//  ZPPAdressVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 07/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAdressVC.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"

#import <INTULocationManager/INTULocationManager.h>

#import "ZPPConsts.h"

@import GoogleMaps;

@interface ZPPAdressVC ()

@property (strong, nonatomic) GMSMapView *mapView_;

@end

@implementation ZPPAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    //    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
    //                                                            longitude:151.20
    //                                                                 zoom:6];
    //    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //    self.mapView_.myLocationEnabled = YES;

    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if
                                                    // omitted
                                         block:^(CLLocation *currentLocation,
                                                 INTULocationAccuracy achievedAccuracy,
                                                 INTULocationStatus status) {

                                             if (status == INTULocationStatusSuccess) {
                                                 GMSCameraPosition *camera = [GMSCameraPosition
                                                     cameraWithLatitude:currentLocation.coordinate
                                                                            .latitude
                                                              longitude:currentLocation.coordinate
                                                                            .longitude
                                                                   zoom:2];

                                                 self.mapView_.camera = camera;

                                                 GMSMarker *marker = [[GMSMarker alloc] init];
                                                 marker.position = CLLocationCoordinate2DMake(
                                                     currentLocation.coordinate.latitude,
                                                     currentLocation.coordinate.longitude);
                                                 //    marker.title = @"Sydney";
                                                 //    marker.snippet = @"Australia";
                                                 marker.map = self.mapView_;

                  
                                             } else if (status == INTULocationStatusTimedOut) {
        
                                             } else {
                                                 // An error occurred, more info is available by
                                                 // looking at the specific status returned.
                                             }
                                         }];

    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:nil];
    self.mapView_.myLocationEnabled = YES;
    self.view = self.mapView_;

    // Creates a marker in the center of the map.
    //    GMSMarker *marker = [[GMSMarker alloc] init];
    //    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    ////    marker.title = @"Sydney";
    ////    marker.snippet = @"Australia";
    //    marker.map = self.mapView_;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController presentTransparentNavigationBar];
}

@end
