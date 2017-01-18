//
//  InfoViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 28/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES] ;
    
    titleLbl.text = self.infoTitle ;
    descriptionView.text = self.infoDescription ;
    imgView.image = [UIImage imageNamed:self.infoImage] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
- (IBAction)Ok_ClickAction:(id)sender {
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
