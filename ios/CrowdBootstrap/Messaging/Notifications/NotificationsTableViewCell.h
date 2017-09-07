//
//  NotificationsTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 04/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end
