//
//  ZPPMainVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPMainVC.h"
#import "ZPPMainMenuView.h"
#import "ZPPUserManager.h"

#import "ZPPOrder.h"
#import "ZPPOrderTVC.h"
#import "ZPPGiftTVC.h"
#import "ZPPOrderHistoryTVC.h"
#import "ZPPNoInternetConnectionVC.h"

#import "UIViewController+ZPPViewControllerCategory.h"

// libs
#import <VBFPopFlatButton.h>
#import <JSBadgeView.h>

static float kZPPButtonDiametr = 40.0f;
static float kZPPButtonOffset = 15.0f;

@interface ZPPMainVC () <ZPPNoInternetDelegate>
@property (strong, nonatomic) VBFPopFlatButton *menuButton;
@property (strong, nonatomic) ZPPMainMenuView *mainMenu;
@property (strong, nonatomic) VBFPopFlatButton *button;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UIView *orderView;
@property (strong, nonatomic) JSBadgeView *badgeView;

@property (assign, nonatomic) BOOL menuShowed;

@property (strong, nonatomic) ZPPOrder *order;

@property (assign, nonatomic) BOOL animationShoved;
@end

@implementation ZPPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //  [self showViewWithAnimation];

    if ([[ZPPUserManager sharedInstance] checkUser]) {
        [self.view addSubview:self.mainMenu];
        [self.view addSubview:self.buttonView];
        [self updateBadge];
    } else {
        if ([self.view.subviews containsObject:self.mainMenu]) {
            [self.mainMenu removeFromSuperview];
        }
        if ([self.view.subviews containsObject:self.buttonView]) {
            [self.buttonView removeFromSuperview];
        }
        if ([self.view.subviews containsObject:self.orderView]) {
            [self.orderView removeFromSuperview];
            _order = nil;
        }
    }
    [self showViewWithAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ui

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//#pragma mark - ZPPBeginDelegate
//
//-(void)didPressBeginButton {
////    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"secondStoryBoard"
/// bundle:nil];
////
////    // Load the initial view controller from the storyboard.
////    // Set this by selecting 'Is Initial View Controller' on the appropriate view controller in
/// the storyboard.
////    UIViewController *theInitialViewController = [secondStoryBoard
/// instantiateInitialViewController];
////    //
////    // **OR**
////    //
////    // Load the view controller with the identifier string myTabBar
////    // Change UIViewController to the appropriate class
////    UIViewController *theTabBar = (UIViewController *)[secondStoryBoard
/// instantiateViewControllerWithIdentifier:@"myTabBar"];
////
////    // Then push the new view controller in the usual way:
////    [self.navigationController pushViewController:theTabBar animated:YES];
//}

- (void)showRegistration {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"registration" bundle:nil];

    // Load the initial view controller from the storyboard.
    // Set this by selecting 'Is Initial View Controller' on the appropriate view controller in the
    // storyboard.
    UIViewController *theInitialViewController =
        [secondStoryBoard instantiateInitialViewController];
    //
    // **OR**
    //
    // Load the view controller with the identifier string myTabBar
    // Change UIViewController to the appropriate class
    // UIViewController *theTabBar = (UIViewController *)[secondStoryBoard
    // instantiateViewControllerWithIdentifier:@"myTabBar"];

    // Then push the new view controller in the usual way:
    //[self.navigationController pushViewController:theTabBar animated:YES];

    [self presentViewController:theInitialViewController
                       animated:YES
                     completion:^{

                     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - action

- (void)buttonWork {
    if (!self.menuShowed) {
        [self showMenu];
    } else {
        [self dissmisMenu];
    }
}

- (void)showMenu {
    self.menuShowed = YES;
    [self.button animateToType:buttonCloseType];
    [self.mainMenu showCompletion:^{

    }];
    // [self.menuButton animateToType:buttonCloseType];
}

- (void)dissmisMenu {
    [self.button animateToType:buttonMenuType];
    self.menuShowed = NO;
    [self.mainMenu dismissCompletion:^{

    }];
}

- (void)showOrderButton {
    if (![self.view.subviews containsObject:self.orderView]) {
        [self.view addSubview:self.orderView];
    } else {
        return;
    }

    [UIView animateWithDuration:0.5
        delay:0.0
        usingSpringWithDamping:1.
        initialSpringVelocity:1.
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{

            CGRect r = self.orderView.frame;
            r.origin.y = kZPPButtonOffset;
            self.orderView.frame = r;
        }
        completion:^(BOOL finished){

        }];
}

- (void)hideOrderButton {
    if (![self.view.subviews containsObject:self.orderView]) {
        return;
    }

    [UIView animateWithDuration:0.5
        delay:0.0
        usingSpringWithDamping:1.
        initialSpringVelocity:1.
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{

            CGRect r = self.orderView.frame;
            r.origin.y = -kZPPButtonDiametr - kZPPButtonOffset;
            self.orderView.frame = r;
        }
        completion:^(BOOL finished) {
            _orderView = nil;
        }];
}

- (void)showNoInternetScreen {
    [self showNoInternetVC];
}

- (void)showProfile {
    [self dissmisMenu];

    [self showVCFromStoryboardWithName:@"profile"];
}

- (void)showHelp {
    [self dissmisMenu];

    [self showVCFromStoryboardWithName:@"help"];
}

- (void)showGifts {
    [self dissmisMenu];

    //    UINavigationController *nvc =
    //        (UINavigationController *)[self initialVCForStoryboardWithName:@"gifts"];

    ZPPGiftTVC *gtvc = (ZPPGiftTVC *)
        [self firstRealVCFormStoryBoardWithName:@"gifts"];  //[nvc.viewControllers firstObject];

    [gtvc configureWithOrder:self.order];

    [self presentViewController:gtvc.navigationController animated:YES completion:nil];
}

- (void)showOrderHistory {
    [self dissmisMenu];

    ZPPOrderHistoryTVC *ohtvc =
        (ZPPOrderHistoryTVC *)[self firstRealVCFormStoryBoardWithName:@"orderHistory"];

    [ohtvc configureWithOrder:self.order];

    [self presentViewController:ohtvc.navigationController animated:YES completion:nil];

    // UINavigationController *nvc =
}

- (void)showPromoCodeInput {
    [self dissmisMenu];

    [self showVCFromStoryboardWithName:@"promocode"];
}

- (void)showOrder {
    //[self showVCFromStoryboardWithName:@"order"];
    //    UINavigationController *initial =
    //        (UINavigationController *)[self initialVCForStoryboardWithName:@"order"];

    ZPPOrderTVC *orderTVC = (ZPPOrderTVC *)
        [self firstRealVCFormStoryBoardWithName:@"order"];  //[initial.viewControllers firstObject];

    [orderTVC configureWithOrder:self.order];

    [self presentViewController:orderTVC.navigationController
                       animated:YES
                     completion:^{

                     }];
}

- (void)showMyCards {
    [self dissmisMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"order" bundle:nil];
    UIViewController *vc =
        [storyboard instantiateViewControllerWithIdentifier:@"ZPPCardViewControllerIdentifier"];

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];

    [self presentViewController:nvc animated:YES completion:nil];
}

- (UIViewController *)firstRealVCFormStoryBoardWithName:(NSString *)storyboardName {
    UINavigationController *nvc =
        (UINavigationController *)[self initialVCForStoryboardWithName:storyboardName];

    UIViewController *vc = [nvc.viewControllers firstObject];

    return vc;
}

- (void)showVCFromStoryboardWithName:(NSString *)storyboardName {
    // UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];

    UIViewController *vc = [self
        initialVCForStoryboardWithName:storyboardName];  //[sb instantiateInitialViewController];

    [self presentViewController:vc
                       animated:YES
                     completion:^{

                     }];
}

- (UIViewController *)initialVCForStoryboardWithName:(NSString *)storyboardName {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    return vc;
}

#pragma mark - support

- (void)showViewWithAnimation {
    if(self.animationShoved){
        return;
    }
    
    self.animationShoved = YES;
    
    CGRect r = [UIScreen mainScreen].bounds;
    UIView *v = [[UIView alloc] initWithFrame:r];
    v.backgroundColor = [UIColor whiteColor];
    
    CGFloat offset = 24;
    CGFloat len = r.size.width - offset*2;

    CGRect ivr = CGRectMake(offset, (r.size.height - len) / 2.0, len, len);

    UIImageView *iv = [[UIImageView alloc] initWithFrame:ivr];
    iv.image = [UIImage imageNamed:@"iconBigColor"];
    [v addSubview:iv];

    CGRect btmr = CGRectMake(len * 0.272, 0.867 * len, 0.75 * len, 0.13 * len);
    CGRect upr = CGRectMake(len * 0.13, 0.706 * len, len, 0.13 * len);
    UIView *bottomView = [[UIView alloc] initWithFrame:btmr];
    UIView *upperrView = [[UIView alloc] initWithFrame:upr];

    bottomView.backgroundColor = [UIColor whiteColor];
    upperrView.backgroundColor = [UIColor whiteColor];
    [iv addSubview:bottomView];
    [iv addSubview:upperrView];

    [self.view addSubview:v];

    [UIView animateWithDuration:1
                     animations:^{
                         CGRect nbtmr = bottomView.frame;
                         nbtmr.origin.x = len;
                         bottomView.frame = nbtmr;  // CGRectMake(<#CGFloat x#>, <#CGFloat y#>,
                                                    // <#CGFloat width#>, <#CGFloat height#>)

                         CGRect nupr = upperrView.frame;
                         nupr.origin.x = len;
                         upperrView.frame = nupr;

                     } completion:^(BOOL finished) {
                         [v removeFromSuperview];
                     }];
}

#pragma mark - ordrer

- (void)addItemIntoOrder:(id<ZPPItemProtocol>)item {
    [self.order addItem:item];

    [self showOrderButton];

    [self updateBadge];
}

- (void)updateBadge {
    if (_order) {
        if ([self.order totalCount]) {
            [self showOrderButton];
            self.badgeView.badgeText =
                [NSString stringWithFormat:@"%@", @([self.order totalCount])];
        } else {
            self.badgeView.badgeText = nil;
            [self hideOrderButton];
        }
    }
}

#pragma mark - no internet connection delegate

- (void)tryAgainSender:(id)sender {
}

#pragma mark - lazy

- (ZPPMainMenuView *)mainMenu {
    if (!_mainMenu) {
        NSString *nibName = NSStringFromClass([ZPPMainMenuView class]);
        _mainMenu =
            [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
        CGSize s = [UIScreen mainScreen].bounds.size;
        _mainMenu.frame = CGRectMake(0, -s.height, s.width, s.height);

        [_mainMenu.profileButton addTarget:self
                                    action:@selector(showProfile)
                          forControlEvents:UIControlEventTouchUpInside];

        [_mainMenu.helpButton addTarget:self
                                 action:@selector(showHelp)
                       forControlEvents:UIControlEventTouchUpInside];

        [_mainMenu.giftCardButton addTarget:self
                                     action:@selector(showGifts)
                           forControlEvents:UIControlEventTouchUpInside];

        [_mainMenu.ordersButton addTarget:self
                                   action:@selector(showOrderHistory)
                         forControlEvents:UIControlEventTouchUpInside];

        [_mainMenu.promoButton addTarget:self
                                  action:@selector(showPromoCodeInput)
                        forControlEvents:UIControlEventTouchUpInside];

        [_mainMenu.myCardsButton addTarget:self
                                    action:@selector(showMyCards)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainMenu;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        CGRect r = CGRectMake(15, 15, kZPPButtonDiametr, kZPPButtonDiametr);
        _buttonView = [[UIView alloc] initWithFrame:r];
        _buttonView.backgroundColor = [UIColor blackColor];
        _buttonView.layer.borderWidth = self.button.lineThickness;
        _buttonView.layer.borderColor = [UIColor whiteColor].CGColor;
        _buttonView.layer.cornerRadius = _buttonView.frame.size.height / 2.0;

        [_buttonView addSubview:self.button];

        CGSize buttonSize = self.button.frame.size;
        self.button.frame = CGRectMake((r.size.width - buttonSize.width) / 2.0,
                                       (r.size.height - buttonSize.height) / 2.0, buttonSize.width,
                                       buttonSize.width);  // = _buttonView.center;

        UITapGestureRecognizer *gr =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonWork)];
        gr.numberOfTapsRequired = 1;
        gr.numberOfTouchesRequired = 1;
        [_buttonView addGestureRecognizer:gr];

        [_buttonView addSubview:self.button];
    }
    return _buttonView;
}

- (VBFPopFlatButton *)button {
    if (!_button) {
        _button = [[VBFPopFlatButton alloc]
                    initWithFrame:CGRectMake(0, 0, kZPPButtonDiametr / 2.0, kZPPButtonDiametr / 2.0)
                       buttonType:buttonMenuType
                      buttonStyle:buttonRoundedStyle
            animateToInitialState:YES];

        [_button addTarget:self
                      action:@selector(buttonWork)
            forControlEvents:UIControlEventTouchUpInside];
        _button.exclusiveTouch = YES;

        // _button.center = self.buttonView.center;
    }

    return _button;
}

- (UIView *)orderView {
    if (!_orderView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGRect r = CGRectMake(screenSize.width - kZPPButtonDiametr - kZPPButtonOffset,
                              -kZPPButtonOffset, kZPPButtonDiametr, kZPPButtonDiametr);

        _orderView = [[UIView alloc] initWithFrame:r];

        _orderView.layer.cornerRadius = _orderView.frame.size.height / 2.0;
        //  _orderView.layer.borderWidth = self.button.lineThickness;
        //  _orderView.layer.borderColor = [UIColor whiteColor].CGColor;
        _orderView.backgroundColor = [UIColor blackColor];

        CAShapeLayer *_border = [CAShapeLayer layer];
        _border.lineWidth = self.button.lineThickness;
        _border.strokeColor = [UIColor whiteColor].CGColor;
        _border.fillColor = nil;
        [_orderView.layer addSublayer:_border];
        _border.path = [UIBezierPath bezierPathWithRoundedRect:_orderView.bounds
                                                  cornerRadius:_orderView.frame.size.height / 2.0]
                           .CGPath;

        UIImageView *iv = [[UIImageView alloc]
            initWithFrame:CGRectMake(kZPPButtonDiametr / 4.0, kZPPButtonDiametr / 4.0,
                                     kZPPButtonDiametr / 2.0, kZPPButtonDiametr / 2.0)];

        iv.image = [UIImage imageNamed:@"order"];

        self.badgeView =
            [[JSBadgeView alloc] initWithParentView:iv alignment:JSBadgeViewAlignmentTopRight];

        self.badgeView.badgePositionAdjustment = CGPointMake(4, -4);

        if ([self.order totalCount]) {
            self.badgeView.badgeText =
                [NSString stringWithFormat:@"%@", @([self.order totalCount])];
        }

        [_orderView addSubview:iv];

        [iv bringSubviewToFront:self.badgeView];

        UITapGestureRecognizer *tapGR =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrder)];
        tapGR.numberOfTapsRequired = 1;
        tapGR.numberOfTouchesRequired = 1;
        [_orderView addGestureRecognizer:tapGR];
    }

    return _orderView;
}

- (ZPPOrder *)order {
    if (!_order) {
        _order = [[ZPPOrder alloc] init];
    }

    return _order;
}

@end
