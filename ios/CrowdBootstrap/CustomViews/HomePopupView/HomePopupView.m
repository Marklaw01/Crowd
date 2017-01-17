//
//  HomePopupView.m
//  CrowdBootstrap
//
//  Created by RICHA on 03/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "HomePopupView.h"

@implementation HomePopupView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [[NSBundle mainBundle] loadNibNamed:@"HomePopupView" owner:self options:nil] ;
        [self addSubview:self.contentView] ;
        
    }
    return self;
}

/*+(id)customView
{
    HomePopupView *customView = [[[NSBundle mainBundle] loadNibNamed:@"HomePopupView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[HomePopupView class]])
        return customView;
    else
        return nil;
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
