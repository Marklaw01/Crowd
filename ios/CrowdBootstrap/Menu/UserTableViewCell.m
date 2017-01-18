//
//  UserTableViewCell.m
//  CrowdBootstrap
//
//  Created by OSX on 08/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)referAFriendClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ReferAFriend object:nil];
}
@end
