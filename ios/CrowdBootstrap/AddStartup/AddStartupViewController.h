//
//  AddStartupViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 07/04/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

#define kAddStartup_SuccessMessage          @"Startup Created Successfully."

#define kAddStartupTextField_CellIdentifier @"TextfieldCell"
#define kAddStartupDesc_CellIdentifier      @"DescriptionCell"
#define kAddStartupKeywrods_CellIdentifier  @"KeywordsCell"
#define kAddStartupSubmit_CellIdentifier    @"SubmitCell"

#define kAddStartupName_CellIndex           0
#define kAddStartupDescription_CellIndex    1
#define kAddStartupKeywords_CellIndex       2
#define kAddStartupSupportReq_CellIndex     3

@interface AddStartupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,TLTagsControlDelegate>{
    IBOutlet UIBarButtonItem           *menuBarBtn;
    IBOutlet UITableView               *tblView ;
    
    IBOutlet UITableView              *popupTblView;
    IBOutlet UIView                   *popupView;
    
    NSMutableArray                    *addStartupArray ;
    NSMutableArray                    *keywordsArray ;
    NSMutableArray                    *selectedKeywordsArray ;
}

@property UIView *selectedItem;

@end
