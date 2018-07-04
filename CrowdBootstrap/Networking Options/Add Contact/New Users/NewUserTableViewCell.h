//
//  NewUserTableViewCell.h
//  CrowdBootstrap
//
//  Created by osx on 27/06/18.
//  Copyright © 2018 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectionType;
@property (weak, nonatomic) IBOutlet UITextView *txtVwNote;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end
