//
//  ShoppingCartDetailViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 15/07/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "ShoppingCartDetailViewController.h"

@interface ShoppingCartDetailViewController ()

@end

@implementation ShoppingCartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"contentStr: %@",self.contentStr) ;
    if(self.contentStr)contentTextView.text = self.contentStr ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)setUISettings {
}

#pragma mark- IBAction Methods
- (IBAction)BackClick_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

@end