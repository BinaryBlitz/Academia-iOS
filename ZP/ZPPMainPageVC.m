//
//  ZPPMainPageVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAnotherProductsTVC.h"
#import "ZPPBeginScreenTVC.h"
#import "ZPPDish.h"
#import "ZPPMainPageVC.h"
#import "ZPPMainVC.h"
#import "ZPPProductTVC.h"
#import "ZPPUserManager.h"

#import "ZPPServerManager+ZPPDishesSeverManager.h"

static NSString *ZPPProductPresenterID = @"ZPPProductPresenterID";
static NSString *ZPPAnotherProductPresenterID = @"ZPPAnotherProductPresenterID";
static NSString *ZPPBeginScreenTVCStoryboardID = @"ZPPBeginScreenTVCStoryboardID";

@interface ZPPMainPageVC () <ZPPProductsBaseTVCDelegate,
                             ZPPBeginScreenTVCDelegate,
                             ZPPProductScreenTVCDelegate>

@property (strong, nonatomic) NSArray *productViewControllers;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *dishes;

@end

@implementation ZPPMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    ZPPBeginScreenTVC *beginScreen = [self startScreen];

    [self configureScreensWithArr:@[ beginScreen ]];
    
    for (ZPPProductsBaseTVC *vc in self.productViewControllers) {
        vc.delegate = self;
    }

    self.view.backgroundColor = [UIColor blackColor];

    self.delegate = self;
    self.dataSource = self;

    [self setViewControllers:@[ self.productViewControllers[0] ]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];

    [self addPageControl];
    [[ZPPUserManager sharedInstance] checkUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDishes];
}

#pragma mark - page vc delegate

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.productViewControllers count] == 0) ||
        (index >= [self.productViewControllers count])) {
        return nil;
    }

    return self.productViewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.productViewControllers indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.productViewControllers indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == [self.productViewControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (finished && completed) {
        UIViewController *vc = [self.viewControllers lastObject];

        NSInteger index = [self.productViewControllers indexOfObject:vc];
        self.pageControl.currentPage = index;
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - support

- (void)addPageControl {
    if (!_pageControl) {
        CGRect rect = [UIScreen mainScreen].bounds;
        UIPageControl *pageControl =
            [[UIPageControl alloc] initWithFrame:CGRectMake(0, 50, rect.size.width, 30)];

        pageControl.numberOfPages = self.productViewControllers.count;
        pageControl.enabled = NO;
        pageControl.hidesForSinglePage = YES;

        [self.view addSubview:pageControl];
        self.pageControl = pageControl;
    }
}

#pragma mark - ZPPProductBaseDelegate

- (void)didScroll:(UIScrollView *)sender {
    if (sender.contentOffset.y > 10) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
}

#pragma mark - ZPPBeginScreenTVCDelegate

- (void)didPressBeginButton {
    if (![[ZPPUserManager sharedInstance] checkUser]) {
        [[self mainVC] showRegistration];
    } else {
        if (self.productViewControllers.count > 1) {  // REDO костыль
            [self setViewControllers:@[ self.productViewControllers[1] ]
                           direction:UIPageViewControllerNavigationDirectionForward
                            animated:YES
                          completion:nil];  // redo
            self.pageControl.currentPage = 1;
        }
    }
}

- (void) showMenuPreview {
    // kek
    if (self.productViewControllers.count > 1) {  // REDO костыль
        [self setViewControllers:@[ self.productViewControllers[1] ]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:nil];  // redo
        self.pageControl.currentPage = 1;
    }
}

#pragma mark - ZPPProductScreenTVCDelegate

- (void)addItemIntoOrder:(id<ZPPItemProtocol>)item {
    ZPPMainVC *mainVC = (ZPPMainVC *)self.parentViewController;

    [mainVC addItemIntoOrder:item];
}

#pragma mark - dishes

- (void)loadDishes {
    __weak typeof(self) weakSelf = self;
    [[ZPPServerManager sharedManager]
        getDayMenuOnSuccess:^(NSArray *meals, NSArray *dishes, NSArray *stuff,
                              ZPPTimeManager *timeManager) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                NSArray *dishControllers = [strongSelf dishControllersFromArr:dishes];
                NSArray *mealControllers = [strongSelf lunchControllersFromArr:meals];

                NSArray *arr =
                    [@[ [strongSelf startScreen] ] arrayByAddingObjectsFromArray:mealControllers];
                arr = [arr arrayByAddingObjectsFromArray:dishControllers];

                if (stuff.count) {
                    ZPPAnotherProductsTVC *stuffTVC = [strongSelf generateAnotherProductsVC:stuff];
                    stuffTVC.productDelegate = strongSelf;
                    arr = [arr arrayByAddingObject:stuffTVC];
                }

                [strongSelf configureScreensWithArr:arr];
            }
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                if (statusCode == 401) {
                    [[ZPPUserManager sharedInstance] userLogOut];
                    [strongSelf configureScreensWithArr:@[ [strongSelf startScreen] ]];
                } else {
                    [[strongSelf mainVC] showNoInternetScreen];
                }
            }
        }];
}

- (NSArray *)dishControllersFromArr:(NSArray *)dishes {
    NSMutableArray *tmp = [NSMutableArray array];

    for (ZPPDish *di in dishes) {
        ZPPProductTVC *productTVC = [self generateDishVC:di];
        productTVC.productDelegate = self;
        [tmp addObject:productTVC];
    }

    return [NSArray arrayWithArray:tmp];
}

- (NSArray *)lunchControllersFromArr:(NSArray *)lunches {
    NSMutableArray *tmp = [NSMutableArray array];

    for (ZPPDish *lunch in lunches) {
        ZPPProductTVC *productTVC = [self generateLunchVC:lunch];
        productTVC.productDelegate = self;
        [tmp addObject:productTVC];
    }

    return [NSArray arrayWithArray:tmp];
}

- (ZPPProductTVC *)generateDishVC:(ZPPDish *)dish {
    ZPPProductTVC *productTVC = [self productTVC];
    [productTVC configureWithDish:dish];

    return productTVC;
}

- (ZPPProductTVC *)generateLunchVC:(ZPPDish *)lunch {
    ZPPProductTVC *productTVC = [self productTVC];
    [productTVC configureWithLunch:lunch];

    return productTVC;
}

- (ZPPProductTVC *)productTVC {
    ZPPProductTVC *productTVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPProductPresenterID];

    [productTVC configureWithOrder:[self mainVC].order];

    return productTVC;
}

- (ZPPAnotherProductsTVC *)generateAnotherProductsVC:(NSArray *)products {
    ZPPAnotherProductsTVC *anotherTVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPAnotherProductPresenterID];

    [anotherTVC configureWithOrder:[self mainVC].order];
    [anotherTVC configureWithStuffs:products];
    return anotherTVC;
}

- (ZPPBeginScreenTVC *)startScreen {
    ZPPBeginScreenTVC *beginScreen =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPBeginScreenTVCStoryboardID];
    beginScreen.beginDelegate = self;

    return beginScreen;
}

- (void)configureScreensWithArr:(NSArray *)screens {
    ZPPProductsBaseTVC *viewController = [self.viewControllers lastObject];
    NSInteger currentIndex = [self.productViewControllers indexOfObject:viewController];

    self.productViewControllers = screens;
    self.dataSource = nil;
    self.dataSource = self;

    for (ZPPProductsBaseTVC *vc in self.productViewControllers) {
        vc.delegate = self;
    }

    self.pageControl.numberOfPages = self.productViewControllers.count;

    ZPPProductsBaseTVC *destVC;
    if (currentIndex < self.productViewControllers.count) {
        destVC = self.productViewControllers[currentIndex];
    }

    if (!destVC) {
        destVC = self.productViewControllers[0];
    }

    [self setViewControllers:@[ destVC ]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

- (ZPPMainVC *)mainVC {
    return (ZPPMainVC *)self.parentViewController;
}

@end
