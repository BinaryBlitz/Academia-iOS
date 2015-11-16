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
    if(![self.centralLogo.superview.subviews containsObject:self.spinner]) {
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

- (void)spinWithOptions:(UIViewAnimationOptions)options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration:0.5f
        delay:0.0f
        options:options
        animations:^{
            self.spinner.transform = CGAffineTransformRotate(self.spinner.transform, M_PI / 2);
        }
        completion:^(BOOL finished) {
            if (finished) {
                if (self.animating) {
                    // if flag still set, keep spinning with constant speed
                    [self spinWithOptions:UIViewAnimationOptionCurveLinear];
                } else if (options != UIViewAnimationOptionCurveEaseOut) {
                    // one last spin, with deceleration
                    [self spinWithOptions:UIViewAnimationOptionCurveEaseOut];
                }
            }
        }];
}

- (void)startSpin {
    if (!self.animating) {
        self.animating = YES;
        [self spinWithOptions:UIViewAnimationOptionCurveEaseIn];
    }
}

- (void)stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    self.animating = NO;
}

@end
