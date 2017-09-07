//
//  IndependentContractorViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 26/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "IndependentContractorViewController.h"

@interface IndependentContractorViewController ()

@end

@implementation IndependentContractorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:INDEPENDENT_CONTRACTORS ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods

- (IBAction)OK_ClickAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil] ;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
