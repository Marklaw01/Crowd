//
//  SubmitAppTableViewCell.h
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitAppTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionLbl;
@property (weak, nonatomic) IBOutlet UITextField *textFld;

@property (strong, nonatomic) IBOutlet UIButton *minusBtn;
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;


@end
