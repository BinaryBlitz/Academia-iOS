//
//  ZPPProductEnergyCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 10/12/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ZPPProductEnergyCellIdentifier;

@class ZPPDish;

@interface ZPPProductEnergyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *proteinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatsLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbohydratesLabel;
@property (weak, nonatomic) IBOutlet UILabel *kilocaloriesLabel;

- (void)configureWithDish:(ZPPDish *)dish;

@end
