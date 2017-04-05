#import "ZPPProductsBaseTVC.h"

@protocol ZPPBeginScreenTVCDelegate <NSObject>

- (void)didPressBeginButton;
- (void)didPressPreviewButton;
@end

@interface ZPPBeginScreenTVC : ZPPProductsBaseTVC

@property (nonatomic, weak) id <ZPPBeginScreenTVCDelegate> beginDelegate;

@end
