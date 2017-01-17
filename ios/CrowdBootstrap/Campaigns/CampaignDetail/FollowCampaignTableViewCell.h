//
//  FollowCampaignTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 09/04/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowCampaignTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *lblView;

@property (strong, nonatomic) IBOutlet UILabel *lbl;
@property (strong, nonatomic) IBOutlet UITextField *textFld;


@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIButton *postedByBtn;

@end
