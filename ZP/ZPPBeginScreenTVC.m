//
//  ZPPBeginScreenTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPBeginScreenTVC.h"
#import "ZPPBeginScreenCell.h"
#import "UIView+UIViewCategory.h"

#import "ZPPUserManager.h"

#import <DateTools.h>

typedef NS_ENUM(NSInteger, ZPPCurrentBeginState) {
    ZPPCurrentBeginStateNight,
    ZPPCurrentBeginStateMorning,
    ZPPCurrentBeginStateOpen,
    ZPPCurrentBeginStateNotLoged
};

static NSString *ZPPBeginScreenCellIdentifier = @"ZPPBeginScreenCellIdentifier";

@interface ZPPBeginScreenTVC ()

@end

@implementation ZPPBeginScreenTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.alwaysBounceVertical = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPBeginScreenCell *cell =
        [tableView dequeueReusableCellWithIdentifier:ZPPBeginScreenCellIdentifier];

    //    cell.beginButton.layer.borderWidth = 2.0;
    //    cell.beginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [cell.beginButton makeBorderedWithColor:[UIColor whiteColor]];

    cell.contentView.backgroundColor = [UIColor blackColor];

    cell.backImageView.image = [UIImage imageNamed:@"back3"];
    [cell.beginButton setTitle:[self buttonText] forState:UIControlStateNormal];
    cell.descrLabel.text = [self descrBottomText];
    cell.upperDescrLabel.text = [self descrUpperText];

    [cell.beginButton addTarget:self
                         action:@selector(beginButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    
    ZPPCurrentBeginState state = [self currentState];
    
    if(state == ZPPCurrentBeginStateMorning || state == ZPPCurrentBeginStateNight) {
        cell.logoImageView.hidden = YES;
        cell.smallImageView.hidden = NO;
    } else {
        cell.logoImageView.hidden = NO;
        cell.smallImageView.hidden = YES;
    }
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.screenHeight;
}

- (void)registreCells {
    UINib *anotherCell = [UINib nibWithNibName:@"ZPPBeginScreenCell" bundle:nil];
    [[self tableView] registerNib:anotherCell forCellReuseIdentifier:ZPPBeginScreenCellIdentifier];
}

- (void)beginButtonAction:(UIButton *)sender {
    if (self.beginDelegate &&
        [self.beginDelegate conformsToProtocol:@protocol(ZPPBeginScreenTVCDelegate)]) {
        [self.beginDelegate didPressBeginButton];
    }
}

- (NSString *)descrUpperText {
    NSString *text = @"";

    ZPPCurrentBeginState state = [self currentState];

    NSString *morningString = @"Доброе утро, ";
    NSString *nightString = @"Доброй ночи, ";
    NSString *userName = [ZPPUserManager sharedInstance].user.firstName;

    switch (state) {
        case ZPPCurrentBeginStateOpen:

            break;
        case ZPPCurrentBeginStateMorning:
            text = [NSString stringWithFormat:@"%@%@", morningString, userName];
            break;
        case ZPPCurrentBeginStateNight:
            text = [NSString stringWithFormat:@"%@%@", nightString, userName];
            break;
        case ZPPCurrentBeginStateNotLoged:
            break;
        default:
            break;
    }
    return text;
}

- (NSString *)descrBottomText {
    NSString *text = @"";

    ZPPCurrentBeginState state = [self currentState];

    NSString *makePreorder = @"Мы открываемся в 11:00";

    switch (state) {
        case ZPPCurrentBeginStateOpen:
            break;
        case ZPPCurrentBeginStateMorning:
            text = makePreorder.copy;  //[makePreorder stringByAppendingString:@"11"];
            break;
        case ZPPCurrentBeginStateNight:
            text = makePreorder.copy;  //[makePreorder stringByAppendingString:@"11"];
            break;
        case ZPPCurrentBeginStateNotLoged:
            break;
        default:
            break;
    }
    return text;
}

- (NSString *)buttonText {
    NSString *text = @"НАЧАТЬ";

    ZPPCurrentBeginState state = [self currentState];

    NSString *makePreorder = @"СДЕЛАТЬ ПРЕДЗАКАЗ";

    switch (state) {
        case ZPPCurrentBeginStateOpen:
            text = @"ПОСМОТРЕТЬ МЕНЮ";

            break;
        case ZPPCurrentBeginStateMorning:
            text = makePreorder.copy;
            break;
        case ZPPCurrentBeginStateNight:
            text = makePreorder.copy;
            break;
        case ZPPCurrentBeginStateNotLoged:

        default:
            break;
    }
    return text;
}

- (ZPPCurrentBeginState)currentState {
    //return ZPPCurrentBeginStateNotLoged;
    
    NSDate *now = [NSDate new];

    if (![[ZPPUserManager sharedInstance] checkUser]) {
        return ZPPCurrentBeginStateNotLoged;
    } else if ([now hour] < 6) {
        return ZPPCurrentBeginStateNight;
    } else if ([now hour] < 11) {
        return ZPPCurrentBeginStateMorning;
    } else {
        return ZPPCurrentBeginStateOpen;
    }
}

@end
