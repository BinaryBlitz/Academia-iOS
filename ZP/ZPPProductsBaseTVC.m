//
//  ZPPProductsBaseTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductsBaseTVC.h"

@interface ZPPProductsBaseTVC ()

@property (assign, nonatomic) CGFloat screenHeight;


@end

@implementation ZPPProductsBaseTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.tableView.backgroundColor = [UIColor blackColor];

    [self registreCells];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
}

- (void)registreCells {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(didScroll:)]) {
        [self.delegate didScroll:scrollView];
    }
}
@end
