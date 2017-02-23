#import <UIKit/UIKit.h>

@interface UIButton (ZPPButtonCategory)

- (void)stopIndication;
- (void)startIndicating;
- (void)startIndicatingWithType:(UIActivityIndicatorViewStyle)style;

@end
