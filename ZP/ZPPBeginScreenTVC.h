#import "ZPPProductsBaseTVC.h"

@protocol ZPPBeginScreenTVCDelegate <NSObject>

- (void)didPressBeginButton;
- (void)showMenuPreview;
@end

@interface ZPPBeginScreenTVC : ZPPProductsBaseTVC

@property (nonatomic, weak) id <ZPPBeginScreenTVCDelegate> beginDelegate;

@end
