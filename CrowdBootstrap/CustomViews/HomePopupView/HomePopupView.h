//
//  HomePopupView.h
//  CrowdBootstrap
//
//  Created by RICHA on 03/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePopupView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@end
