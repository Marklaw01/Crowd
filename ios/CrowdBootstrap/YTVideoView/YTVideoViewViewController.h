//
//  YTVideoViewViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 23/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface YTVideoViewViewController : UIViewController <UIWebViewDelegate,YTPlayerViewDelegate> {
    IBOutlet UIBarButtonItem       *menuBarBtn;
    IBOutlet UIWebView             *webView ;
    IBOutlet YTPlayerView          *playerVw;
}

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content ;

@end
