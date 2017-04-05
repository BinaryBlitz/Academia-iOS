#import "ZPPProductsBaseTVC.h"

@interface ZPPProductsBaseTVC ()

@property (assign, nonatomic) CGFloat screenHeight;


@end

@implementation ZPPProductsBaseTVC

- (void)viewDidLoad {
  [super viewDidLoad];

  self.screenHeight = [UIScreen mainScreen].bounds.size.height;
  self.tableView.backgroundColor = [UIColor blackColor];
  [self registerCells];

  UIView *v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  v.backgroundColor = [UIColor whiteColor];

  self.tableView.tableFooterView = v;

  UIEdgeInsets insets = self.tableView.contentInset;
  self.tableView.contentInset =
      UIEdgeInsetsMake(insets.top, insets.left, insets.bottom - self.screenHeight, insets.right);
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.shouldScrollToFirstRow) {
    [UIView animateWithDuration:0.8 animations:^{
      [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:NO];
      self.shouldScrollToFirstRow = NO;
    } completion:^(BOOL finished) {
      [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
    }];
  }
}


- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                        atScrollPosition:UITableViewScrollPositionTop
                                animated:NO];
}

- (void)registerCells {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if ([self.delegate respondsToSelector:@selector(didScroll:)]) {
    [self.delegate didScroll:scrollView];
  }
}
@end
