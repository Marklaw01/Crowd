//
//  SuggestKeywordsTableViewCell.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 11/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface SuggestKeywordsTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end
