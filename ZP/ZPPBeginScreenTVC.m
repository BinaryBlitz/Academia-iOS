//
//  ZPPBeginScreenTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPBeginScreenTVC.h"

@import SDWebImage;
@import DateTools;
@import PureLayout;
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ZPPBeginScreenCell.h"
#import "UIView+UIViewCategory.h"
#import "NSDate+ZPPDateCategory.h"
#import "ZPPUserManager.h"
#import "ZPPTimeManager.h"
#import "Academia-Swift.h"

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

  if ([[WelcomeScreenProvider sharedProvider] hasAvailableScreen]) {
    [self loadImageView:cell.backImageView url:[WelcomeScreenProvider sharedProvider].imageURL];
  } else {
    cell.backImageView.image = [UIImage imageNamed:@"back3.jpg"];
  }

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
    cell.logoImageView.hidden = YES;
    cell.smallImageView.hidden = YES;
  }

  if ([[WelcomeScreenProvider sharedProvider] hasAvailableScreen]) {
    cell.logoImageView.hidden = YES;
    cell.smallImageView.hidden = YES;
  }

  if (state == ZPPCurrentBeginStateNotLoged) {
    cell.showMenuPreviewButton.hidden = false;
    [cell.showMenuPreviewButton makeBorderedWithColor:[UIColor whiteColor]];

    [cell.showMenuPreviewButton addTarget:self
                                   action:@selector(previewButtonAction:)
                         forControlEvents:UIControlEventTouchUpInside];
  } else {
    cell.showMenuPreviewButton.hidden = true;
  }

  return cell;
}

#pragma mark - img load

- (void)loadImageView:(UIImageView *)imgView url:(NSURL *)url {
  SDWebImageManager *manager = [SDWebImageManager sharedManager];
  [manager downloadImageWithURL:url options:0 progress:nil
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (image) {
                          imgView.image = image;
                        }
                      }];
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

- (void)previewButtonAction:(UIButton *)sender {
  if (self.beginDelegate &&
      [self.beginDelegate conformsToProtocol:@protocol(ZPPBeginScreenTVCDelegate)]) {
    [self.beginDelegate showMenuPreview];
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
      if ([[WelcomeScreenProvider sharedProvider] hasAvailableScreen]) {
        return nil;
      }
      break;
    case ZPPCurrentBeginStateClosed:
      if ([[WelcomeScreenProvider sharedProvider] hasAvailableScreen]) {
        return nil;
      }
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
      if ([[WelcomeScreenProvider sharedProvider] hasAvailableScreen]) {
        return nil;
      }
      break;
    case ZPPCurrentBeginStateClosed:
      if ([[WelcomeScreenProvider sharedProvider] hasAvailableScreen]) {
        return nil;
      }
      text = makePreorder.copy;
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
      break;
    default:
      break;
  }

  return text;
}

- (ZPPCurrentBeginState)currentState {
  if (![[ZPPUserManager sharedInstance] checkUser]) {
    return ZPPCurrentBeginStateNotLoged;
  } else if (![ZPPTimeManager sharedManager].isOpen) {
    return ZPPCurrentBeginStateClosed;
  } else {
    return ZPPCurrentBeginStateOpen;
  }
}

@end
