//
//  RecruiterViewController.h
//  CrowdBootstrap
//
//  Created by osx on 09/01/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    COUNTRY_SELECTED,
    STATE_SELECTED
};

#define BASIC_COUNTRY_INDEX              0
#define BASIC_STATE_INDEX                1

#define kCellIdentifier_SearchContractor    @"searchContractorCell"

#define kArchiveJob_SuccessMessage          @"Job archived Successfully."
#define kDeactivateJob_SuccessMessage       @"Job deactivated Successfully."
#define kDeleteJob_SuccessMessage           @"Job deleted Successfully."

@interface RecruiterViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
{
    // --- IBOutlets ---
    IBOutlet UISegmentedControl              *segmentControl;
    IBOutlet UIBarButtonItem                 *menuBarBtn;
    
    // Country/State Buttons
    IBOutlet UITextField                     *textFldCountry;
    IBOutlet UITextField                     *textFldState;
    
    IBOutlet UITableView                     *tblView ;
    IBOutlet UIPickerView                    *pickerView;
    IBOutlet UIView                          *pickerViewContainer;
    
    IBOutlet UILabel                           *lblNoJobsFound;

    NSMutableArray                           *basicArray ;
    NSMutableArray                           *countryArray ;
    NSMutableArray                           *statesArray ;
    int                                      selectedPickerViewType ;
    NSString                                 *selectedCountryID ;
    NSString                                 *selectedStateID ;
    
    UISearchController                       *jobSearchController ;
    NSMutableArray                           *jobArray ;
    NSMutableArray                           *searchResults ;
    NSString                                 *searchedString ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSInteger                                selectedSegment;
    NSString                                 *jobID;
}

@property UIView *selectedItem;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;

@end
