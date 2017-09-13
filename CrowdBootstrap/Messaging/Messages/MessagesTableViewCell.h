//
//  MessagesTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 05/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface MessagesTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *workUnitsLbl;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;
@property (strong, nonatomic) IBOutlet UIButton *messageBtn;

@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) IBOutlet UILabel *sentByLbl;

@property (strong, nonatomic) IBOutlet UILabel *dateLbl;

@end
