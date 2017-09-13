//
//  PaymentsTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 04/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel         *companyNameLbl;
@property (weak, nonatomic) IBOutlet UIButton        *checkboxBtn;
@property (weak, nonatomic) IBOutlet UIImageView     *imgView;

@end
