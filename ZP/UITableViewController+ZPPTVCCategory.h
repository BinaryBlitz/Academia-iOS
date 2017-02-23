@import UIKit;

@interface UITableViewController (ZPPTVCCategory)

- (void)configureBackgroundWithImageWithName:(NSString *)imgName;
- (void)registrateCellForClass:(Class)class reuseIdentifier:(NSString *)reuseIdentifier;

@end
