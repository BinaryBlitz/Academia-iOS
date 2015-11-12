//
//  ZPPCardViewController.m
//  ZP
//
//  Created by Andrey Mikhaylov on 02/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardViewController.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "ZPPAddNewCell.h"
#import "ZPPCreditCardInfoCell.h"

#import "ZPPCreditCard.h"

#import "ZPPCardInputTVC.h"

#import "ZPPConsts.h"

#import "UITableViewController+ZPPTVCCategory.h"

static NSString *ZPPAddNewCellIdentifier = @"ZPPAddNewCellIdentifier";
static NSString *ZPPCreditCardInfoCellIdentifier = @"ZPPCreditCardInfoCellIdentifier";

static NSString *ZPPCardInputTVCIdentifier = @"ZPPCardInputTVCIdentifier";

@interface ZPPCardViewController () <ZPPNewCreditCardDelegate>

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation ZPPCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registrateCells];
    [self setCustomNavigationBackButtonWithTransition];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self addCustomCloseButton];

    self.cards = [[self testCards] mutableCopy];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view
    // controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 1;
    } else {
        return self.cards.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView
    //    dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

    if (indexPath.section == 0) {
        ZPPAddNewCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:ZPPAddNewCellIdentifier];

        return cell;
    } else {
        ZPPCreditCardInfoCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPCreditCardInfoCellIdentifier];
        ZPPCreditCard *card = self.cards[indexPath.row];

        [cell configureWithCard:card];

        if (self.cardDelegate) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showCardInput];
    } else {
        ZPPCreditCard *c = self.cards[indexPath.row];
        [self didChooseCard:c];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - actions

- (void)showCardInput {
    ZPPCardInputTVC *vc = (ZPPCardInputTVC *)
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPCardInputTVCIdentifier];

    vc.cardCreateDelegate = self;

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didChooseCard:(ZPPCreditCard *)card {
    if (self.cardDelegate) {
        [self.cardDelegate configureWithCard:card sender:self];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    }
}

#pragma mark - new credit card delgate

- (void)cardCreated:(ZPPCreditCard *)card sender:(id)sender {
    [self.cards addObject:card];
    [self.tableView reloadData];
}

#pragma mark - support

- (void)registrateCells {
    [self registrateCellForClass:[ZPPAddNewCell class] reuseIdentifier:ZPPAddNewCellIdentifier];
    [self registrateCellForClass:[ZPPCreditCardInfoCell class]
                 reuseIdentifier:ZPPCreditCardInfoCellIdentifier];
}

#pragma mark - test card
// TEST

- (NSArray *)testCards {
    ZPPCreditCard *firstCard =
        [[ZPPCreditCard alloc] initWithCardNumber:@"4693951212341234" month:8 year:2016 cvc:111];
    ZPPCreditCard *secondCard =
        [[ZPPCreditCard alloc] initWithCardNumber:@"4545567887650987" month:10 year:2020 cvc:234];
    ZPPCreditCard *thirdCard =
        [[ZPPCreditCard alloc] initWithCardNumber:@"5547938465930202" month:1 year:2018 cvc:345];

    return @[ firstCard, secondCard, thirdCard ];
}

@end
