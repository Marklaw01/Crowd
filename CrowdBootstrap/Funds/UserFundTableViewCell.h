//
//  UserFundTableViewCell.h
//  CrowdBootstrap
//
//  Created by osx on 31/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserFundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnViewProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc
;

@end
