//
//  Team_StartupViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import <MessageUI/MessageUI.h>

enum CELL_BUTTON_CLICKED{
    CHAT_BUTTON_CLICKED,
    EMAIL_BUTTON_CLICKED,
    MESSAGE_BUTTON_CLICKED
};

enum {
    MEMBER_APPROVED,
    MEMBER_RESUMED,
    MEMBER_SUSPENDED,
    MEMBER_REMOVED
};


#define TEAM_RESUME_TEXT             @"resume"
#define TEAM_SUSPEND_TEXT            @"suspend"
#define TEAM_REMOVE_ICON             @"Team_remove"
#define TEAM_RESUME_ICON             @"Team_resume"
#define TEAM_SUSPEND_ICON            @"Team_suspend"

#define MIN_TEAM_NUMBER_GROUPCHAT    3

#define VALIDATION_GROUP_CHAT        @"At least three members are required for group chat"

@interface Team_StartupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,MFMailComposeViewControllerDelegate,QMChatServiceDelegate,
QMAuthServiceDelegate,QMChatConnectionDelegate>{
    
    IBOutlet UITableView             *tblView ;
    IBOutlet UIButton                *recommendedContractorButton ;
    IBOutlet UIButton                *groupchatButton ;
    
    UISearchController               *searchController ;
    
    NSArray                          *rolesArray ;
    NSMutableArray                   *sectionsArray ;
    NSArray                          *dialogs ;
    NSMutableArray                   *searchResults ;
    NSMutableArray                   *occupantIDsArray ;
    NSMutableArray                   *quickbloxIDsArray ;
    NSArray                          *dialogsArray ;
    NSString                         *loggedInUserRole ;
    int                              loggedInUserRoleID ;
    QBChatDialog                     *teamchatDialog ;
}
@property (nonatomic, strong) id <NSObject> observerDidBecomeActive;
@end
