//
//  BusinessCardDetailViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 10/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "BusinessCardDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ManageNotesViewController.h"

@interface BusinessCardDetailViewController ()

@end

@implementation BusinessCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings];

    // hit api to get connection type list
    [self getBusinessConnectionTypeList];
    
    // hit Api to view the selected card details
    [self viewBusinessCardDetails];
    
    if ([_strBusinessCardScreenType isEqualToString:@"NotesDetail"]) {
        [btnAddNote setTitle:@"Edit Note" forState:UIControlStateNormal];
        NSString *noteDesc = [_selectedNoteDict valueForKey:kBusinessAPI_NoteDesc];
        txtVwNotes.text = noteDesc;
    } else {
        [btnAddNote setTitle:@"Add Note" forState:UIControlStateNormal];
        txtVwNotes.text = @"";
    }
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated {

    imgVwUser.layer.cornerRadius = imgVwUser.frame.size.width/2;
    imgVwUser.clipsToBounds = YES;

    if ([_strBusinessCardScreenType isEqualToString:@"NotesDetail"]) {
        lblUsername.text = [NSString stringWithFormat:@"%@",[_selectedNoteDict valueForKey:kBusinessAPI_Name]] ;
        [imgVwUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[_selectedNoteDict valueForKey:kBusinessAPI_UserProfileImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
    }
    else if ([_strBusinessCardScreenType isEqualToString:@"CardDetail"]) {
        lblUsername.text = [NSString stringWithFormat:@"%@",[_selectedCardDict valueForKey:kBusinessAPI_UserName]] ;
        [imgVwUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[_selectedCardDict valueForKey:kBusinessAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
    }
    else if ([_strBusinessCardScreenType isEqualToString:@"PublicProfile"]) {
        lblUsername.text = [NSString stringWithFormat:@"%@",[_selectedProfileDict valueForKey:kBusinessAPI_Name]] ;
        [imgVwUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[_selectedProfileDict valueForKey:kBusinessAPI_UserProfileImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
    }
    else {
        lblUsername.text = [NSString stringWithFormat:@"%@",[_selectedUserDict valueForKey:kBusinessAPI_Name]] ;
        [imgVwUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIPortToBeUsed,[_selectedUserDict valueForKey:kBusinessAPI_UserImage]]] placeholderImage:[UIImage imageNamed:kImage_ProfilePicDefault]] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:) name:kNotificationIconOnNavigationBar
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SendUserInfoNotification:) name:kNotificationSendUserInfo
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SendNotesInfoNotification:) name:kNotificationSendNotesInfo
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SendCardInfoNotification:) name:kNotificationSendCardInfo
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SendProfileInfoNotification:) name:kNotificationSendProfileInfo
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

-(void)SendUserInfoNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kNotificationSendUserInfo]) {
        NSDictionary *dict = notification.userInfo;
        _strBusinessCardScreenType = notification.object;
        _selectedUserDict = dict;
    }
}

-(void)SendNotesInfoNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kNotificationSendNotesInfo]) {
        NSDictionary *dict = notification.userInfo;
        _strBusinessCardScreenType = notification.object;
        _selectedNoteDict = dict;
    }
}

-(void)SendCardInfoNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kNotificationSendCardInfo]) {
        NSDictionary *dict = notification.userInfo;
        _strBusinessCardScreenType = notification.object;
        _selectedCardDict = dict;
    }
}

-(void)SendProfileInfoNotification:(NSNotification *)notification {
    if ([[notification name] isEqualToString:kNotificationSendProfileInfo]) {
        NSDictionary *dict = notification.userInfo;
        _strBusinessCardScreenType = notification.object;
        _selectedProfileDict = dict;
    }
}

- (void)resetUISettings {
    // Initialize Array
    connectionTypeArray = [[NSMutableArray alloc] init] ;
    
    txtConnectionType.inputView = pickerViewContainer ;
    
    // Set Borders And Margins to Text Fields
    [UtilityClass setTextFieldBorder:txtConnectionType] ;
    [UtilityClass setTextViewBorder:txtVwUserBio] ;
    [UtilityClass setTextViewBorder:txtVwUserInterest] ;
    [UtilityClass setTextViewBorder:txtVwUserStatement] ;

    [UtilityClass addMarginsOnTextField:txtConnectionType];
    [UtilityClass addMarginsOnTextView:txtVwUserBio];
    [UtilityClass addMarginsOnTextView:txtVwUserInterest];
    [UtilityClass addMarginsOnTextView:txtVwUserStatement];
}

- (void)setConnectionField {    
    if ([_strBusinessCardScreenType isEqualToString:@"UserDetail"]) {
        selectedConnectionTypeID = [NSString stringWithFormat:@"%@", [_selectedUserDict valueForKey:kBusinessAPI_ConnectionTypeId]];
    }
    else if ([_strBusinessCardScreenType isEqualToString:@"CardDetail"]) {
        selectedConnectionTypeID = [NSString stringWithFormat:@"%@", [_selectedCardDict valueForKey:kBusinessAPI_ConnectionId]];
    }
    else if ([_strBusinessCardScreenType isEqualToString:@"PublicProfile"]) {
        selectedConnectionTypeID = [NSString stringWithFormat:@"%@", [_selectedProfileDict valueForKey:kBusinessAPI_ConnectionId]];
    }
    else {
        selectedConnectionTypeID = [NSString stringWithFormat:@"%@", [_selectedNoteDict valueForKey:kBusinessAPI_ConnectionId]];
    }
    
    if (![selectedConnectionTypeID isEqualToString:@""]) {
        btnConnect.hidden = true;
        txtConnectionType.userInteractionEnabled = false;
        
        int index = [UtilityClass getPickerViewSelectedIndexFromArray:connectionTypeArray forID:selectedConnectionTypeID] ;
        [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
        [pickerView reloadAllComponents];
        
        txtConnectionType.text = [[connectionTypeArray objectAtIndex:index] valueForKey:@"name"];
        
    } else {
        btnConnect.hidden = false;
        txtConnectionType.userInteractionEnabled = true;
    }
}

-(void)showCardDetails:(NSDictionary *)dictCard {
    txtVwUserBio.text = [dictCard valueForKey:kBusinessAPI_UserBio];
    txtVwUserInterest.text = [dictCard valueForKey:kBusinessAPI_UserInterest];
    txtVwUserStatement.text = [dictCard valueForKey:kBusinessAPI_UserStatement];

    txtVwUserBio.userInteractionEnabled = false;
    txtVwUserInterest.userInteractionEnabled = false;
    txtVwUserStatement.userInteractionEnabled = false;

    // Image
    NSString *strImage = @"";
    if([dictCard objectForKey:kBusinessAPI_CardImage]) {
        strImage = [NSString stringWithFormat:@"%@%@",APIPortToBeUsed, [dictCard objectForKey:kBusinessAPI_CardImage]];
        NSURL *url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        imgData = [NSData dataWithContentsOfURL:url];
    }

    [imgVwBusinessCard sd_setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:[UIImage imageNamed:kPlaceholderImage_Logo]] ;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewNotesIdentifier"]) {
        ManageNotesViewController *viewController = segue.destinationViewController;
        if ([_strBusinessCardScreenType isEqualToString:@"UserDetail"]) {
            viewController.selectedCardId = [NSString stringWithFormat:@"%@",[_selectedUserDict valueForKey:kBusinessAPI_CardId]];
        }
        else {
            viewController.selectedCardId = [NSString stringWithFormat:@"%@",[_selectedCardDict valueForKey:kBusinessAPI_CardId]];
        }
    }
}

#pragma mark - TextField Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    int index = [UtilityClass getPickerViewSelectedIndexFromArray:connectionTypeArray forID:selectedConnectionTypeID] ;
    if(index == -1)
        [pickerView selectRow:0 inComponent:0 animated:YES] ;
    else
        [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    
    [pickerView reloadAllComponents];
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

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return connectionTypeArray.count+1 ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(row == 0)
        return @"Select Connection Type";
    else
        return [[connectionTypeArray objectAtIndex:row-1] valueForKey:@"name"] ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    txtConnectionType.text = connectionTypeArray[row-1][@"name"];
    selectedConnectionTypeID = connectionTypeArray[row-1][@"id"];
    NSLog(@"Selected Connection Type - %@: %@",txtConnectionType.text, selectedConnectionTypeID);
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

- (IBAction)addNote_ClickAction:(id)sender {
    // Hit API to save note
    if ([_strBusinessCardScreenType isEqualToString:@"NotesDetail"]) {
        [self editNote];
    } else {
        [self addNote];
    }
}

- (IBAction)connect_ClickAction:(id)sender {
    [self addBusinessNetwork];
}

- (IBAction)PickerToolbarButtons_ClickAction:(id)sender {
    [txtConnectionType resignFirstResponder];
}

- (IBAction)DropdownButton_ClickAction:(id)sender {
    [txtConnectionType becomeFirstResponder] ;
}

#pragma mark - Api Methods
- (void)viewBusinessCardDetails {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        if ([_strBusinessCardScreenType isEqualToString:@"UserDetail"]) {
            [dictParam setObject:[_selectedUserDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_CardId] ;
        }
        else if ([_strBusinessCardScreenType isEqualToString:@"CardDetail"]) {
            [dictParam setObject:[_selectedCardDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_CardId] ;
        }
        else if ([_strBusinessCardScreenType isEqualToString:@"PublicProfile"]) {
            [dictParam setObject:[_selectedProfileDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_CardId] ;
        }
        else {
            [dictParam setObject:[_selectedNoteDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_CardId] ;
        }
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap viewBusinessCardDetailsWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
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

-(void)getBusinessConnectionTypeList {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap getBusinessConnectionTypeListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            [UtilityClass hideHud] ;
            NSLog(@"responseDict: %@",responseDict) ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode)  {
                if([responseDict valueForKey:kBusinessAPI_ConnectionType]) {
                    [connectionTypeArray removeAllObjects];
                    
                    [connectionTypeArray addObjectsFromArray:(NSArray*)[responseDict valueForKey:kBusinessAPI_ConnectionType]] ;
                    
                    [self setConnectionField];
                }
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode ) {
                
                connectionTypeArray = [NSMutableArray arrayWithArray:[responseDict valueForKey:kBusinessAPI_ConnectionType]] ;
            }
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description];
            [UtilityClass hideHud] ;
        }] ;
    }
}

- (void)addNote {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:txtVwNotes.text forKey:kBusinessAPI_Description] ;
        if ([_strBusinessCardScreenType isEqualToString:@"UserDetail"])
            [dictParam setObject:[_selectedUserDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_BusinessCardId] ;
        else
            [dictParam setObject:[_selectedCardDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_BusinessCardId] ;

        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap addBusinessCardNoteWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:@"Note has been added."] animated:YES completion:nil];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
}

- (void)editNote {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:[_selectedNoteDict valueForKey:kBusinessAPI_NoteId] forKey:kBusinessAPI_Id] ;
        [dictParam setObject:txtVwNotes.text forKey:kBusinessAPI_Description] ;
        [dictParam setObject:[_selectedNoteDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_BusinessCardId] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap editBusinessCardNoteWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:@"Note has been updated."] animated:YES completion:nil];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
            
        }] ;
    }
}

- (void)addBusinessNetwork {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_UserID] ;
        [dictParam setObject:selectedConnectionTypeID forKey:kBusinessAPI_ConnectionTypeId] ;
        if ([_strBusinessCardScreenType isEqualToString:@"UserDetail"]) {
            [dictParam setObject:[_selectedUserDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_BusinessCardId] ;
            [dictParam setObject:[_selectedUserDict valueForKey:kBusinessAPI_ContractorId] forKey:kBusinessAPI_ConnectedToId] ;
        } else {
            [dictParam setObject:[_selectedCardDict valueForKey:kBusinessAPI_CardId] forKey:kBusinessAPI_BusinessCardId] ;
            [dictParam setObject:[_selectedCardDict valueForKey:kBusinessAPI_UserID] forKey:kBusinessAPI_ConnectedToId] ;
        }
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap addBusinessNetworkWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            
            NSLog(@"responseDict >>>>> %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode ) {
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            }
            else if([[responseDict valueForKey:@"code"] intValue] == kErrorCode )
                [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

@end
