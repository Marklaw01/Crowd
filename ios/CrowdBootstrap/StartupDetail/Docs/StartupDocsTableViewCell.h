//
//  StartupDocsTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 22/04/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartupDocsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *usernameLbl;
@property (strong, nonatomic) IBOutlet UILabel *roadmapLbl;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (strong, nonatomic) IBOutlet UILabel *docNameLbl;


@end
