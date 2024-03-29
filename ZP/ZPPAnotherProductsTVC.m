#import "ZPPAnotherProductsTVC.h"

#import "ZPPProductAnotherCell.h"
#import "ZPPProductMainCell.h"
#import "ZPPStuff.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPOrder.h"
#import "ZPPOrderItem.h"

static NSString *ZPPProductAnotherCellIdentifier = @"ZPPProductAnotherCellIdentifier";
static NSString *ZPPProductMainCellIdentifier = @"ZPPProductsMainCellIdentifier";

static NSString *ZPPControllerName = @"ДОПОЛНИ СВОЙ ЛАНЧ!";
static NSString *ZPPControllerDescrioption = @"НАПИТКИ / ДЕСЕРТЫ";

@interface ZPPAnotherProductsTVC ()

@property (strong, nonatomic) NSArray *anotherProducts;
@property (strong, nonatomic) ZPPOrder *order;

@end

@implementation ZPPAnotherProductsTVC

- (void)viewDidLoad {
  [super viewDidLoad];
  UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
  [headerView setBackgroundColor:[UIColor whiteColor]];
  [self.tableView setTableHeaderView:headerView];
}

- (void)configureWithOrder:(ZPPOrder *)order {
  self.order = order;
}

- (void)configureWithStuffs:(NSArray *)stuffs {
  self.anotherProducts = stuffs;
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.anotherProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self anotherProductCellForIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 120.0;
}

- (ZPPProductAnotherCell *)anotherProductCellForIndexPath:(NSIndexPath *)indexPath {
  ZPPProductAnotherCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ZPPProductAnotherCellIdentifier];

  ZPPStuff *stuff = self.anotherProducts[indexPath.row];

  ZPPOrderItem *orderItem = [self.order orderItemForItem:stuff];

  if (orderItem) {
    [cell setBadgeCount:orderItem.count];
  } else {
    [cell setBadgeCount:0];
  }

  [cell configureWithStuff:stuff];
  [cell.addProductButton addTarget:self action:@selector(addToCard:) forControlEvents:UIControlEventTouchUpInside];

  return cell;
}

- (ZPPProductMainCell *)mainCell {
  ZPPProductMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ZPPProductMainCellIdentifier];

  [cell setTitle:ZPPControllerName];
  cell.ingridientsDescriptionLabel.text = ZPPControllerDescrioption;
  cell.priceLabel.text = @"";
  [cell.addToBasketButton addTarget:self
                             action:@selector(showAnotherCells)
                   forControlEvents:UIControlEventTouchUpInside];
  [cell.addToBasketButton setTitle:@"ПОСМОТРЕТЬ" forState:UIControlStateNormal];

  cell.topButtonView.hidden = NO;

  cell.ingridientsDescriptionLabel.numberOfLines = 1;
  cell.ingridientsDescriptionLabel.minimumScaleFactor = 0.5;
  cell.ingridientsDescriptionLabel.adjustsFontSizeToFitWidth = YES;
  cell.productImageView.image = [UIImage imageNamed:@"back4.jpg"];

  return cell;
}

- (void)registerCells {
  UINib *anotherCell = [UINib nibWithNibName:@"ZPPProductAnotherCell" bundle:nil];
  [[self tableView] registerNib:anotherCell
         forCellReuseIdentifier:ZPPProductAnotherCellIdentifier];

  UINib *main = [UINib nibWithNibName:@"ZPPProductMainCell" bundle:nil];
  [[self tableView] registerNib:main forCellReuseIdentifier:ZPPProductMainCellIdentifier];
}

#pragma mark - actions

- (void)showAnotherCells {  // redo
  NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];

  if (self.anotherProducts.count < 1) {
    return;
  }

  [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)addToCard:(UIButton *)sender {
  UITableViewCell *cell = [self parentCellForView:sender];

  if (cell) {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];

    ZPPStuff *stuff = self.anotherProducts[ip.row];

    if (self.productDelegate) {
      [self.productDelegate addItemIntoOrder:stuff];
    }
  }

  [self.tableView reloadData];
}
@end
