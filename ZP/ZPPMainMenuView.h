#import <UIKit/UIKit.h>

@interface ZPPMainMenuView : UITableView



- (void)showCompletion:(void (^)())completion;
- (void)dismissCompletion:(void (^)())completion;

@end
