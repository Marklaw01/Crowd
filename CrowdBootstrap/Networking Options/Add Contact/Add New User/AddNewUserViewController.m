//
//  AddNewUserViewController.m
//  CrowdBootstrap
//
//  Created by Shikha on 07/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "AddNewUserViewController.h"

@interface AddNewUserViewController ()

@end

@implementation AddNewUserViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetUISettings];
}

- (void)viewWillAppear:(BOOL)animated{
    
    // set Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)resetUISettings {
    // Initialize Array
    connectionTypeArray = [[NSMutableArray alloc] init] ;

    txtFieldConnectionType.inputView = pickerViewContainer ;

    // Set Borders And Margins to Text Fields
    [UtilityClass setTextFieldBorder:txtFieldName] ;
    [UtilityClass setTextFieldBorder:txtFieldPhone] ;
    [UtilityClass setTextFieldBorder:txtFieldEmail] ;
    [UtilityClass setTextFieldBorder:txtFieldConnectionType] ;
    [UtilityClass setTextViewBorder:txtViewNote] ;

    [UtilityClass addMarginsOnTextField:txtFieldName];
    [UtilityClass addMarginsOnTextField:txtFieldPhone];
    [UtilityClass addMarginsOnTextField:txtFieldEmail];
    [UtilityClass addMarginsOnTextField:txtFieldConnectionType];
    [UtilityClass addMarginsOnTextView:txtViewNote];
    
    [self getBusinessConnectionTypeList];
}

- (UIImage *)resizedImageFromImage:(UIImage *)image {
    
    CGFloat largestSide = image.size.width > image.size.height ? image.size.width : image.size.height;
    CGFloat scaleCoefficient = largestSide / 560.0f;
    CGSize newSize = CGSizeMake(image.size.width / scaleCoefficient, image.size.height / scaleCoefficient);
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:(CGRect){0, 0, newSize.width, newSize.height}];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (void)resignTextfield {
    [txtFieldName resignFirstResponder];
    [txtFieldPhone resignFirstResponder];
    [txtFieldEmail resignFirstResponder];
    [txtFieldConnectionType resignFirstResponder];
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - IBActions
- (IBAction)PickerToolbarButtons_ClickAction:(id)sender {
    [txtFieldConnectionType resignFirstResponder];
}

- (IBAction)DropdownButton_ClickAction:(id)sender {
    [txtFieldConnectionType becomeFirstResponder] ;
}

- (IBAction)BrowseCardImage_ClickAction:(id)sender {
    
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

- (IBAction)ReadCardImage_ClickAction:(id)sender {
    if (chosenImage == nil) {
        [self presentViewController:[UtilityClass displayAlertMessage:@"Please select a Business Card image first."] animated:YES completion:nil];
    } else
        [self performImageRecognition:chosenImage];
}

- (IBAction)save_ClickAction:(id)sender {
    // Hit APi to Add Business Contact
    [self addBusinessContact];
}

#pragma mark - TextField Delegate Methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder] ;
    if([textField isEqual:txtFieldName])
        [txtFieldPhone becomeFirstResponder] ;
    else if([textField isEqual:txtFieldPhone])
        [txtFieldEmail becomeFirstResponder] ;
    else if([textField isEqual:txtFieldEmail])
        [txtFieldConnectionType becomeFirstResponder] ;
    else if([textField isEqual:txtFieldConnectionType])
        [txtViewNote becomeFirstResponder] ;
    else {
    }
    
    return YES ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _selectedItem = textField;

    int index = [UtilityClass getPickerViewSelectedIndexFromArray:connectionTypeArray forID:selectedConnectionTypeID] ;
    if(index == -1)
        [pickerView selectRow:0 inComponent:0 animated:YES] ;
    else
        [pickerView selectRow:index+1 inComponent:0 animated:YES] ;
    
    [pickerView reloadAllComponents];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _selectedItem = nil ;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    _selectedItem = textView;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    _selectedItem = nil ;
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
//        UIImage *resizedImage = [self resizedImageFromImage:chosenImage];
        imgVwBusinessCard.image = chosenImage;
        imgData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    }
}

#pragma mark - OCR Integration Methods
- (void)performImageRecognition:(UIImage *)image {
   
    // Create your G8Tesseract object using the initWithLanguage method:
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    
    // Optionaly: specify engine to recognize with; G8OCREngineModeTesseractOnly by default.
    tesseract.engineMode = G8OCREngineModeTesseractOnly;

    // Set up the delegate to receive Tesseract's callbacks.
    tesseract.delegate = self;

    // Specify the image Tesseract should recognize on
//    tesseract.image = [image g8_blackAndWhite];
    tesseract.image = image;
    
    // Start the recognition
    [tesseract recognize];

    // Retrieve the recognized text
    NSLog(@"Recognized Text:%@", [tesseract recognizedText]);
    
    NSString *fullNAme = [self extractUserName:[tesseract recognizedText]];
    txtFieldName.text = fullNAme;
    
    NSString *phoneNo = [self extractPhone:[tesseract recognizedText]];
    txtFieldPhone.text = phoneNo;
    
    NSString *email = [self extractEmail:[tesseract recognizedText]];
    txtFieldEmail.text = email;
}

- (NSString *)extractUserName:(NSString *)strInput {
    NSMutableString * nameCharacters = [NSMutableString string];
    NSArray *words = [strInput componentsSeparatedByString:@"\n"];
    NSLog(@"Array: %@", words);
    for (NSString *word in words) {
        NSArray *arrNoOfWords = [word componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
        NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacterString] ;
        BOOL isSpecialCharacter = [word rangeOfCharacterFromSet:specialCharacterSet].length ;

        if (arrNoOfWords.count == 2 && !isSpecialCharacter) {
            unichar firstCharOfFirstWord = [[arrNoOfWords objectAtIndex:0] characterAtIndex:0];
            unichar firstCharOfSecWord = [[arrNoOfWords objectAtIndex:1] characterAtIndex:0];

            BOOL isFirstWordLetterCapitalized = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:firstCharOfFirstWord];
            BOOL isSecWordLetterCapitalized = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:firstCharOfSecWord];

            if (isFirstWordLetterCapitalized && isSecWordLetterCapitalized) {
                [nameCharacters appendString:word];
            }
        }
    }
    return nameCharacters;
}

- (NSString *)extractPhone:(NSString *)strInput {
    NSMutableString *phoneNo = [NSMutableString string];
    NSArray *words = [strInput componentsSeparatedByString:@"\n"];
    NSLog(@"Array: %@", words);
    for (NSString *word in words) {
        NSString *specialCharacterString = @"-() ";
        NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacterString] ;
        BOOL isStrNumber = [word rangeOfCharacterFromSet:specialCharacterSet].length ;

        if (isStrNumber) {
            NSString *alphabeticCharacterString = @"^[a-z][A-Z][0-9]";
            NSCharacterSet *alphabeticCharacterSet = [NSCharacterSet characterSetWithCharactersInString:alphabeticCharacterString] ;
            BOOL isStrNumberValid = [word rangeOfCharacterFromSet:alphabeticCharacterSet].length ;

            if (isStrNumberValid) {
                NSString *phone = normalize(word);
                if (phone.length > 8)
                    [phoneNo appendString:phone];
            }
        }
    }
    return phoneNo;
}

NSString *normalize(NSString *number) {
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet addCharactersInString:@"-() "];
    
    [nonNumberCharacterSet invert];
    
    return [[number componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
}

- (NSString *)extractEmail:(NSString *)strInput {
    NSMutableString *emailString = [NSMutableString string];
    NSArray *words = [strInput componentsSeparatedByString:@"\n"];
    NSLog(@"Array: %@", words);
    for (NSString *word in words) {
        
        if ([word containsString:@"@"]) {
            NSArray *chunks = [word componentsSeparatedByString: @" "];
            for (int i=0; i<chunks.count; i++) {
                if ([[chunks objectAtIndex:i] containsString:@"@"])
                    [emailString appendString:[chunks objectAtIndex:i]];
            }
        }
    }
    return emailString;
}

/*
- (UIImage *)preprocessedImageForTesseract:(G8Tesseract *)tesseract sourceImage:(UIImage *)sourceImage {
    // sourceImage is the same image you sent to Tesseract above
    UIImage *inputImage = sourceImage;

    // Initialize our adaptive threshold filter
    GPUImageAdaptiveThresholdFilter *stillImageFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
    stillImageFilter.blurRadiusInPixels = 4.0; // adjust this to tweak the blur radius of the filter, defaults to 4.0

    // Retrieve the filtered image from the filter
    UIImage *filteredImage = [stillImageFilter imageByFilteringImage:inputImage];

    // Give the filteredImage to Tesseract instead of the original one,
    // allowing us to bypass the internal thresholding step.
    // filteredImage will be sent immediately to the recognition step
    return filteredImage;
}
*/
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
    if (row == 0) {
        txtFieldConnectionType.text = @"";
        selectedConnectionTypeID = @"";
    } else {
        txtFieldConnectionType.text = connectionTypeArray[row-1][@"name"];
        selectedConnectionTypeID = [connectionTypeArray[row-1][@"id"] stringValue];
        NSLog(@"Selected Connection Type - %@: %@",txtFieldConnectionType.text, selectedConnectionTypeID);
    }
}

#pragma mark - keyoboard actions
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.selectedItem.frame.origin ) ) {
        [self.scrollView scrollRectToVisible:self.selectedItem.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self moveToOriginalFrame] ;
}

-(void)moveToOriginalFrame {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Api Methods
- (void)addBusinessContact {
    if([UtilityClass checkInternetConnection]) {
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kBusinessAPI_CreatedBy] ;
        [dictParam setObject:txtFieldName.text forKey:kBusinessAPI_Name] ;
        [dictParam setObject:txtFieldPhone.text forKey:kBusinessAPI_Phone] ;
        [dictParam setObject:txtFieldEmail.text forKey:kBusinessAPI_Email] ;
        if (selectedConnectionTypeID != nil)
            [dictParam setObject:selectedConnectionTypeID forKey:kBusinessAPI_ConnectionId] ;
        else
            [dictParam setObject:@"" forKey:kBusinessAPI_ConnectionId] ;

        [dictParam setObject:txtViewNote.text forKey:kBusinessAPI_Note] ;

        [dictParam setValue:@"0" forKey:kBusinessAPI_Status];
    
        if(imgData)
            [dictParam setObject:imgData forKey:kBusinessAPI_CardImage] ;
        else
            [dictParam setObject:@"" forKey:kBusinessAPI_CardImage] ;
        
        NSLog(@"dictParam: %@",dictParam) ;
        
        [ApiCrowdBootstrap addBusinessContactWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
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
            
        } progress:^(double progress) {
            NSLog(@"progress %f",progress) ;
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

@end
