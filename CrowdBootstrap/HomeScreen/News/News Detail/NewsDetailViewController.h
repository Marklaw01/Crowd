//
//  NewsDetailViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 13/09/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController {
    IBOutlet UIWebView *webView;
}

@property NSString *strLink;
@end
