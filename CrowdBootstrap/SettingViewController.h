//
//  SettingViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 06/07/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFICATIONS_SECTION_INDEX           0
#define PUBLIC_PROFILE_SECTION_INDEX  1
#define BETA_TESTER_SECTION_INDEX  2
#define BOARD_MEMBER_SECTION_INDEX    3
#define CONSULTING_SECTION_INDEX    4
#define EARLY_ADOPTER_SECTION_INDEX    5
#define ENDORSOR_SECTION_INDEX  6
#define FOCUS_GROUP_SECTION_INDEX    7
// Feeds Settings
#define AUDIO_VIDEO_UPDATES_SECTION_INDEX    8
#define BETA_TEST_UPDATES_SECTION_INDEX    9
#define BOARD_MEMBER_UPDATES_SECTION_INDEX    10
#define CAMPAIGN_FOLLOWED_UPDATES_SECTION_INDEX    11
#define CAMPAIGN_COMMITED_UPDATES_SECTION_INDEX    12
#define CAREER_HELP_UPDATES_SECTION_INDEX    13
#define COMMUNAL_ASSET_UPDATES_SECTION_INDEX    14
#define CONFERENCE_UPDATES_SECTION_INDEX    15
#define CONNECTION_UPDATES_SECTION_INDEX    16
#define CONSULTING_UPDATES_SECTION_INDEX    17
#define DEMODAY_UPDATES_SECTION_INDEX    18
#define EARLY_ADOPTER_UPDATES_SECTION_INDEX    19
#define ENDORSER_UPDATES_SECTION_INDEX    20
#define FOCUS_GROUP_UPDATES_SECTION_INDEX    21
#define FORUM_UPDATES_SECTION_INDEX    22
#define FUND_UPDATES_SECTION_INDEX    23
#define GROUP_UPDATES_SECTION_INDEX    24
#define GROUP_BUYING_UPDATES_SECTION_INDEX    25
#define HARDWARE_UPDATES_SECTION_INDEX    26
#define INFORMATION_UPDATES_SECTION_INDEX    27
#define JOB_UPDATES_SECTION_INDEX    28
#define LAUNCH_DEAL_UPDATES_SECTION_INDEX    29
#define MEETUP_UPDATES_SECTION_INDEX    30
#define ORGANIZATION_UPDATES_SECTION_INDEX    31
#define PRODUCTIVITY_UPDATES_SECTION_INDEX    32
#define SELF_IMPROVEMENT_UPDATES_SECTION_INDEX    33
#define SERVICE_UPDATES_SECTION_INDEX    34
#define SOFTWARE_UPDATES_SECTION_INDEX    35
#define STARTUP_UPDATES_SECTION_INDEX    36
#define WEBINAR_UPDATES_SECTION_INDEX    37

@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    // IBOutlets
    IBOutlet UIBarButtonItem    *menuBarBtn;
    IBOutlet UITableView        *tblView ;

    // Variables
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *settingsArray ;

}

@end
