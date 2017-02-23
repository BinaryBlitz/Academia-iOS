#import "ZPPOrderItemVC.h"

@import VBFPopFlatButton;
@import MBProgressHUD;
#import "ZPPOrder.h"
#import "ZPPOrderItem.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "ZPPConsts.h"

@interface ZPPOrderItemVC ()

@property (strong, nonatomic) ZPPOrder *order;
@property (strong, nonatomic) ZPPOrderItem *orderItem;

@end

@implementation ZPPOrderItemVC

- (void)viewDidLoad {
  [super viewDidLoad];

  [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.minusButton addTarget:self
                       action:@selector(removeItem)
             forControlEvents:UIControlEventTouchUpInside];

  [self.plusButton addTarget:self
                      action:@selector(addItem)
            forControlEvents:UIControlEventTouchUpInside];

  [self.deleteButton addTarget:self
                        action:@selector(deleteItem)
              forControlEvents:UIControlEventTouchUpInside];
  [self.doneButton addTarget:self
                      action:@selector(saveItem)
            forControlEvents:UIControlEventTouchUpInside];

  [self.doneButton setExclusiveTouch:YES];
  [self.deleteButton setExclusiveTouch:YES];

  [self.plusButton makeBordered];
  [self.minusButton makeBordered];
  self.plusButton.layer.cornerRadius = 35.0;
  self.minusButton.layer.cornerRadius = 35.0;

  [self updateScreen];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [self.order checkAllAndRemoveEmpty];
}

- (void)configureWithOrder:(ZPPOrder *)order item:(ZPPOrderItem *)orderItem {
  self.order = order;
  self.orderItem = orderItem;

  [self updateScreen];
}

- (void)updateScreen {
  self.nameLabel.text = [self.orderItem.item nameOfItem];
  self.countLabel.text = [NSString stringWithFormat:@"%@", @(self.orderItem.count)];
  self.priceLabel.text =
      [NSString stringWithFormat:@"%@%@", @(self.orderItem.totalPrice), ZPPRoubleSymbol];

  if (self.orderItem.count <= 0) {
    self.minusButton.enabled = NO;
  } else {
    self.minusButton.enabled = YES;
  }
}

- (void)removeItem {
  [self.orderItem removeOneItem];
  [self updateScreen];
}

- (void)addItem {
  [self.orderItem addOneItem];
  [self updateScreen];
}

- (void)saveItem {
  [self popBackWithText:@"Сохранено"];
}

- (void)deleteItem {
  [self.order.items removeObject:self.orderItem];

  [self popBackWithText:@"Удалено"];
}

- (void)popBackWithText:(NSString *)text {
  [self showSuccessWithText:text];

  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self.navigationController popViewControllerAnimated:YES];
      });
}

- (void)showSuccessWithText:(NSString *)text {
  VBFPopFlatButton *button = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)
                                                          buttonType:buttonOkType
                                                         buttonStyle:buttonPlainStyle
                                               animateToInitialState:YES];

  MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
  [self.navigationController.view addSubview:hud];
  hud.customView = button;
  hud.label.text = text;
  hud.mode = MBProgressHUDModeCustomView;
  [hud showAnimated:YES];
  [hud hideAnimated:YES afterDelay:2];
}

@end
