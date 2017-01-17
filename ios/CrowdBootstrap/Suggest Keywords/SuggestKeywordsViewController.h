//
//  SuggestKeywordsViewController.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 11/11/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface SuggestKeywordsViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, SWTableViewCellDelegate>
{
    // --- IBOutlets ---
    __weak IBOutlet UITableView                     *tblViewSuggestKeywords;
    __weak IBOutlet UIBarButtonItem                 *menuBarBtn;

    // Add Keywords View
    __weak IBOutlet UIView                          *vwAddKeywords;
    __weak IBOutlet UITextField                     *txtFieldKeywordName;
    __weak IBOutlet UITextField                     *txtFieldKeywordType;

    // Picker View
    __weak IBOutlet UIView                         *pickerViewContainer;
    __weak IBOutlet UIPickerView                   *pickerView;

    // --- Variables ---
    NSMutableArray                         *keywordsArray ;
    NSMutableArray                         *keywordsTypeArray ;
    NSInteger                              totalItems ;
    NSString                               *selectedKeywordTypeID ;
    int                                    selectedKeywordTypeIndex ;
}

@property UIView                                  *selectedItem ;

-(void)refreshUIContentWithTitle:(NSString*)viewTitle withContent:(NSString*)content;
@end
