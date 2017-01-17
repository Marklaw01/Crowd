//
//  SignUpViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

enum {
    kCountrySelected ,
    kStateSelected,
    kSecurityQuesSelected
};

enum {
    kDobSelected ,
    kBestAvailabilitySelected,
};

#define kFirstNameIndex                               0
#define kLastNameIndex                                1
#define kUsernameIndex                                2
#define kEmailIndex                                   3
#define kDobIndex                                     4
#define kPhoneIndex                                   5
#define kCountryIndex                                 6
#define kStateIndex                                   7
#define kCityIndex                                    8
#define kBestAvailabilityIndex                        9
#define kPasswordIndex                                10
#define kConfirmPasswordIndex                         11
#define kChooseSecurityQuesIndex                      12
#define kORIndex                                      13
#define kEnterSecurityQuesIndex                       14
#define kTermsIndex                                   15
#define kValidationIndex                              16
#define kReferFriendIndex                             17
#define kSignupIndex                                  18

#define kCountryCellIdentifier                        @"CountryCell"
#define kTextFieldCellIdentifier                      @"TextFieldCell"
#define kChooseSecurityQuesCellIdentifier             @"ChooseSecurityQuesCell"
#define kORCellIdentifier                             @"OrCell"
#define kEnterSecurityQuesCellIdentifier              @"EnterSecurityQuesCell"
#define kValidationCellIdentifier                     @"ValidationCell"
#define kSignupCellIdentifier                         @"SignupCell"
#define kDobCellIdentifier                            @"DobCell"
#define kPhoneCellIdentifier                          @"PhoneCell"
#define kTermsCellIdentifier                          @"TermsCell"
#define kReferFriendCellIdentifier                    @"ReferFriendCell"

#define kSecurityQuesTextDefault                      @"Select Security Question"
#define kEnterSecurityQuesTextDefault                 @"Enter Your Security Question"
#define kORTextDefault                                @"OR"
#define kValidationTextDefault                        @"Validation"

#define kSelectDefaultText                            @"Select"
#define kSelectSecurityQuesDefaultText                @"Select Security Question"

#define kValidationAlreadyTaken                       @"has already been taken"


@protocol GPPNativeShareBuilder;

@interface SignUpViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, GPPSignInDelegate>{
    IBOutlet UITableView                *tblView ;
    
    IBOutlet UIView                     *securityQuesView;
    IBOutlet UIPickerView               *pickerView;
    
    IBOutlet UIDatePicker               *datePickerView;
    IBOutlet UIView                     *datePickerViewContainer;
    
    IBOutlet UIView                     *validationPopupView;
    
    IBOutlet UIToolbar                  *phoneToolBar;
    
    // Pop-Up View
    IBOutlet UIView *vwPopup;
    IBOutlet UIWebView *webViewPopup;
    IBOutlet UILabel *lblTitle;

    NSMutableArray                      *sectionsArray ;
    NSMutableArray                      *chooseSecurityQuesArray ;
    NSMutableArray                      *enterSecurityQuesArray ;
    NSMutableArray                      *countryArray ;
    NSMutableArray                      *statesArray ;
    NSArray                             *securityQuestionsArray ;
    NSString                            *prevDueDate ;
    NSString                            *phoneNumberStr ;
    NSString                            *selectedCountryID ;
    NSString                            *selectedStateID ;
    int                                 selectedSecurityQuesIndex ;
    int                                 selectedCellIndex ;
    int                                 selectedPickerViewType ;
    int                                 selectedDatePickerType ;
    int                                 isTermsSelected ;
    
    
    NSCharacterSet                      *blockedCharacters ;
    
}

@property UIView                                          *selectedItem;

@end
