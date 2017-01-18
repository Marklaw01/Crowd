//
//  CommitTableViewCell.h
//  CrowdBootstrap
//
//  Created by OSX on 09/04/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *commitBtn;

@property (strong, nonatomic) IBOutlet UILabel *progressLbl;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;


@end
