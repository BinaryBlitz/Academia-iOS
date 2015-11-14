//
//  ZPPNoInternetConnectionVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPNoInternetConnectionVC.h"
#import "Reachability.h"

@interface ZPPNoInternetConnectionVC()

@property (strong, nonatomic) Reachability *reachability;

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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reachability stopNotifier];
}

- (void)tryAgain {
    if ([self.reachability currentReachabilityStatus] !=
        NotReachable) {
        if (self.noInternetDelegate) {
            [self.noInternetDelegate tryAgainSender:self];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)reachabilityChanged:(NSNotification *)notification {
    
    [self tryAgain];
}

@end
