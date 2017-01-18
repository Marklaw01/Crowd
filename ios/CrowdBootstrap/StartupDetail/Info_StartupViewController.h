//
//  Info_StartupViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

#define INFO_EDIT_BUTTON                   @"Edit"
#define INFO_SUBMIT_BUTTON                 @"Update"
#define INFO_VIEW_ENT_PROFILE_BUTTON       @"View Entrepreneur's Profile"

#define kCellIndex_OverviewStartupName     0
#define kCellIndex_OverviewDesc            1
#define kCellIndex_OverviewRoadmapGraphic  2
#define kCellIndex_OverviewDeliverables    3
#define kCellIndex_OverviewNextStep        4
#define kCellIndex_OverviewKeywords        5
#define kCellIndex_OverviewSupportReq      6

@interface Info_StartupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,TLTagsControlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    IBOutlet UITableView *tblView ;
    
    IBOutlet UITableView            *popupTblView;
    IBOutlet UIView                 *popupView;
    
    IBOutlet UIView                 *imgPopupView ;
    IBOutlet UIScrollView           *scrollView;
    IBOutlet UIImageView            *imgView;
    
    NSMutableArray                  *sectionsArray ;
    NSMutableArray                  *arrayForBool;
    NSMutableArray                  *roadmapArray ;
    NSMutableArray                  *keywordsArray ;
    NSMutableArray                  *selectedKeywordsArray ;
    NSData                          *imageData ;
    
    BOOL                            isEntrepreneur ;
    BOOL                            isEditModeEnabled ;
    
}

@property UIView *selectedItem;

-(void)getStartupInfoForSearch ;

@end
