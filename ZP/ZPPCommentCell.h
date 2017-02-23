//
//  ZPPCommentCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 29/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *commentTV;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
