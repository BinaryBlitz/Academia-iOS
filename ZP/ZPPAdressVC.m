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

#import "LMGeocoder.h"

@import GoogleMaps;

@interface ZPPAdressVC () <GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView_;

@property (strong, nonatomic) UITextField *addresTextField;

@property (strong, nonatomic) UIView *centralView;

@end

@implementation ZPPAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:
                              YES block:^(CLLocation *currentLocation,
                                          INTULocationAccuracy achievedAccuracy,
                                          INTULocationStatus status) {

                              if (status == INTULocationStatusSuccess) {
                                  GMSCameraPosition *camera = [GMSCameraPosition
                                      cameraWithLatitude:currentLocation.coordinate.latitude
                                               longitude:currentLocation.coordinate.longitude
                                                    zoom:12];

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

    //    +55.75674918,+37.60394961
    GMSCameraPosition *camera =
        [GMSCameraPosition cameraWithLatitude:55.75674918 longitude:37.60394961 zoom:8];

    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView_.myLocationEnabled = YES;
    self.view = self.mapView_;
    self.mapView_.delegate = self;

    [self.view addSubview:self.addresTextField];
    [self.view addSubview:self.centralView];
    [self.view bringSubviewToFront:self.addresTextField];

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

- (UITextField *)addresTextField {
    if (!_addresTextField) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGRect r = self.navigationController.navigationBar.frame;

        _addresTextField =
            [[UITextField alloc] initWithFrame:CGRectMake(0, r.size.height, size.width, 40)];
    }

    return _addresTextField;
}

//- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
////    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:position.target
////                                                  service:kLMGeocoderGoogleService
////                                        completionHandler:^(NSArray *results, NSError *error) {
////                                            if (results.count && !error) {
////                                                LMAddress *address = [results firstObject];
////                                                NSLog(@"Address: %@", address.formattedAddress);
////
////                                                self.addresTextField.text =
////                                                    address.formattedAddress;
////                                            }
////                                        }];
//}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    [mapView clear];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    //    marker.title = @"Sydney";
    //    marker.snippet = @"Australia";
    marker.map = self.mapView_;
    

    
    
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:coordinate
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            if (results.count && !error) {
                                                LMAddress *address = [results firstObject];
                                                NSLog(@"Address: %@", address.formattedAddress);
                                                
                                                self.addresTextField.text =
                                                address.formattedAddress;
                                            }
                                        }];

}

- (UIView *)centralView {
    if (!_centralView) {
        CGSize s = [UIScreen mainScreen].bounds.size;
        _centralView =
            [[UIView alloc] initWithFrame:CGRectMake( s.width / 2.0,s.height / 2.0, 30, 30)];
        _centralView.backgroundColor = [UIColor whiteColor];
    }
    return _centralView;
}

@end
