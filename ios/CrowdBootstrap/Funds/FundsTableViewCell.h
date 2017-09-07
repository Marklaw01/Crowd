//
//  FundsTableViewCell.h
//  CrowdBootstrap
//
//  Created by osx on 19/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnLikeCount;
@property (weak, nonatomic) IBOutlet UIButton *btnDislikeCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPostedOn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblAwardStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblWinningBidder;
@property (weak, nonatomic) IBOutlet UILabel *lblInvitationSender;

@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnDislike;
@property (weak, nonatomic) IBOutlet UIButton *btnArchive;
@property (weak, nonatomic) IBOutlet UIButton *btnDeactivate;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak) IBOutlet NSLayoutConstraint  *constraintLblStatusTop;

@end
