//
//  SettingsTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 04/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *settingsLbl;
@property (weak, nonatomic) IBOutlet UISwitch *settingsSwitch;

@end
