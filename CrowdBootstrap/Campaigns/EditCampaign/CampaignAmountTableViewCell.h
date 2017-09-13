//
//  CampaignAmountTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 17/05/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSCurrencyTextField.h"

@interface CampaignAmountTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet TSCurrencyTextField *txtField;
@property (strong, nonatomic) IBOutlet UILabel *fieldNameLbl;


@end
