//
//  FeedsTableViewCell.h
//  CrowdBootstrap
//
//  Created by Shikha on 25/05/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
    
@property (weak, nonatomic) IBOutlet UIButton *btnAttachment1;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachment2;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachment3;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachment4;

@end
