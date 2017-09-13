//
//  ConnectionsViewController.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 08/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_SearchContractor    @"searchContractorCell"

@interface ConnectionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate, UITextFieldDelegate>
{
    // --- IBOutlets ---
    IBOutlet UIBarButtonItem               *menuBarBtn;
    IBOutlet UITableView                   *tblViewConnections;
    IBOutlet UITableView                   *tblViewMessages;
    IBOutlet UISegmentedControl            *segmentControl;

    // Message Popup
    IBOutlet UIView                        *vwPopup;
    IBOutlet UIView                        *vwMessageFields;
    IBOutlet UITextField                   *toTxtFld;
    IBOutlet UITextField                   *subjectTxtFld;
    IBOutlet UITextView                    *messagetxtView ;
    
    UISearchController                     *connSearchController ;
    
    NSNumberFormatter                      *formatter ;
    NSMutableArray                         *connectionsArray ;
    NSMutableArray                         *messagesArray ;

    NSMutableArray                         *searchResults ;
    NSString                               *searchedString ;
    NSInteger                              totalItems ;
    int                                    pageNo ;
    NSString                               *contractorName;
    NSString                               *contractorID;

}

@property UIView                                  *selectedItem ;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;
@end
