//
//  UITableViewController+ZPPTVCCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UITableViewController+ZPPTVCCategory.h"

@implementation UITableViewController (ZPPTVCCategory)

- (void)configureBackgroundWithImageWithName:(NSString *)imgName {
    CGRect r = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),
                          16 * CGRectGetWidth([UIScreen mainScreen].bounds) / 9);

    UIImageView *iv = [[UIImageView alloc] initWithFrame:r];

    iv.image = [UIImage imageNamed:imgName];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = iv;
}

- (void)registrateCellForClass:(Class) class reuseIdentifier:(NSString *)reuseIdentifier {
    NSString *className = NSStringFromClass(class);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

@end
