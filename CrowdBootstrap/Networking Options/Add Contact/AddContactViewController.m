//
//  AddContactViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 08/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [segmentControl setSelectedSegmentIndex:SEARCH_USER_SELECTED];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
}

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)segmentControlValueChanged:(id)sender {
    
    selectedSegment = segmentControl.selectedSegmentIndex;
    
    switch (selectedSegment) {
        case 0: // Search
        {
            [UIView animateWithDuration:0.5 animations:^{
                self->vwSearchConnection.alpha = 1;
                self->vwAddNewUser.alpha = 0;
            }];
        }
            break;
        case 1: // Add New User
        {
            [UIView animateWithDuration:0.5 animations:^{
                self->vwSearchConnection.alpha = 0;
                self->vwAddNewUser.alpha = 1;
            }];
        }
            break;
        default:
            break;
    }
}

@end