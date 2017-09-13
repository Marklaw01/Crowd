//
//  UploadStartupProfileViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 22/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "UploadStartupProfileViewController.h"

@interface UploadStartupProfileViewController ()

@end

@implementation UploadStartupProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Upload Startup Profile" ;
    [self resetUISettings] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    [UtilityClass setTextFieldBorder:fileNameTxtFld] ;
    [UtilityClass setTextFieldBorder:startupNameTxtFld] ;
    
    [UtilityClass addMarginsOnTextField:fileNameTxtFld] ;
    [UtilityClass addMarginsOnTextField:startupNameTxtFld] ;
    
    startupNameTxtFld.text = [NSString stringWithFormat:@"%@",[[UtilityClass getStartupDetails] valueForKey:kStartupsAPI_StartupName]] ;
    
    if ([[kUSERDEFAULTS valueForKey:@"StartupProfileLink"] isEqualToString:@""])
        profileLinkBtn.hidden = true;
    else {
        profileLinkBtn.hidden = false;
        [profileLinkBtn setTitle:[NSString stringWithFormat:@"Profile Uploaded Link : %@%@", APIPortToBeUsed, [kUSERDEFAULTS valueForKey:@"StartupProfileLink"]] forState:UIControlStateNormal];
    }
}

#pragma mark - IBAction Method
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Upload_ClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)profileUploadedLink_ClickAction:(id)sender {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", APIPortToBeUsed, [kUSERDEFAULTS valueForKey:@"StartupProfileLink"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return YES ;
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
