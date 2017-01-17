//
//  KeywordsTableViewCell.h
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

@interface KeywordsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet TLTagsControl *tagsScrollView;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;



@end
