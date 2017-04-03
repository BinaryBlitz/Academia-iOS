#import <UIKit/UIKit.h>
#import "ZPPItemProtocol.h"

//@class ZPPOrder;

@protocol ZPPProductsBaseTVCDelegate <NSObject>

- (void)didScroll:(UIScrollView *)sender;

@end

@protocol ZPPProductScreenTVCDelegate <NSObject>

- (void)addItemIntoOrder:(id <ZPPItemProtocol>)item;
@end //

@interface ZPPProductsBaseTVC : UITableViewController
@property (nonatomic) BOOL shouldScrollToFirstRow;
@property (nonatomic, weak) id <ZPPProductsBaseTVCDelegate> delegate;
@property (nonatomic, weak) id <ZPPProductScreenTVCDelegate> productDelegate;

@property (assign, nonatomic, readonly) CGFloat screenHeight;
- (void)registerCells;

@end
