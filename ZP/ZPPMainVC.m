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

// libs
#import <VBFPopFlatButton.h>

static float kZPPButtonDiametr = 40.0f;
static float kZPPButtonOffset = 15.0f;

@interface ZPPMainVC ()
@property (strong, nonatomic) VBFPopFlatButton *menuButton;
@property (strong, nonatomic) ZPPMainMenuView *mainMenu;
@property (strong, nonatomic) VBFPopFlatButton *button;
@property (strong, nonatomic) UIView *buttonView;
@property (strong, nonatomic) UIView *orderView;

@property (assign, nonatomic) BOOL menuShowed;

@property (strong, nonatomic) ZPPOrder *order;
@end

@implementation ZPPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    //    if([[ZPPUserManager sharedInstance] checkUser]){
    //        [self.view addSubview:self.mainMenu];
    //        [self.view addSubview:self.buttonView];
    //    } else {
    //        if([self.view.subviews containsObject:self.mainMenu]) {
    //            [self.mainMenu removeFromSuperview];
    //        }
    //        if([self.view.subviews containsObject:self.buttonView]) {
    //            [self.buttonView removeFromSuperview];
    //        }
    //    }
    //[self.view addSubview:self.mainMenu];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[ZPPUserManager sharedInstance] checkUser]) {
        [self.view addSubview:self.mainMenu];
        [self.view addSubview:self.buttonView];
    } else {
        if ([self.view.subviews containsObject:self.mainMenu]) {
            [self.mainMenu removeFromSuperview];
        }
        if ([self.view.subviews containsObject:self.buttonView]) {
            [self.buttonView removeFromSuperview];
        }
    }
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
    if(![self.view.subviews containsObject:self.orderView]) {
        [self.view addSubview:self.orderView];
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

- (void)showProfile {
    [self dissmisMenu];

    [self showVCFromStoryboardWithName:@"profile"];
}

- (void)showHelp {
    [self dissmisMenu];

    [self showVCFromStoryboardWithName:@"help"];
}

- (void)showOrder {
    [self showVCFromStoryboardWithName:@"order"];
}

- (void)showVCFromStoryboardWithName:(NSString *)storyboardName {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];

    UIViewController *vc = [sb instantiateInitialViewController];

    [self presentViewController:vc
                       animated:YES
                     completion:^{

                     }];
}

- (void)addItemIntoOrder:(id<ZPPItemProtocol>)item {
    [self.order addItem:item];
    [self showOrderButton];
    
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
        _orderView.layer.borderWidth = self.button.lineThickness;
        _orderView.layer.borderColor = [UIColor whiteColor].CGColor;
        _orderView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrder)];
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
