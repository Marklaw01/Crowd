//
//  NewsDetailViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 13/09/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlAddress = _strLink;
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UtilityClass hideHud] ;
}

@end
