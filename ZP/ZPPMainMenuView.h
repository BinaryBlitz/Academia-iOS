#import <UIKit/UIKit.h>

@interface ZPPMainMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *promoButton;
@property (weak, nonatomic) IBOutlet UIButton *giftCardButton;
@property (weak, nonatomic) IBOutlet UIButton *ordersButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *myCardsButton;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dishesCategoryButtons;


- (void)showCompletion:(void (^)())completion;
- (void)dismissCompletion:(void (^)())completion;

@end
