//
//  WorkOrderParentViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 17/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "WorkOrderParentViewController.h"

@interface WorkOrderParentViewController ()

@end

@implementation WorkOrderParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self setNavigationBar] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)setNavigationBar {
    if([UtilityClass getStartupWorkOrderType] == YES) {
        self.title  = [[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_StartupName] ;
    }
    else {
        self.title  = @"" ;
    }
}

-(void)resetUISettings {
    if([[NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_isEntrepreneur]] isEqualToString:@"true"]) {
        entrepreneurWorkOrderView.hidden = NO ;
        contractorWorkOrderView.hidden = YES ;
    }
    else{
        entrepreneurWorkOrderView.hidden = YES ;
        contractorWorkOrderView.hidden = NO ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
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
