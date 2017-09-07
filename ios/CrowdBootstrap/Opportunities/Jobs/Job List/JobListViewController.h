//
//  JobListViewController.h
//  CrowdBootstrap
//
//  Created by osx on 23/12/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
enum{
    PROFILE_COUNTRY_SELECTED,
    PROFILE_STATE_SELECTED
};

#define BASIC_COUNTRY_INDEX              0
#define BASIC_STATE_INDEX                1

#define kTitle_SearchJob                    @"Search Job"
#define kCellIdentifier_SearchContractor    @"searchContractorCell"


@interface JobListViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    __weak IBOutlet UIBarButtonItem                 *menuBarBtn;
    
    // Country/State Buttons
    __weak IBOutlet UITextField                     *textFldCountry;
    __weak IBOutlet UITextField                     *textFldState;

    IBOutlet UITableView                      *tblView ;
    IBOutlet UIPickerView                     *pickerView;
    IBOutlet UIView                           *pickerViewContainer;

    IBOutlet UILabel                           *lblNoJobsFound;

    NSMutableArray                            *basicArray ;
    NSMutableArray                            *countryArray ;
    NSMutableArray                            *statesArray ;
    int                                       selectedPickerViewType ;
    NSString                                  *selectedCountryID ;
    NSString                                  *selectedStateID ;

    UISearchController                     *jobSearchController ;
    NSMutableArray                         *jobArray ;
    NSMutableArray                         *searchResults ;
    NSString                               *searchedString ;
    NSInteger                              totalItems ;
    int                                    pageNo ;
}

@property UIView *selectedItem;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;
@end
