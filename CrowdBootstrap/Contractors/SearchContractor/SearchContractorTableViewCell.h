//
//  SearchContractorTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 05/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchContractorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *rateLbl;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *skillLbl;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;

// Stack View for Recruiter Screen
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *archiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *deactivateBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFollowerBtnBottom;

@end
