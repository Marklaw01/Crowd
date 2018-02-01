//
//  AddBusinessCardViewController.m
//  CrowdBootstrap
//
//  Created by osx on 01/12/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "AddBusinessCardViewController.h"
#import "UIImageView+WebCache.h"

@interface AddBusinessCardViewController ()

@end

@implementation AddBusinessCardViewController

-(void) awakeFromNib {
    [super awakeFromNib];
    [self addObserver];
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserLinkedInDetails:)name:kNotificationSendLinkedInInfo
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

- (void)resetUISettings {
    
    [UtilityClass setTextViewBorder:txtVwUserBio] ;
    [UtilityClass setTextViewBorder:txtVwUserInterest] ;
    [UtilityClass setTextViewBorder:txtVwUserStatement] ;
    
    imgVwUser.layer.cornerRadius = imgVwUser.frame.size.width/2;
    imgVwUser.clipsToBounds = YES;
    
    if ([_strBusinessCardScreenType isEqual: @"Edit"]) {
        // hit Api to view the selected card details
        [self viewBusinessCardDetails];
        self.navigationItem.title = @"Business Card";
    }
    else {
        if (![_strBusinessCardScreenType isEqualToString:@"LinkedInDetail"]) {
            
            NSMutableDictionary *dict = [[UtilityClass getLoggedInUserDetails] mutableCopy] ;
            
            lblUsername.text = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:kLogInAPI_FirstName],[dict valueForKey:kLogInAPI_LastName]] ;
            [imgVwUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[dict valueForKey:kLogInAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
            
            self.navigationItem.title = @"Business Card";
        }
        else {
            lblUsername.text = [NSString stringWithFormat:@"%@",[_userLinkedInfo valueForKey: @"formattedName"]] ;
            txtVwUserBio.text = [[_userLinkedInfo valueForKey:@"siteStandardProfileRequest"] valueForKey:@"url"];
            txtVwUserInterest.text = [_userLinkedInfo valueForKey:@"headline"];
            [imgVwUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_userLinkedInfo valueForKey:@"pictureUrl"]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
            
            self.navigationItem.title = @"Connect Social Media";
        }
    }
}

- (void)setUserLinkedInDetails:(NSNotification *) notification {
    if ([[notification name] isEqualToString:kNotificationSendLinkedInInfo]) {
        NSDictionary *dict = notification.userInfo;
        _strBusinessCardScreenType = notification.object;
        _userLinkedInfo = dict;
    }
}

-(void)showCardDetails:(NSDictionary *)dictCard {
    txtVwUserBio.text = [dictCard valueForKey:kBusinessAPI_UserBio];
    txtVwUserInterest.text = [dictCard valueForKey:kBusinessAPI_UserInterest];
    txtVwUserStatement.text = [dictCard valueForKey:kBusinessAPI_UserStatement];

    // Get user data, incase user is not the LinkedIn user
    NSMutableDictionary *dict = [[UtilityClass getLoggedInUserDetails] mutableCopy] ;
    
    if([dictCard objectForKey:kBusinessAPI_LinkedIn_UserName]) {
        lblUsername.text = [dictCard objectForKey:kBusinessAPI_LinkedIn_UserName];
    } else {
        lblUsername.text = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:kLogInAPI_FirstName],[dict valueForKey:kLogInAPI_LastName]] ;
    }
    
    if([dictCard objectForKey:kBusinessAPI_LinkedIn_UserImage]) {
        [imgVwUser sd_setImageWithURL:[dictCard objectForKey:kBusinessAPI_LinkedIn_UserImage] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Contractor]] ;
    } else {
        [imgVwUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[dict valueForKey:kLogInAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
    }
    
    // Image
    NSString *strImage = @"";
    if([dictCard objectForKey:kBusinessAPI_CardImage]) {
        strImage = [NSString stringWithFormat:@"%@%@",APIPortToBeUsed, [dictCard objectForKey:kBusinessAPI_CardImage]];
        //        NSURL *url = [NSURL URLWithString:[strImage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
        NSURL *url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        imgData = [NSData dataWithContentsOfURL:url];
    }
    
    [imgVwBusinessCard sd_setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Logo]] ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Image Picker Methods
-(void)displayImagePickerWithType:(BOOL)isCameraMode withMediaType:(BOOL)isImageSelected {
    [self dismissViewControllerAnimated:YES completion:nil] ;
    
    if (isCameraMode && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_NoCamera] animated:YES completion:nil] ;
        return ;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if(isCameraMode)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(isImageSelected)
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    else
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo, nil];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil] ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"info>> %@",info) ;
    if([info[UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        chosenImage = info[UIImagePickerControllerEditedImage];
        imgVwBusinessCard.image = chosenImage;
        imgData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    }
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

- (IBAction)BrowseImage_ClickAction:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Choose From Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController.view setTintColor:[UtilityClass blueColor]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Upload Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayImagePickerWithType:NO withMediaType:YES] ;
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self displayImagePickerWithType:YES withMediaType:YES] ;
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)save_ClickAction:(id)sender {
    if ([_strBusinessCardScreenType isEqual: @"Add"] || [_strBusinessCardScreenType isEqual: @"LinkedInDetail"]) {
        [self addBusinessCardDetails];
    } else {
        [self editBusinessCardDetails];
    }
}

#pragma mark - Api Methods
- (void)addBusinessCardDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:txtVwUserBio.text forKey:kBusinessAPI_UserBio] ;
        [dictParam setObject:txtVwUserInterest.text forKey:kBusinessAPI_UserInterest] ;
        [dictParam setValue:@"0" forKey:kBusinessAPI_Status];
        [dictParam setValue:txtVwUserStatement.text forKey:kBusinessAPI_Statement];

        if ([_strBusinessCardScreenType isEqualToString:@"LinkedInDetail"]) {
            [dictParam setValue:[_userLinkedInfo valueForKey: @"formattedName"] forKey:kBusinessAPI_LinkedIn_UserName];
            [dictParam setValue:[_userLinkedInfo valueForKey:@"pictureUrl"] forKey:kBusinessAPI_LinkedIn_UserImage];
        } else {
            [dictParam setValue:@"" forKey:kBusinessAPI_LinkedIn_UserName];
            [dictParam setValue:@"" forKey:kBusinessAPI_LinkedIn_UserImage];
        }
        
        if(imgData)
            [dictParam setObject:imgData forKey:kBusinessAPI_CardImage] ;
        else
            [dictParam setObject:@"" forKey:kBusinessAPI_CardImage] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap addBusinessCardWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        } progress:^(double progress) {
            NSLog(@"progress %f",progress) ;
        }] ;
    }
}

- (void)viewBusinessCardDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:_selectedCardId forKey:kBusinessAPI_CardId] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap viewBusinessCardDetailsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                cardDict = [NSDictionary dictionaryWithDictionary:responseDict];
                [self showCardDetails: responseDict];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

- (void)editBusinessCardDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:_selectedCardId forKey:kBusinessAPI_Id] ;
        [dictParam setObject:txtVwUserBio.text forKey:kBusinessAPI_UserBio] ;
        [dictParam setObject:txtVwUserInterest.text forKey:kBusinessAPI_UserInterest] ;
        [dictParam setValue:txtVwUserStatement.text forKey:kBusinessAPI_Statement];
        [dictParam setValue:@"0" forKey:kBusinessAPI_Status];

        if ([cardDict valueForKey: kBusinessAPI_LinkedIn_UserName]) {
            [dictParam setValue:[cardDict valueForKey: kBusinessAPI_LinkedIn_UserName] forKey:kBusinessAPI_LinkedIn_UserName];
        } else {
            [dictParam setValue:@"" forKey:kBusinessAPI_LinkedIn_UserName];
        }

        if ([cardDict valueForKey:kBusinessAPI_LinkedIn_UserImage]) {
            [dictParam setValue:[cardDict valueForKey:kBusinessAPI_LinkedIn_UserImage] forKey:kBusinessAPI_LinkedIn_UserImage];
        } else {
            [dictParam setValue:@"" forKey:kBusinessAPI_LinkedIn_UserImage];
        }
        
        if(imgData)
            [dictParam setObject:imgData forKey:kBusinessAPI_CardImage] ;
        else
            [dictParam setObject:@"" forKey:kBusinessAPI_CardImage] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap editBusinessCardWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                [self.navigationController popViewControllerAnimated:YES] ;
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        } progress:^(double progress) {
            NSLog(@"progress %f",progress) ;
        }] ;
    }
}
@end
