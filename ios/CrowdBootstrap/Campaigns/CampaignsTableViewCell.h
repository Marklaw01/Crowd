//
//  CampaignsTableViewCell.h
//  CrowdBootstrap
//
//  Created by RICHA on 15/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampaignsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *campaignNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *startupNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *targetAmountLbl;
@property (strong, nonatomic) IBOutlet UILabel *fundsRaisedLbl;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;


@end
