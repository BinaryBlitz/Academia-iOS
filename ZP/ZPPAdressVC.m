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

#import "ZPPSearchResultController.h"

#import "ZPPConsts.h"

#import "LMGeocoder.h"

static NSString *ZPPSearchResultCellIdentifier = @"ZPPSearchResultCellIdentifier";

static NSString *ZPPSearchResultControllerIdentifier = @"ZPPSearchResultControllerIdentifier";

static NSString *ZPPButtonTitle = @"Да, я здесь";
static NSString *ZPPSearchButtonText = @"ВВЕСТИ АДРЕС";

@import GoogleMaps;

@interface ZPPAdressVC () <GMSMapViewDelegate, ZPPAdressDelegate>

@property (strong, nonatomic) GMSMapView *mapView_;

@property (strong, nonatomic) UITextField *addresTextField;

@property (strong, nonatomic) UIView *centralView;

@property (strong, nonatomic) UIButton *actionButton;

//@property (strong, nonatomic) UISearchController *searchController;

//@property (strong, nonatomic) UISearchBar *addressSearchBar;

@property (strong, nonatomic) NSArray *results;

@property (strong, nonatomic) UIButton *searchButton;

@end

@implementation ZPPAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    //    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    //    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
    //                                       timeout:10.0
    //                          delayUntilAuthorized:YES
    //                                         block:^(CLLocation *currentLocation,
    //                                                 INTULocationAccuracy achievedAccuracy,
    //                                                 INTULocationStatus status) {
    //
    //                                             if (status == INTULocationStatusSuccess) {
    //                                                 [self moveCameraToCoordinate:currentLocation
    //                                                                                  .coordinate];
    //
    //                                             } else if (status == INTULocationStatusTimedOut)
    //                                             {
    //                                             } else {
    //                                                 // An error occurred, more info is available
    //                                                 by
    //                                                 // looking at the specific status returned.
    //                                             }
    //                                         }];

    [self showCurrentLocation];

    //    +55.75674918,+37.60394961
    GMSCameraPosition *camera =
        [GMSCameraPosition cameraWithLatitude:55.75674918 longitude:37.60394961 zoom:10];

    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView_.myLocationEnabled = YES;

    self.mapView_.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.mapView_];
    self.mapView_.delegate = self;
    self.mapView_.settings.tiltGestures = NO;
    self.mapView_.settings.rotateGestures = NO;

    [self.view addSubview:self.addresTextField];
    //[self.view addSubview:self.addressSearchBar];
    [self.view addSubview:self.centralView];
    [self.view addSubview:self.actionButton];
    [self.view addSubview:self.searchButton];
    //[self.view bringSubviewToFront:self.addressSearchBar];
    [self.view bringSubviewToFront:self.actionButton];

    // UIImage imageNamed:@"currentLocation"
    UIButton *b = [self addRightButtonWithName:@"currentLocation"];

    [b addTarget:self
                  action:@selector(showCurrentLocation)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
//    // [self.addressSearchBar sizeToFit];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //  [self addGradient];
    //  [self.navigationController hideTransparentNavigationBar];
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

#pragma mark - actions

- (void)chooseLocation:(UIButton *)sender {
    [[LMGeocoder sharedInstance]
        reverseGeocodeCoordinate:self.mapView_.camera.target
                         service:kLMGeocoderGoogleService
               completionHandler:^(NSArray *results, NSError *error) {
                   if (results.count && !error) {
                       LMAddress *addr = [results firstObject];

                       ZPPAddress *address = [ZPPAddressHelper addresFromAddres:addr];

                       if (self.addressDelegate) {
                           [self.addressDelegate configureWithAddress:address sender:self];
                           [self.navigationController popViewControllerAnimated:YES];
                       }
                   }
               }];
}

- (void)showAddressChooser {
    ZPPSearchResultController *src = [self.storyboard
        instantiateViewControllerWithIdentifier:ZPPSearchResultControllerIdentifier];
    src.addressSearchDelegate = self;

    [self presentViewController:src animated:YES completion:nil];
}

#pragma mark - map

- (void)moveCameraToCoordinate:(CLLocationCoordinate2D)coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:12];

    self.mapView_.camera = camera;
}

- (void)showCurrentLocation {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES
                                         block:^(CLLocation *currentLocation,
                                                 INTULocationAccuracy achievedAccuracy,
                                                 INTULocationStatus status) {

                                             if (status == INTULocationStatusSuccess) {
                                                 [self moveCameraToCoordinate:currentLocation
                                                                                  .coordinate];

                                             } else if (status == INTULocationStatusTimedOut) {
                                             } else {
                                                 // An error occurred, more info is available by
                                                 // looking at the specific status returned.
                                             }
                                         }];
}

#pragma mark - lazy

- (UIView *)centralView {
    if (!_centralView) {
        CGSize s = [UIScreen mainScreen].bounds.size;
        _centralView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker"]];
        _centralView.frame = CGRectMake(s.width / 2.0 - 15, s.height / 2.0 - 30, 30, 30);
        _centralView.backgroundColor = [UIColor clearColor];
    }
    return _centralView;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setTitle:ZPPButtonTitle forState:UIControlStateNormal];
        CGRect r = [UIScreen mainScreen].bounds;

        _actionButton.frame = CGRectMake(30, r.size.height - 100, r.size.width - 60, 45);
        [_actionButton makeBordered];

        [_actionButton addTarget:self
                          action:@selector(chooseLocation:)
                forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    return _actionButton;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [_searchButton setTitle:ZPPSearchButtonText forState:UIControlStateNormal];
        CGRect r = [UIScreen mainScreen].bounds;

        _searchButton.frame = CGRectMake(30, r.size.height - 160, r.size.width - 60, 45);
        [_searchButton makeBordered];

        [_searchButton addTarget:self
                          action:@selector(showAddressChooser)
                forControlEvents:UIControlEventTouchUpInside];
        [_searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    return _searchButton;
}

#pragma mark - addresSearchDelegate

- (void)configureWithAddress:(ZPPAddress *)address sender:(id)sender {
    [self moveCameraToCoordinate:address.coordinate];
}

//
//- (void)addGradient {
//   // UIView *view = self.navigationController.navigationBar.ba; //
//   self.navigationController.navigationItem;
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
