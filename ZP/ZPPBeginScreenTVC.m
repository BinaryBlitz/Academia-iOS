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
#import "NSDate+ZPPDateCategory.h"

#import "ZPPUserManager.h"

#import "ZPPTimeManager.h"

@import DateTools;

typedef NS_ENUM(NSInteger, ZPPCurrentBeginState) {
    ZPPCurrentBeginStateClosed,
    ZPPCurrentBeginStateOpen,
    ZPPCurrentBeginStateNotLoged
};

typedef NS_ENUM(NSInteger, ZPPCurrentDayNightState) {
    ZPPCurrentDayNightStateMorning,
    ZPPCurrentDayNightStateNight,
    ZPPCurrentDayNightStateDay
};

static NSString *ZPPBeginScreenCellIdentifier = @"ZPPBeginScreenCellIdentifier";

@interface ZPPBeginScreenTVC ()

@end

@implementation ZPPBeginScreenTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.alwaysBounceVertical = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPBeginScreenCell *cell =
        [tableView dequeueReusableCellWithIdentifier:ZPPBeginScreenCellIdentifier];

    [cell.beginButton makeBorderedWithColor:[UIColor whiteColor]];

    cell.contentView.backgroundColor = [UIColor blackColor];

    cell.backImageView.image = [UIImage imageNamed:@"back3.jpg"];
    if ([ZPPTimeManager sharedManager].dishesForToday || [self currentState] == ZPPCurrentBeginStateNotLoged) {
        [cell.beginButton setTitle:[self buttonText] forState:UIControlStateNormal];
    } else {
        cell.beginButton.hidden = YES;
    }
    cell.descrLabel.text = [self descrBottomText];
    cell.upperDescrLabel.text = [self descrUpperText];

    [cell.beginButton addTarget:self
                         action:@selector(beginButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];

    ZPPCurrentBeginState state = [self currentState];

    if (state == ZPPCurrentBeginStateClosed) {
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

- (void)registerCells {
    UINib *infoCell = [UINib nibWithNibName:@"ZPPBeginScreenCell" bundle:nil];
    [[self tableView] registerNib:infoCell forCellReuseIdentifier:ZPPBeginScreenCellIdentifier];
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
    NSString *dayString = @"Добрый день, ";
    NSString *eveningString = @"Добрый вечер, ";
    NSString *userName = [ZPPUserManager sharedInstance].user.firstName;
    NSDate *d = [NSDate new];

    switch (state) {
        case ZPPCurrentBeginStateOpen:
            break;
        case ZPPCurrentBeginStateClosed:
            if ([d hour] < 6) {
                text = [NSString stringWithFormat:@"%@%@", nightString, userName];
            } else if ([d hour] < 11) {
                text = [NSString stringWithFormat:@"%@%@", morningString, userName];
            } else if ([d hour] < 19) {
                text = [NSString stringWithFormat:@"%@%@", dayString, userName];
            } else {
                text = [NSString stringWithFormat:@"%@%@", eveningString, userName];
            }
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

    NSDate *openDate = [ZPPTimeManager sharedManager].openTime;
    
    NSString *makePreorder = @"";
    if ([ZPPTimeManager sharedManager].openTime) {
        NSLog(@"open time: %@", [ZPPTimeManager sharedManager].openTime);
        NSString *dateString = @"";
        if ([openDate isTomorrow]) {
            dateString = @"завтра";
        } else if ([openDate isToday]) {
            dateString = @"сегодня";
        } else {
            NSArray *weekdays = @[@"в воскресенье", @"в понедельник", @"во вторник", @"в среду", @"в четверг", @"в пятницу", @"в субботу"];
            NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:openDate];
            if (weekday > 0) {
                dateString = weekdays[weekday - 1];
            }
        }
        
         makePreorder = [NSString stringWithFormat:@"Сейчас мы закрыты. Мы открываемся %@ в %@", dateString, [openDate timeStringfromDate]];
    }
    
    switch (state) {
        case ZPPCurrentBeginStateOpen:
            break;
        case ZPPCurrentBeginStateClosed:
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
    NSString *text = @"ВОЙТИ";

    ZPPCurrentBeginState state = [self currentState];

    switch (state) {
        case ZPPCurrentBeginStateOpen:
            text = @"ПОСМОТРЕТЬ МЕНЮ";
            break;
        case ZPPCurrentBeginStateClosed:
            text = @"СДЕЛАТЬ ПРЕДЗАКАЗ";
            break;
        case ZPPCurrentBeginStateNotLoged:

        default:
            break;
    }
    return text;
}

- (ZPPCurrentBeginState)currentState {
    // return ZPPCurrentBeginStateNotLoged;

    //    NSDate *now = [ZPPTimeManager sharedManager].currentTime;  //[NSDate new];
    //    NSDate *openTime = [ZPPTimeManager sharedManager].openTime;

    if (![[ZPPUserManager sharedInstance] checkUser]) {
        return ZPPCurrentBeginStateNotLoged;
    } else if (![ZPPTimeManager sharedManager].isOpen) {
        return ZPPCurrentBeginStateClosed;
    } else {
        return ZPPCurrentBeginStateOpen;
    }
}

@end
