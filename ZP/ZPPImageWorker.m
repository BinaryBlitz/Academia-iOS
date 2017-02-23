#import "ZPPImageWorker.h"
#import <SDWebImage/SDWebImageManager.h>
#import "ZPPWithImageURL.h"

@implementation ZPPImageWorker

+ (void)preheatImageWithUrl:(NSURL *)url {
  SDWebImageManager *manager = [SDWebImageManager sharedManager];
  [manager downloadImageWithURL:url
                        options:0
                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         // progression tracking code
                       }
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished,
                          NSURL *imageURL) {
                        if (image) {
                          // do something with image
                        }
                      }];
}

+ (void)preheatImagesOfObjects:(NSArray *)arr {
  for (id obj in arr) {
    if ([obj respondsToSelector:@selector(URLOfImage)]) {
      [[self class] preheatImageWithUrl:[obj URLOfImage]];
    }
  }
}

@end
