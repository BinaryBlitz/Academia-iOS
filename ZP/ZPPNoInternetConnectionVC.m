//
//  ZPPNoInternetConnectionVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPNoInternetConnectionVC.h"
#import "Reachability.h"

@interface ZPPNoInternetConnectionVC ()

@property (strong, nonatomic) Reachability *reachability;

@property (strong, nonatomic) UIImageView *spinner;

@property (assign, nonatomic) BOOL animating;

@end

@implementation ZPPNoInternetConnectionVC

- (void)viewDidLoad {
  [super viewDidLoad];

  self.reachability = [Reachability reachabilityForInternetConnection];

  [self.tryAgainButton addTarget:self
                          action:@selector(tryAgain)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.reachability startNotifier];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reachabilityChanged:)
                                               name:kReachabilityChangedNotification
                                             object:nil];

  //    [self.centralLogo.superview addSubview:self.spinner];
  //    [self startSpin];

  //  [self animate];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //  [self animate];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self.reachability stopNotifier];
  [self stopSpin];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (![self.centralLogo.superview.subviews containsObject:self.spinner]) {
    [self.centralLogo.superview addSubview:self.spinner];
    [self startSpin];
  }
}

- (void)tryAgain {
  if ([self.reachability currentReachabilityStatus] != NotReachable) {
    if (self.noInternetDelegate) {
      [self.noInternetDelegate tryAgainSender:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)reachabilityChanged:(NSNotification *)notification {
  [self tryAgain];
}

#pragma mark - animation

- (UIImageView *)spinner {
  if (!_spinner) {
    CGFloat offset = 20.f;
    CGRect r = self.centralLogo.frame;
    CGFloat leng = r.size.height + offset * 4;

    CGRect sr = self.centralLogo.superview.frame;

    UIImageView *iv = [[UIImageView alloc]
        initWithFrame:CGRectMake(3 + (sr.size.width - leng) / 2.0,
            (sr.size.height - leng) / 2.0, leng, leng)];

    iv.image = [UIImage imageNamed:@"spinner"];

    _spinner = iv;
  }
  return _spinner;
}

//- (void)spinWithOptions:(UIViewAnimationOptions)options directionForward:(BOOL)isForward {
//    // this spin completes 360 degrees every 2 seconds
//    [UIView animateWithDuration:0.5f
//        delay:1.0f
//        options:options
//        animations:^{
//            self.spinner.transform =
//                CGAffineTransformRotate(self.spinner.transform, isForward ? 2 * M_PI_2 : -2 *
//                M_PI);
//        }
//        completion:^(BOOL finished) {
//            if (finished) {
//                if (self.animating) {
//                    //                    // if flag still set, keep spinning with constant speed
//                    //                    [self spinWithOptions:UIViewAnimationOptionCurveLinear
//                    //                    directionForward:!isForward];
//                    //                } else if (options != UIViewAnimationOptionCurveEaseOut) {
//                    // one last spin, with deceleration
//                    [self spinWithOptions:UIViewAnimationOptionCurveEaseOut
//                         directionForward:!isForward];
//                }
//            }
//        }];
//}
//
- (void)startSpin {
  if (!self.animating) {
    self.animating = YES;
    // [self spinWithOptions:UIViewAnimationOptionCurveEaseIn directionForward:YES];

    [self animateForward:YES delay:0.f];
  }
}

- (void)stopSpin {
  // set the flag to stop spinning after one last 90 degree increment
  self.animating = NO;
}

- (void)animateForward:(BOOL)isForward delay:(float)delay {
  CGFloat direction = isForward ? 1.0f : -1.0f;  // -1.0f to rotate other way
  self.spinner.transform = CGAffineTransformIdentity;
  [UIView animateKeyframesWithDuration:1.0
                                 delay:delay
                               options:UIViewKeyframeAnimationOptionCalculationModePaced |
                                   UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                              [UIView addKeyframeWithRelativeStartTime:0.0
                                                      relativeDuration:0.0
                                                            animations:^{
                                                              self.spinner.transform =
                                                                  CGAffineTransformMakeRotation(M_PI * 2.0f /
                                                                      3.0f *
                                                                      direction);
                                                            }];
                              [UIView addKeyframeWithRelativeStartTime:0.0
                                                      relativeDuration:0.0
                                                            animations:^{
                                                              self.spinner.transform =
                                                                  CGAffineTransformMakeRotation(M_PI * 4.0f /
                                                                      3.0f *
                                                                      direction);
                                                            }];
                              [UIView addKeyframeWithRelativeStartTime:0.0
                                                      relativeDuration:0.0
                                                            animations:^{
                                                              self.spinner.transform =
                                                                  CGAffineTransformIdentity;
                                                            }];
                            }
                            completion:^(BOOL finished) {

                              if (self.animating) {
                                [self animateForward:!isForward delay:1.5];
                              }
                            }];

//    [UIView animateWithDuration:2.0
//        delay:delay
//        usingSpringWithDamping:0.1
//        initialSpringVelocity:2.0
//        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
//        animations:^{
//
//            self.spinner.transform = CGAffineTransformMakeRotation(M_PI_2 * direction);
//
//            //            [UIView addKeyframeWithRelativeStartTime:0.0
//            //                                    relativeDuration:0.0
//            //                                          animations:^{
//            //                                              self.spinner.transform =
//            //                                              CGAffineTransformMakeRotation(M_PI *
//            //                                              2.0f / 3.0f *
//            //                                                                            direction);
//            //                                          }];
//            //            [UIView addKeyframeWithRelativeStartTime:0.0
//            //                                    relativeDuration:0.0
//            //                                          animations:^{
//            //                                              self.spinner.transform =
//            //                                              CGAffineTransformMakeRotation(M_PI *
//            //                                              4.0f / 3.0f *
//            //                                                                            direction);
//            //                                          }];
//            //            [UIView addKeyframeWithRelativeStartTime:0.0
//            //                                    relativeDuration:0.0
//            //                                          animations:^{
//            //                                              self.spinner.transform =
//            //                                              CGAffineTransformIdentity;
//            //                                          }];
//
//        }
//        completion:^(BOOL finished) {
//
//            if (self.animating && finished) {
//                [self animateForward:!isForward delay:2];
//            }
//        }];
}

@end
