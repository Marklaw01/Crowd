//
//  AwardTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 10/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface AwardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *reviewLbl;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *ratingsView;

@end
