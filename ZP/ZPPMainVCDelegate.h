//
//  ZPPMainVCDelegate.h
//  Academia
//
//  Created by Алексей on 03.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//
@import Foundation;
#import "ZPPCategory.h"

@protocol ZPPMainVCDelegate <NSObject>

- (void)loadDishes:(ZPPCategory*)category;

@end
