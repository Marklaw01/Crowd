//
//  UserTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 08/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;

- (IBAction)referAFriendClicked:(id)sender;


@end
