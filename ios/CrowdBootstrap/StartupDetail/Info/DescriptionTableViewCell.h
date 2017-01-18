//
//  DescriptionTableViewCell.h
//  CrowdBootstrap
//
//  Created by RICHA on 13/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtView;

@property (strong, nonatomic) IBOutlet UILabel *fieldNameLbl;

@end
