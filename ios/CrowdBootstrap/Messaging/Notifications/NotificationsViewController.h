//
//  NotificationsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_UNFOLLOW_CAMPAIGN            @"UnFollow_Campaign"
#define TAG_FOLLOW_CAMPAIGN              @"Follow_Campaign"
#define TAG_COMMIT_CAMPAIGN              @"Commit_Campaign"
#define TAG_UNCOMMIT_CAMPAIGN            @"Uncommit_Campaign"
#define TAG_TEAM_MEMBER_STAUS            @"TeamMember_status"
#define TAG_COMMENT_FOURM                @"Comment_Forum"
#define TAG_RATE_PROFILE                 @"Rate_user"
#define TAG_ADD_TEAM_MEMBER              @"Add_member"
#define TAG_PROFILE_FOLLOW_UNFOLLOW      @"Profile"
#define TAG_MESSAGE                      @"Message"
#define TAG_REPORT_ABUSE_FORUM           @"Report_Abuse_Forum"
#define TAG_ADD_CONNECTION               @"Add_Connection"


@interface NotificationsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
//    IBOutlet UIBarButtonItem              *menuBarBtn;
    IBOutlet UITableView                  *tblView ;
    
    NSMutableArray                        *notificationsArray ;
    int                                   pageNo ;
    int                                   totalItems ;
}

- (void)refreshUIContentWithTitle:(NSString*)viewTitle;
@end
