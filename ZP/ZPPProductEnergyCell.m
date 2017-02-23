#import "ZPPProductEnergyCell.h"

#import "ZPPDish.h"
#import "ZPPEnergy.h"

NSString *const ZPPProductEnergyCellIdentifier = @"ZPPProductEnergyCellIdentifier";

@implementation ZPPProductEnergyCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)configureWithDish:(ZPPDish *)dish {
  ZPPEnergy *e = dish.energy;

  self.fatsLabel.text = e.fats.stringValue;
  self.carbohydratesLabel.text = e.carbohydrates.stringValue;
  self.kilocaloriesLabel.text = e.kilocalories.stringValue;
  self.proteinsLabel.text = e.proteins.stringValue;
}

@end
