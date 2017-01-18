//
//  BasicProfile_ViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
enum{
    PROFILE_COUNTRY_SELECTED,
    PROFILE_CITY_SELECTED
};

#define BASIC_BIO_CELL_IDENTIFIER             @"BioCell"
#define BASIC_TEXTFIELD_CELL_IDENTIFIER       @"TextFieldCell"
#define BASIC_PHONE_CELL_IDENTIFIER           @"PhoneCell"
#define BASIC_DOB_CELL_IDENTIFIER             @"DobCell"
#define BASIC_COUNTRY_CELL_IDENTIFIER         @"CountryCell"
#define BASIC_SUBMIT_CELL_IDENTIFIER          @"SubmitCell"

#define BASIC_BIO_CELL_INDEX                  0
#define BASIC_EMAIL_CELL_INDEX                2
#define BASIC_DOB_CELL_INDEX                  3
#define BASIC_PHONE_CELL_INDEX                4
#define BASIC_COUNTRY_CELL_INDEX              5
#define BASIC_CITY_CELL_INDEX                 6


@interface BasicProfile_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    
    IBOutlet UITableView                      *tblView ;
    IBOutlet UIPickerView                     *pickerView;
    IBOutlet UIView                           *pickerViewContainer;
    IBOutlet UIDatePicker                     *datePickerView;
    IBOutlet UIView                           *datePickerViewContainer;
    IBOutlet UIToolbar *numberToolbar;
    
    NSMutableArray                            *basicProfileArray ;
    NSMutableArray                            *countryArray ;
    NSMutableArray                            *cityArray ;
    NSString                                  *prevDueDate ;
    int                                       selectedPickerViewType ;
    NSString                                  *selectedCountryID ;
    NSString                                  *selectedCityID ;
    NSDateFormatter                           *dateFormatter ;
    
}

@property UIView *selectedItem;

@end
