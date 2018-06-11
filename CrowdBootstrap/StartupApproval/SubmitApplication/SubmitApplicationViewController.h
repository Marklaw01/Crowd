//
//  SubmitApplicationViewController.h
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMPANY_NAME_SECTION_INDEX 0
#define COFOUNDER_SECTION_INDEX 10
#define PRODUCTS_SECTION_INDEX 11
#define USERS_SECTION_INDEX 22
#define INVESTMENT_SECTION_INDEX 25
#define WEBSITE_SECTION_INDEX 28
#define DECLARE_SECTION_INDEX 31

#define SUBMITAPP_CELL_IDENTIFIER   @"SubmitAppCell"
#define COFOUNDER_CELL_IDENTIFIER   @"CofounderCell"
#define BUTTON_CELL_IDENTIFIER      @"ButtonCell"

#define  kStartupQuestions_plist    @"StartupQuestions"

@interface SubmitApplicationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    IBOutlet UITableView          *tblView ;
    IBOutlet UILabel              *lblSubmittedError;
    IBOutlet NSLayoutConstraint   *constraintTblVwTopToLblSubmitted;
    IBOutlet NSLayoutConstraint   *constraintTblVwTopToMainView;

    NSArray                       *keysArray ;
    NSArray                       *titleArray ;
    NSMutableArray                *sectionsArray ;
    NSMutableArray                *arrayForBool;
    NSMutableArray                *cofoundersArray;
    NSMutableDictionary           *cofounderDict ;
    
}
@property UIView *selectedItem;
@property NSInteger isApplicationSubmitted;
@end
