//
//  ZPPMainPageVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPMainPageVC.h"
#import "ZPPProductTVC.h"
#import "ZPPAnotherProductsTVC.h"
#import "ZPPBeginScreenTVC.h"
#import "ZPPMainVC.h"
#import "ZPPUserManager.h"
#import "ZPPDish.h"

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
    //  beginScreen.beginDelegate = self;

    //  self.productViewControllers = @[ beginScreen ];
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
    // [self findScrollView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([[ZPPUserManager sharedInstance] checkUser]) {
        [self loadDishes];
    } else {
        //        self.productViewControllers = [self startScreen];
        //        self.delegate = nil;
        //        self.delegate = self;

        [self configureScreensWithArr:@[ [self startScreen] ]];
        [self setViewControllers:@[ self.productViewControllers[0] ]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - page vc delegate

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    // return self.productViewControllers[0];//redo
    if (([self.productViewControllers count] == 0) ||
        (index >= [self.productViewControllers count])) {
        return nil;
    }

    return self.productViewControllers[index];  //
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

#pragma mark - UIScrollViewDelegate

//-(void)scrollviewdi

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
        ZPPMainVC *mainVC = (ZPPMainVC *)self.parentViewController;
        [mainVC showRegistration];
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

#pragma mark - ZPPProductScreenTVCDelegate

- (void)addItemIntoOrder:(id<ZPPItemProtocol>)item {
    NSLog(@"item %@", [item nameOfItem]);

    ZPPMainVC *mainVC = (ZPPMainVC *)self.parentViewController;

    [mainVC addItemIntoOrder:item];
}

#pragma mark - dishes

- (void)loadDishes {
    __weak typeof(self) weakSelf = self;
    [[ZPPServerManager sharedManager] getDayMenuOnSuccess:^(NSArray *meals, NSArray *dishes,
                                                            NSArray *stuff) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
        NSArray *newControllers = [strongSelf dishControllersFromArr:dishes];
        ZPPAnotherProductsTVC *stuffTVC = [strongSelf generateAnotherProductsVC:stuff];
        stuffTVC.productDelegate = strongSelf;

        NSArray *arr = [@[ [strongSelf startScreen] ] arrayByAddingObjectsFromArray:newControllers];
        arr = [arr arrayByAddingObject:stuffTVC];
        [strongSelf configureScreensWithArr:arr];
        }
    } onFailure:^(NSError *error, NSInteger statusCode){

    }];
    //    [[ZPPServerManager sharedManager] GETDishesOnSuccesOnSuccess:^(NSArray *dishes) {
    //
    //        NSArray *newControllers = [self dishControllersFromArr:dishes];
    //
    //        NSArray *arr = [@[ [self startScreen] ]
    //            arrayByAddingObjectsFromArray:newControllers];  //[self
    //            dishControllersFromArr:dishes];
    //
    //        [self configureScreensWithArr:arr];
    //
    //        //        self.dataSource = nil;
    //        //        self.dataSource = self;
    //        //
    //        //        for (ZPPProductsBaseTVC *vc in self.productViewControllers) {
    //        //            vc.delegate = self;
    //        //        }
    //        //
    //        //        self.pageControl.numberOfPages = self.productViewControllers.count;
    //        // self.pageControl.currentPage =
    //    } onFailure:^(NSError *error, NSInteger statusCode){
    //
    //    }];
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

- (ZPPProductTVC *)generateDishVC:(ZPPDish *)dish {
    ZPPProductTVC *productTVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPProductPresenterID];

    [productTVC configureWithDish:dish];

    return productTVC;
}

- (ZPPAnotherProductsTVC *)generateAnotherProductsVC:(NSArray *)products {
    ZPPAnotherProductsTVC *anotherTVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPAnotherProductPresenterID];

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

    self.productViewControllers = screens;  //[self dishControllersFromArr:dishes];
    self.dataSource = nil;
    self.dataSource = self;

    for (ZPPProductsBaseTVC *vc in self.productViewControllers) {
        vc.delegate = self;
    }

    self.pageControl.numberOfPages = self.productViewControllers.count;

    ZPPProductsBaseTVC *destVC;
    if(currentIndex<self.productViewControllers.count){
    destVC = self.productViewControllers[currentIndex];  //[self.viewControllers lastObject];
    }

    if (!destVC) {
        destVC = self.productViewControllers[0];
    }

    [self setViewControllers:@[ destVC ]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

//- (void)findScrollView {
//    for (UIView *v in self.view.subviews) {
//        if ([v isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scrollView = (UIScrollView *)v;
//            scrollView.delegate = self;
//        }
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
