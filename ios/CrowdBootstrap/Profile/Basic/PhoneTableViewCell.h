//
//  PhoneTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 12/05/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSPhoneLibrary.h"

@interface PhoneTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SHSPhoneTextField *textField;

@property (strong, nonatomic) IBOutlet UILabel *fieldNameLbl;

@end
