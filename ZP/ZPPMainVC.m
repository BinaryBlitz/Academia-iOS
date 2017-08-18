#import "ZPPMainVC.h"

@import JSBadgeView;
@import VBFPopFlatButton;
#import "ZPPUserManager.h"
#import "ZPPMainMenuView.h"
#import "ZPPMainPageVC.h"
#import "Academia-Swift.h"
#import "ZPPCategory.h"
#import "ZPPGiftTVC.h"
#import "ZPPNoInternetConnectionVC.h"
#import "ZPPOrder.h"
#import "ZPPOrderHistoryTVC.h"
#import "ZPPOrderTVC.h"
#import "ZPPServerManager+ZPPRegistration.h"
#import "ZPPServerManager+ZPPDishesSeverManager.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPOrderManager.h"

static float kZPPButtonDiametr = 40.0f;
static float kZPPButtonOffset = 15.0f;

static NSString *embedPageVCSegueIdentifier = @"mainPageVCEmbed";
@interface ZPPMainVC () <ZPPNoInternetDelegate, ZPPMainMenuDelegate>

@property (strong, nonatomic) VBFPopFlatButton *menuButton;
@property (strong, nonatomic) ZPPMainMenuTableView *mainMenu;
@property (strong, nonatomic) VBFPopFlatButton *button;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UIView *orderView;
@property (strong, nonatomic) JSBadgeView *badgeView;
@property (strong, nonatomic) JSBadgeView *orderCountBadgeView;

@property (weak, nonatomic) ZPPMainPageVC *pageVC;

@property (assign, nonatomic) BOOL menuShowed;
@property (assign, nonatomic) BOOL animationShoved;

@end

@implementation ZPPMainVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.view addSubview:self.mainMenu];
  [self.view addSubview:self.buttonView];
  [self loadCategoriesIfNeeded];

  if ([[ZPPUserManager sharedInstance] checkUser]) {
    [[ZPPServerManager sharedManager] getCurrentUserOnSuccess:^(ZPPUser *user) {
          [ZPPUserManager sharedInstance].user.balance = user.balance;

          [self setUserBalance];
        }
                                                    onFailure:^(NSError *error, NSInteger statusCode) {
                                                    }];

    [self setOrderCount];

    [self setUserBalance];
    [self updateBadge];
  } else {
    [self removeAllAfterLogOut];
  }
  [self showViewWithAnimation];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didreceiveNotification:)
                                               name:ZPPUserLogoutNotificationName
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

//    [self showOnboarding];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:embedPageVCSegueIdentifier]) {
    ZPPMainPageVC *destVC =
    (ZPPMainPageVC *) segue.destinationViewController;
    self.pageVC = destVC;
  }
}

#pragma mark - ui

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)showRegistration {
  [self dissmisMenu];
  UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"registration" bundle:nil];

  UIViewController *theInitialViewController =
      [secondStoryBoard instantiateInitialViewController];

  [self presentViewController:theInitialViewController
                     animated:YES
                   completion:^{
                     
                   }];
}

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
  [self loadCategoriesIfNeeded];
  [self.button animateToType:buttonCloseType];
  [self.mainMenu show];

}

- (void)dissmisMenu {
  [self.button animateToType:buttonMenuType];
  self.menuShowed = NO;
  [self.mainMenu dismiss];
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
                   completion:^(BOOL finished) {
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

  ZPPGiftTVC *gtvc = (ZPPGiftTVC *) [self firstRealVCFormStoryBoardWithName:@"gifts"];

  [gtvc configureWithOrder:self.order];

  [self presentViewController:gtvc.navigationController animated:YES completion:nil];
}

- (void)showOrderHistory {
  [self dissmisMenu];

  ZPPOrderHistoryTVC *ohtvc =
      (ZPPOrderHistoryTVC *) [self firstRealVCFormStoryBoardWithName:@"orderHistory"];

  [ohtvc configureWithOrder:self.order];

  [self presentViewController:ohtvc.navigationController animated:YES completion:nil];
}

- (void)showPromoCodeInput {
  [self dissmisMenu];

  [self showVCFromStoryboardWithName:@"promocode"];
}

- (void)showOrder {
  ZPPOrderTVC *orderTVC = (ZPPOrderTVC *) [self firstRealVCFormStoryBoardWithName:@"order"];

  [orderTVC configureWithOrder:self.order];

  [self presentViewController:orderTVC.navigationController
                     animated:YES
                   completion:^{
                   }];
}

- (void)showOnboarding {
  static NSString *isShovedKey = @"onboardingShoved";
  if (![[NSUserDefaults standardUserDefaults] boolForKey:isShovedKey]) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isShovedKey];
    [self showVCFromStoryboardWithName:@"Onboarding"];
  }
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
      (UINavigationController *) [self initialVCForStoryboardWithName:storyboardName];

  UIViewController *vc = [nvc.viewControllers firstObject];

  return vc;
}

- (void)showVCFromStoryboardWithName:(NSString *)storyboardName {
  UIViewController *vc = [self initialVCForStoryboardWithName:storyboardName];

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

#pragma mark - notifications

- (void)didreceiveNotification:(NSNotification *)note {
  if ([note.name isEqualToString:ZPPUserLogoutNotificationName]) {
    [self removeAllAfterLogOut];
  }
}

#pragma mark - support

- (void)showViewWithAnimation {
  if (self.animationShoved) {
    return;
  }

  self.animationShoved = YES;

  CGRect r = [UIScreen mainScreen].bounds;
  UIView *v = [[UIView alloc] initWithFrame:r];
  UIColor *backgroundColor = [UIColor colorWithRed:254.0 / 255.0 green:238.0 / 255.0 blue:218.0 / 255.0 alpha:1.0];
  v.backgroundColor = backgroundColor;

  CGFloat offset = 24;
  CGFloat len = r.size.width - offset * 2;

  CGRect ivr = CGRectMake(offset, (r.size.height - len) / 2.0, len, len);

  UIImageView *iv = [[UIImageView alloc] initWithFrame:ivr];
  iv.backgroundColor = backgroundColor;
  iv.image = [UIImage imageNamed:@"iconBigColor"];
  [v addSubview:iv];

  CGRect btmr = CGRectMake(len * 0.272, 0.87 * len, 0.75 * len, 0.13 * len);
  CGRect upr = CGRectMake(len * 0.13, 0.706 * len, len, 0.18 * len);
  UIView *bottomView = [[UIView alloc] initWithFrame:btmr];
  UIView *upperrView = [[UIView alloc] initWithFrame:upr];

  bottomView.backgroundColor = backgroundColor;
  upperrView.backgroundColor = backgroundColor;
  [iv addSubview:bottomView];
  [iv addSubview:upperrView];

  [self.view addSubview:v];

  [UIView animateWithDuration:1
                   animations:^{
                     CGRect nbtmr = bottomView.frame;
                     nbtmr.origin.x = len;
                     bottomView.frame = nbtmr;
                     CGRect nupr = upperrView.frame;
                     nupr.origin.x = len;
                     upperrView.frame = nupr;
                   }
                   completion:^(BOOL finished) {
                     [v removeFromSuperview];
                   }];
}

- (void)loadCategoriesIfNeeded {
  if (self.mainMenu.categories.count == 0) {
    [[ZPPServerManager sharedManager] getDayMenu];
    [[ZPPServerManager sharedManager] getCategoriesOnSuccess:^(NSArray *categories) {
      self.mainMenu.categories = categories;
    } onFailure:^(NSError *error, NSInteger statusCode) {
    }];
  }
}

- (void)setUserBalance {
  self.mainMenu.balance = [ZPPUserManager sharedInstance].user.balance.integerValue;
}

- (void)removeAllAfterLogOut {
  if ([self.view.subviews containsObject:self.orderView]) {
    [self.orderView removeFromSuperview];
    _order = nil;
  }
}

#pragma mark - ordrer

- (void)addItemIntoOrder:(id <ZPPItemProtocol>)item {
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

#pragma mark - main menu delegate

- (void)didSelectCategory:(ZPPCategory *)category {
  [self dissmisMenu];
  if(self.pageVC) {
    [self.pageVC loadDishes:category];
  }
}

- (void)didSelectProfile {
  if (![[ZPPUserManager sharedInstance] checkUser]) {
    [self showRegistration];
  } else {
    [self showProfile];
  }
}

- (void)didSelectHelp {
  [self showHelp];
}

- (void)didSelectOrders {
  if (![[ZPPUserManager sharedInstance] checkUser]) {
    [self showRegistration];
  } else {
    [self showOrderHistory];
  }
}

- (void)setOrderCount {
  NSInteger c = [ZPPOrderManager sharedManager].onTheWayOrders.count;
  self.mainMenu.ordersCount = c;
  [[ZPPOrderManager sharedManager] updateOrdersCompletion:^(NSInteger count) {
    self.mainMenu.ordersCount = c;
  }];
}

#pragma mark - no internet connection delegate

- (void)tryAgainSender:(id)sender {
}

#pragma mark - lazy

- (ZPPMainMenuTableView *)mainMenu {
  if (!_mainMenu) {
    CGSize s = [UIScreen mainScreen].bounds.size;
    CGRect frame = CGRectMake(0, -s.height, s.width, s.height);
    ZPPMainMenuTableView* mainMenu = [[ZPPMainMenuTableView alloc] initWithFrame:frame];
    _mainMenu = mainMenu;
    mainMenu.menuDelegate = self;
  }
  return _mainMenu;
}

- (UIView *)buttonView {
  if (!_buttonView) {
    CGRect r = CGRectMake(15, 15, kZPPButtonDiametr, kZPPButtonDiametr);
    _buttonView = [[UIView alloc] initWithFrame:r];
    _buttonView.backgroundColor = [UIColor blackColor];
    _buttonView.layer.cornerRadius = _buttonView.frame.size.height / 2.0;

    CAShapeLayer *_border = [CAShapeLayer layer];
    _border.lineWidth = self.button.lineThickness;
    _border.strokeColor = [UIColor whiteColor].CGColor;
    _border.fillColor = nil;
    [_buttonView.layer addSublayer:_border];
    _border.path = [UIBezierPath bezierPathWithRoundedRect:_buttonView.bounds
                                              cornerRadius:_buttonView.frame.size.height / 2.0].CGPath;
    CGSize buttonSize = self.button.frame.size;
    self.button.frame = CGRectMake((r.size.width - buttonSize.width) / 2.0,
        (r.size.height - buttonSize.height) / 2.0, buttonSize.width,
        buttonSize.width);

    UITapGestureRecognizer *gr =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonWork)];
    gr.numberOfTapsRequired = 1;
    gr.numberOfTouchesRequired = 1;
    [_buttonView addGestureRecognizer:gr];

    [_buttonView addSubview:self.button];

    self.orderCountBadgeView =
        [[JSBadgeView alloc] initWithParentView:self.button
                                      alignment:JSBadgeViewAlignmentTopRight];
    self.orderCountBadgeView.badgePositionAdjustment = CGPointMake(4, -4);
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
