//
//  ForumDetailViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 15/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageComposerView.h"
#import "RDRGrowingTextView.h"


enum{
    REPORT_BTN_CLICKED,
    CANCEL_BTN_CLICKED
   
};

#define kCellIdentifier_Comments       @"commentsCell"
#define kCellIdentifier_Users          @"usersCell"
#define kCellIdentifier_Forums         @"forumCell"
#define kCloseForumStatus              @"2"


#define kValidation_Comments           @"Comment Required."
#define kValidation_ReportAbuse_Users  @"Please select at least one."
#define kValidation_ReportAbuse_Desc   @"Description Required."


#define COMMENTS_MAX_LIMIT             5

@interface ForumDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,MessageComposerViewDelegate>{
    
    IBOutlet UILabel                    *forumTitleLbl;
    IBOutlet UILabel                    *userNameLbl;
    IBOutlet UIImageView                *imgView;
    IBOutlet UITextView                 *descriptionTextView;
    IBOutlet UITextField                *commentTxtFld;
    IBOutlet UITableView                *commentsTblView;
    
    IBOutlet UIButton                   *reportAbuseBtn;
    IBOutlet UIButton                   *postCommentBtn;
    
    IBOutlet UIButton                   *viewCommentsBtn;
    IBOutlet UITableView                *popupTblView;
    IBOutlet UIView                     *backgroundView;
    IBOutlet UIView                     *popupView;
    
    IBOutlet UITextView                 *reportTxtView;
    IBOutlet UILabel                    *reportForumTitleLbl;
    
    RDRGrowingTextView                  *rdrTextView ;
    
    UIToolbar                           *textViewToolBar ;
    
    NSMutableArray                      *commentsArray ;
    NSMutableArray                      *usersArray ;
    NSMutableArray                      *reportAbuseArray ;
    NSMutableDictionary                 *forumsDetailDict ;
    BOOL                                isUserForum ;
}
@property UIView                        *selectedItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
