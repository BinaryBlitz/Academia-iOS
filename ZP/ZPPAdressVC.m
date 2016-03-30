//
//  ZPPAdressVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 07/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAdressVC.h"

#import <INTULocationManager/INTULocationManager.h>
#import "LMGeocoder.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPAddress.h"
#import "ZPPAddressHelper.h"
#import "ZPPConsts.h"
#import "ZPPCustomTextField.h"
#import "ZPPSearchResultController.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"

static NSString *ZPPSearchResultCellIdentifier = @"ZPPSearchResultCellIdentifier";
static NSString *ZPPSearchResultControllerIdentifier = @"ZPPSearchResultControllerIdentifier";

static NSString *ZPPButtonTitle = @"Да, я здесь";
static NSString *ZPPSearchButtonText = @"ВВЕСТИ АДРЕС";

@import GoogleMaps;

@interface ZPPAdressVC () <GMSMapViewDelegate, ZPPAdressDelegate, UITextFieldDelegate>

@property (strong, nonatomic) GMSMapView *mapView_;
@property (strong, nonatomic) UITextField *addresTextField;
@property (strong, nonatomic) UIView *centralView;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) ZPPAddress *selectedAddress;
@property (assign, nonatomic) BOOL needUpdate;

@property (strong, nonatomic) GMSPolygon *poligon;

@end

@implementation ZPPAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    self.needUpdate = YES;

    [self showCurrentLocation];
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
    [self.view addSubview:self.centralView];
    [self.view addSubview:self.actionButton];
    [self.view bringSubviewToFront:self.actionButton];
    [self.view bringSubviewToFront:self.addresTextField];

    UIButton *b = [self addRightButtonWithName:@"currentLocation"];

    [b addTarget:self
                  action:@selector(showCurrentLocation)
        forControlEvents:UIControlEventTouchUpInside];

    [self setPoints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addGradient];
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    if (self.needUpdate) {
        [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:position.target
                                                      service:kLMGeocoderGoogleService
                                            completionHandler:^(NSArray *results, NSError *error) {
                                                // NSLog(@"err %@ res %@",error,results);
                                                if (results.count && !error) {
                                                    LMAddress *address = [results firstObject];
                                                    ZPPAddress *adr =
                                                        [ZPPAddressHelper addresFromAddres:address];

                                                    self.addresTextField.text = [adr formatedDescr];

                                                    self.selectedAddress = adr;
                                                }
                                            }];
    } else {
        self.needUpdate = YES;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //   [self.addresTextField resignFirstResponder];
}

#pragma mark - actions

- (void)chooseLocation:(UIButton *)sender {
    if (self.poligon) {
        if (!GMSGeometryContainsLocation(self.mapView_.camera.target, self.poligon.path, YES)) {
            //            NSLog(@"YES: you are in this polygon.");

            [self showWarningWithText:@"Мы доставляем только внутри Садового Кольца"];
            return;
        }
    }

    if (self.addressDelegate) {
        if (self.selectedAddress) {
            [self.addressDelegate configureWithAddress:self.selectedAddress sender:self];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
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
    }
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
                                                                 zoom:17];

    self.mapView_.camera = camera;
}

- (void)showCurrentLocation {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr
        requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                   timeout:10.0
                      delayUntilAuthorized:YES
                                     block:^(CLLocation *currentLocation,
                                             INTULocationAccuracy achievedAccuracy,
                                             INTULocationStatus status) {

                                         if (status == INTULocationStatusSuccess) {
                                             [self
                                                 moveCameraToCoordinate:currentLocation.coordinate];

                                         } else if (status == INTULocationStatusTimedOut) {
                                         } else {
                                             // An error occurred, more info is available by
                                             // looking at the specific status returned.
                                         }
                                     }];
}

#pragma mark - UITextFielDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showAddressChooser];
    return NO;
}

#pragma mark - lazy

- (UITextField *)addresTextField {
    if (!_addresTextField) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGRect r = self.navigationController.navigationBar.frame;
        _addresTextField = [[ZPPCustomTextField alloc]
            initWithFrame:CGRectMake(20, r.size.height + 20, size.width - 40, 40)];
        _addresTextField.backgroundColor = [UIColor whiteColor];
        _addresTextField.layer.cornerRadius = 5.0;
        _addresTextField.delegate = self;
    }

    return _addresTextField;
}

- (UIView *)centralView {
    if (!_centralView) {
        CGSize s = [UIScreen mainScreen].bounds.size;
        _centralView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker"]];
        _centralView.frame = CGRectMake(s.width / 2.0 - 30, s.height / 2.0 - 60, 60, 60);
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
    if (!address) {
        [self showCurrentLocation];
    } else {
        [self moveCameraToCoordinate:address.coordinate];

        self.needUpdate = NO;

        self.addresTextField.text = [address formatedDescr];

        self.selectedAddress = address;
    }
}

#pragma mark - ui

- (void)addGradient {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGRect fr = self.navigationController.navigationBar.bounds;

    fr.origin.y = 0;
    fr.size.height = fr.size.height + 20;

    gradientLayer.frame = fr;

    gradientLayer.colors = @[
        (__bridge id)[UIColor colorWithWhite:0.2 alpha:0.5]
            .CGColor,
        (__bridge id)[UIColor clearColor].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);

    UIGraphicsBeginImageContext(gradientLayer.bounds.size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:gradientImage
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)setPoints {
    [[ZPPServerManager sharedManager] getPoligonPointsOnSuccess:^(NSArray *points) {
        [self addMapPoligonWithPoints:points];
    }
        onFailure:^(NSError *error, NSInteger statusCode){

        }];
}

- (void)addMapPoligonWithPoints:(NSArray *)arr {
    GMSMutablePath *path = [GMSMutablePath path];

    for (ZPPAddress *a in arr) {
        [path addCoordinate:a.coordinate];
    }
    GMSPolygon *poligon = [GMSPolygon polygonWithPath:path];
    poligon.fillColor =
        [UIColor colorWithRed:46.0 / 255.0 green:232.0 / 255.0 blue:91.0 / 255.0 alpha:0.1];
    poligon.strokeWidth = 2.0;
    poligon.strokeColor = [UIColor colorWithRed:46.0 / 255.0 green:232.0 / 255.0 blue:91.0 / 255.0 alpha:0.5];

    self.poligon = poligon;

    poligon.map = self.mapView_;
}

@end
