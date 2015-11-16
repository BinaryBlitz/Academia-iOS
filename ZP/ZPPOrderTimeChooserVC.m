//
//  ZPPOrderTimeChooserVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTimeChooserVC.h"

#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"

#import "ZPPOrder.h"

#import "ZPPConsts.h"

#import <DateTools.h>
#import "RMDateSelectionViewController.h"

#import "NSDate+ZPPDateCategory.h"

@interface ZPPOrderTimeChooserVC ()
@property (strong, nonatomic) ZPPOrder *order;
@property (strong, nonatomic) UIImageView *checkMark;

@end

@implementation ZPPOrderTimeChooserVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureButtons];

    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
}

- (void)viewWillAppear:(BOOL)animated {
    self.totalPriceLabel.text =
        [NSString stringWithFormat:@"%@%@", @(self.order.totalPrice), ZPPRoubleSymbol];
}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.order = order;
}

- (void)makeOrderAction:(UIButton *)sender {
}

- (void)orderNowAction:(UIButton *)sender {
    [self addCheckmarkToButton:sender];
}

- (void)orderAtTimeAction:(UIButton *)sender {
    [self addCheckmarkToButton:sender];
    [self showTimePicker];
}

- (void)configureButtons {
    [self.nowButton makeBordered];
    [self.atTimeButton makeBordered];
    [self.makeOrderButton makeBordered];

    [self.nowButton addTarget:self
                       action:@selector(orderNowAction:)
             forControlEvents:UIControlEventTouchUpInside];

    [self.atTimeButton addTarget:self
                          action:@selector(orderAtTimeAction:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.makeOrderButton addTarget:self
                             action:@selector(makeOrderAction:)
                   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - time picker

- (void)showTimePicker {
    RMAction *selectAction = [RMAction
        actionWithTitle:@"Выбрать"
                  style:RMActionStyleDone
             andHandler:^(RMActionController *controller) {

                 NSDate *d = ((UIDatePicker *)controller.contentView).date;
                 NSLog(@"Successfully selected date: %@",
                       ((UIDatePicker *)controller.contentView).date);
                 NSString *dateStr = [NSString
                     stringWithFormat:
                         @"К %@.%@ в ", @([d month]),
                         @([d day])];  //[d formattedDateWithStyle:NSDateFormatterShortStyle];

                 NSString *resString = [d timeStringfromDate];
                 resString = [dateStr stringByAppendingString:resString];
                 [self.atTimeButton setTitle:resString forState:UIControlStateNormal];
             }];

    // Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Отменить"
                                                 style:RMActionStyleCancel
                                            andHandler:^(RMActionController *controller) {
                                                NSLog(@"Date selection was canceled");
                                            }];

    // Create date selection view controller
    RMDateSelectionViewController *dateSelectionController =
        [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite
                                                    selectAction:selectAction
                                                 andCancelAction:cancelAction];

    dateSelectionController.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:30 * 60];

    dateSelectionController.title = @"Ко времени";
    dateSelectionController.message = @"Когда вы хотите получить заказ?";

    //    RMAction *in15MinAction = [RMAction actionWithTitle:@"15 Min"
    //    style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
    //        ((UIDatePicker *)controller.contentView).date = [NSDate
    //        dateWithTimeIntervalSinceNow:15*60];
    //        NSLog(@"15 Min button tapped");
    //    }];
    //    in15MinAction.dismissesActionController = NO;

    RMAction *in90MinAction = [RMAction
        actionWithTitle:@"90 минут"
                  style:RMActionStyleAdditional
             andHandler:^(RMActionController *controller) {
                 ((UIDatePicker *)controller.contentView).date =
                     [NSDate dateWithTimeIntervalSinceNow:90 * 60];
                 NSLog(@"90 Min button tapped");

                 [self.atTimeButton setTitle:@"Через 90 минут" forState:UIControlStateNormal];
             }];
    in90MinAction.dismissesActionController = YES;

    RMAction *in45MinAction = [RMAction
        actionWithTitle:@"45 минут"
                  style:RMActionStyleAdditional
             andHandler:^(RMActionController *controller) {
                 ((UIDatePicker *)controller.contentView).date =
                     [NSDate dateWithTimeIntervalSinceNow:45 * 60];
                 NSLog(@"45 Min button tapped");

                 [self.atTimeButton setTitle:@"Через 45 минут" forState:UIControlStateNormal];

             }];
    in45MinAction.dismissesActionController = YES;

    RMAction *in60MinAction = [RMAction
        actionWithTitle:@"60 минут"
                  style:RMActionStyleAdditional
             andHandler:^(RMActionController *controller) {
                 ((UIDatePicker *)controller.contentView).date =
                     [NSDate dateWithTimeIntervalSinceNow:60 * 60];
                 NSLog(@"60 Min button tapped");
                 [self.atTimeButton setTitle:@"Через 60 минут" forState:UIControlStateNormal];

             }];
    in60MinAction.dismissesActionController = YES;

    RMGroupedAction *groupedAction =
        [RMGroupedAction actionWithStyle:RMActionStyleAdditional
                              andActions:@[ in45MinAction, in60MinAction, in90MinAction ]];

    [dateSelectionController addAction:groupedAction];

    //    RMAction *nowAction = [RMAction
    //        actionWithTitle:@"Как можно скорее!"
    //                  style:RMActionStyleAdditional
    //             andHandler:^(RMActionController *controller) {
    //                 ((UIDatePicker *)controller.contentView).date =
    //                     [NSDate dateWithTimeIntervalSinceNow:30 * 60];
    //                 NSLog(@"Now button tapped");
    //
    //                 [self.atTimeButton setTitle:@"Как можно скорее!"
    //                 forState:UIControlStateNormal];
    //
    //             }];
    //  nowAction.dismissesActionController = YES;

    // [dateSelectionController addAction:nowAction];

    // Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

#pragma mark - support

- (void)addCheckmarkToButton:(UIButton *)b {
    if ([b.subviews containsObject:self.checkMark]) {
        return;
    } else {
        [self.checkMark removeFromSuperview];
        [b addSubview:self.checkMark];
    }
}

#pragma mark - lazy

- (UIImageView *)checkMark {
    if (!_checkMark) {
        CGRect r = self.nowButton.frame;
        CGFloat leng = r.size.height / 2.0;

        UIImageView *iv = [[UIImageView alloc]
            initWithFrame:CGRectMake(r.size.width - leng * 1.5f, (r.size.height - leng) / 2.0, leng,
                                     leng)];
        iv.image = [UIImage imageNamed:@"checkMark"];

        _checkMark = iv;
    }

    return _checkMark;
}

@end
