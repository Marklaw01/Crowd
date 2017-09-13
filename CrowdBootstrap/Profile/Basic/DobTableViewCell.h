//
//  DobTableViewCell.h
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DobTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textFld;

@property (weak, nonatomic) IBOutlet UIButton *dropdownBtn;

@property (strong, nonatomic) IBOutlet UILabel *fieldNameLbl;


@end
