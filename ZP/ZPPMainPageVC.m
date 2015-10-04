//
//  ZPPMainPageVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPMainPageVC.h"
#import "ZPPProductTVC.h"

static NSString *ZPPProductPresenterID = @"ZPPProductPresenterID";

@interface ZPPMainPageVC ()

@property (strong, nonatomic) NSArray *productViewControllers;

@end

@implementation ZPPMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ZPPProductTVC *productTVC = [self.storyboard
                                 instantiateViewControllerWithIdentifier:ZPPProductPresenterID];
    productTVC.specindex = 1;
    ZPPProductTVC *productTVC2 = [self.storyboard
                                 instantiateViewControllerWithIdentifier:ZPPProductPresenterID];
    productTVC2.specindex = 2;
    
    self.productViewControllers = @[productTVC, productTVC2];
    
    self.delegate = self;
    self.dataSource = self;
    
    NSLog(@"loaded");
    [self setViewControllers:@[ productTVC]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    
    // Do any additional setup after loading the view.
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
    
    return self.productViewControllers[index];//
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

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//    return self.productViewControllers.count;
//}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
