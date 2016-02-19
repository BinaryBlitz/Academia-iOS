//
//  ZPPCardInputTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardInputTVC.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"

#import "ZPPCreditCard.h"

#import "ZPPCardNumberInputCell.h"
#import "ZPPCardDateCodeCell.h"
#import "ZPPNoCreditCardCell.h"

#import "ZPPConsts.h"

//#import <BKCardNumberField.h>
//#import "BKCardExpiryField.h"

@import BKMoneyKit;

static NSString *ZPPCardNumberInputCellIdentifier = @"ZPPCardNumberInputCellIdentifier";
static NSString *ZPPCardDateCodeCellIdentifier = @"ZPPCardDateCodeCellIdentifier";
static NSString *ZPPNoCreditCardCellIdentifier = @"ZPPNoCreditCardCellIdentifier";

@interface ZPPCardInputTVC ()

@property (strong, nonatomic) BKCardNumberField *cardNumberField;
@property (strong, nonatomic) BKCardExpiryField *expiryField;
@property (strong, nonatomic) UITextField *cvcField;

@end

@implementation ZPPCardInputTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self setCustomNavigationBackButtonWithTransition];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    [self registrateCellForClass:[ZPPCardNumberInputCell class]
                 reuseIdentifier:ZPPCardNumberInputCellIdentifier];
    [self registrateCellForClass:[ZPPCardDateCodeCell class]
                 reuseIdentifier:ZPPCardDateCodeCellIdentifier];
    [self registrateCellForClass:[ZPPNoCreditCardCell class]
                 reuseIdentifier:ZPPNoCreditCardCellIdentifier];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZPPCardNumberInputCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPCardNumberInputCellIdentifier];
        self.cardNumberField = cell.cardNumberTextField;

        return cell;
    } else if (indexPath.section == 1) {
        ZPPCardDateCodeCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPCardDateCodeCellIdentifier];
        self.expiryField = cell.dateTextField;

        return cell;
    } else {
        ZPPNoCreditCardCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];

        [cell.actionButton setTitle:@"Сохранить карту" forState:UIControlStateNormal];

        [cell.actionButton addTarget:self
                              action:@selector(createCardAction)
                    forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    return nil;
}

//-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell
// forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if([cell isKindOfClass:[ZPPCardNumberInputCell class]]) {
//        ZPPCardNumberInputCell *c = (ZPPCardNumberInputCell *)cell;
//        self.cardNumber = c.cardNumberTextField.cardNumber;
//    }
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90.f;
    } else {
        return 50.f;
    }
}

#pragma mark - action

- (ZPPCreditCard *)createCard {
    NSString *cardNumber = self.cardNumberField.cardNumber;
    NSInteger month = self.expiryField.dateComponents.month;
    NSInteger year = self.expiryField.dateComponents.year;
    NSInteger cvc = self.cvcField.text.integerValue;

    ZPPCreditCard *card =
        [[ZPPCreditCard alloc] initWithCardNumber:cardNumber month:month year:year cvc:cvc];
    return card;
}

- (void)createCardAction {
    ZPPCreditCard *card = [self createCard];

    if (self.cardCreateDelegate) {
        [self.cardCreateDelegate cardCreated:card sender:self];
    }

    [self showSuccessWithText:@"Карта добавлена!"];

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                       [self.navigationController popViewControllerAnimated:YES];
                   });
}

//#pragma mark - new credit card delegate 
//
//- (void)cardCreated:(ZPPCreditCard *)address sender:(id)sender {
//    
//    self.ca
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
