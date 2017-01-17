//
//  SearchStartupTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 05/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchStartupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startupNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *entrepreneurNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIImageView *arrowButton;

@end
