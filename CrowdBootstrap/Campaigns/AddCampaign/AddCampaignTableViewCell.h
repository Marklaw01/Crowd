//
//  AddCampaignTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 12/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCampaignTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *chooseFileNameTxtFld;

@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseBtn;

@end
