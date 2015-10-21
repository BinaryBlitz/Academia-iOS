//
//  ZPPBeginScreenTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPBeginScreenTVC.h"
#import "ZPPBeginScreenCell.h"


static NSString *ZPPBeginScreenCellIdentifier = @"ZPPBeginScreenCellIdentifier";

@interface ZPPBeginScreenTVC ()

@end

@implementation ZPPBeginScreenTVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.tableView.alwaysBounceVertical = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPBeginScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPBeginScreenCellIdentifier];
    
    cell.beginButton.layer.borderWidth = 2.0;
    cell.beginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.contentView.backgroundColor = [UIColor blackColor];
    
    cell.backImageView.image = [UIImage imageNamed:@"back3"];
    
    [cell.beginButton addTarget:self
                         action:@selector(beginButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.screenHeight;
}

-(void)registreCells {
    UINib *anotherCell = [UINib nibWithNibName:@"ZPPBeginScreenCell" bundle:nil];
    [[self tableView] registerNib:anotherCell
           forCellReuseIdentifier:ZPPBeginScreenCellIdentifier];
}


-(void)beginButtonAction:(UIButton *)sender {
    
    if(self.beginDelegate && [self.beginDelegate conformsToProtocol:@protocol(ZPPBeginScreenTVCDelegate)] ) {
        [self.beginDelegate didPressBeginButton];
        
    }
    
}
@end
