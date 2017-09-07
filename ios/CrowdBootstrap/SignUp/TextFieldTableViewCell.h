//
//  TextFieldTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 27/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textFld;

@property (strong, nonatomic) IBOutlet UILabel *fieldNameLbl;

@property (strong, nonatomic) IBOutlet UILabel *fundedByLbl;

@end
