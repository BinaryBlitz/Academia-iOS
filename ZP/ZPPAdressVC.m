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
#import "UIView+UIViewCategory.h"

#import <INTULocationManager/INTULocationManager.h>

#import "ZPPAddress.h"
#import "ZPPAddressHelper.h"

#import "ZPPConsts.h"

#import "LMGeocoder.h"

static NSString *ZPPButtonTitle = @"Да, я здесь";

@import GoogleMaps;

@interface ZPPAdressVC () <GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView_;

@property (strong, nonatomic) UITextField *addresTextField;

@property (strong, nonatomic) UIView *centralView;

@property (strong, nonatomic) UIButton *actionButton;

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

                              } else if (status == INTULocationStatusTimedOut) {
                              } else {
                                  // An error occurred, more info is available by
                                  // looking at the specific status returned.
                              }
                          }];

    //    +55.75674918,+37.60394961
    GMSCameraPosition *camera =
        [GMSCameraPosition cameraWithLatitude:55.75674918 longitude:37.60394961 zoom:10];

    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView_.myLocationEnabled = YES;
    self.view = self.mapView_;
    self.mapView_.delegate = self;

    [self.view addSubview:self.addresTextField];
    [self.view addSubview:self.centralView];
    [self.view addSubview:self.actionButton];
    [self.view bringSubviewToFront:self.addresTextField];
    [self.view bringSubviewToFront:self.actionButton];

   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController presentTransparentNavigationBar];
   // [self addGradient];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  //  [self addGradient];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:position.target
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            if (results.count && !error) {
                                                LMAddress *address = [results firstObject];
                                                // NSLog(@"Address: %@", address.formattedAddress);
                                                ZPPAddress *adr =
                                                    [ZPPAddressHelper addresFromAddres:address];

                                                self.addresTextField.text = [adr formatedDescr];
                                            }
                                        }];
}

//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    [mapView clear];
//
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = coordinate;
//    //    marker.title = @"Sydney";
//    //    marker.snippet = @"Australia";
//    marker.map = self.mapView_;
//
//    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:coordinate
//                                                  service:kLMGeocoderGoogleService
//                                        completionHandler:^(NSArray *results, NSError *error) {
//                                            if (results.count && !error) {
//                                                LMAddress *address = [results firstObject];
//                                                NSLog(@"Address: %@", address.formattedAddress);
//
//                                                self.addresTextField.text =
//                                                    address.formattedAddress;
//                                            }
//                                        }];
//}

#pragma mark - actions

- (void)chooseLocation:(UIButton *)sender {
    //    ZPPAddress *address = [[ZPPAddress alloc] initWithCoordinate:self.mapView_.camera.target
    //                                                         Country:@"Russia"
    //                                                            city:@"Moscow"
    //                                                         address:@"aa"];

    [[LMGeocoder sharedInstance]
        reverseGeocodeCoordinate:self.mapView_.camera.target
                         service:kLMGeocoderGoogleService
               completionHandler:^(NSArray *results, NSError *error) {
                   if (results.count && !error) {
                       LMAddress *addr = [results firstObject];


                       ZPPAddress *address = [ZPPAddressHelper addresFromAddres:addr];

                       // NSLog(@"lines %@", addr.lines);

                       if (self.addressDelegate) {
                           [self.addressDelegate configureWithAddress:address sender:self];
                           [self.navigationController popViewControllerAnimated:YES];
                       }
                       //                                                self.addresTextField.text =
                       //                                                address.formattedAddress;
                   }
               }];

    //    if (self.addressDelegate) {
    //        [self.addressDelegate configureWithAddress:address sender:self];
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}

#pragma mark - lazy

- (UITextField *)addresTextField {
    if (!_addresTextField) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGRect r = self.navigationController.navigationBar.frame;

        _addresTextField = [[UITextField alloc]
            initWithFrame:CGRectMake(0, r.size.height + r.origin.x, size.width, 40)];
    }

    return _addresTextField;
}

- (UIView *)centralView {
    if (!_centralView) {
        CGSize s = [UIScreen mainScreen].bounds.size;
//        _centralView =
//            [[UIView alloc] initWithFrame:CGRectMake(s.width / 2.0, s.height / 2.0, 30, 30)];
//        _centralView.backgroundColor = [UIColor whiteColor];

        _centralView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker"]];
        _centralView.frame = CGRectMake(s.width / 2.0-15, s.height / 2.0 - 30, 30, 30);
        _centralView.backgroundColor = [UIColor clearColor];
    }
    return _centralView;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setTitle:ZPPButtonTitle forState:UIControlStateNormal];
        CGRect r = [UIScreen mainScreen].bounds;
        //      _actionButton.frame = CGRectMake(, , ,)
        _actionButton.frame = CGRectMake(30, r.size.height - 100, r.size.width - 60, 45);
        [_actionButton makeBordered];

        [_actionButton addTarget:self
                          action:@selector(chooseLocation:)
                forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    return _actionButton;
}
//
//- (void)addGradient {
//   // UIView *view = self.navigationController.navigationBar.ba; // self.navigationController.navigationItem;
//    if (![[view.layer.sublayers firstObject] isKindOfClass:[CAGradientLayer class]]) {
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = view.bounds;
//        
//        gradient.endPoint = CGPointMake(0.5, 0);
//        gradient.startPoint = CGPointMake(0.5, 1.0);
//        
//        gradient.colors =
//        [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
//         (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor], nil];
//        [view.layer insertSublayer:gradient atIndex:0];
//    }
//
//}

@end
