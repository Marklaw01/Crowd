//
//  Title1CollectionViewCell.m
//  CrowdBootstrap
//
//  Created by Shikha Singla on 15/09/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "Title1CollectionViewCell.h"

@implementation Title1CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self resetUI];
    
    // Set Button Title as unlimited number of lines
    btnTitle.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnTitle.titleLabel.numberOfLines = 0;
    btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;

    roadmap = [[Roadmap alloc] init];
}

- (void) resetUI {
    btnTitle.layer.borderColor = [[UIColor colorWithRed:73.0/255.0f green:64.0/255.0f blue:56.0/255.0f alpha:1]CGColor];
    btnTitle.layer.masksToBounds = YES;
    btnTitle.layer.borderWidth = 2.0;
    btnTitle.layer.cornerRadius = 8.0;
}

- (void)setData:(Roadmap *)roadmapObj {
    roadmap = roadmapObj;
    
    [btnTitle setTitle:roadmapObj.title forState:UIControlStateNormal];
    NSArray *colorArray = roadmapObj.color;
    btnTitle.backgroundColor = [UIColor colorWithRed:[colorArray[0] doubleValue]/255.0 green:[colorArray[1] doubleValue]/255.0 blue:[colorArray[2] doubleValue]/255.0 alpha:1.0];
}

- (IBAction)btnTitleClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ShowRoadmapDescription object:roadmap];
}

@end
