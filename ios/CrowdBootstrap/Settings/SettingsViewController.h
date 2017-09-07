//
//  SettingsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    NOTIFICATIONS_SELECTED=0,
    PUBLIC_PROFILE_SELECTED=1,
    BETA_TESTER_SELECTED=2,
    BOARD_MEMBER_SELECTED=3,
    CONSULTING_PROJECT_SELECTED=4,
    EARLY_ADOPTER_SELECTED=5,
    ENDORSOR_SELECTED=6,
    FOCUS_GROUP_SELECTED=7,
    AUDIO_VIDEO_SELECTED=1000,
    FEED_BETA_TEST_SELECTED=1001,
    FEED_BOARD_MEMBER_SELECTED=1002,
    CAMPAIGN_FOLLOWED_SELECTED=1003,
    CAMPAIGN_COMMITED_SELECTED=1004,
    CAREER_HELP_SELECTED=1005,
    FEED_COMMUNAL_ASSET_SELECTED=1006,
    CONFERENCE_SELECTED=1007,
    MYCONNECTION_SELECTED=1008,
    FEED_CONSULTING_SELECTED=1009,
    DEMODAY_SELECTED=1010,
    FEED_EARLY_ADOPTER_SELECTED=1011,
    FEED_ENDORSER_SELECTED=1012,
    FEED_FOCUS_GROUP_SELECTED=1013,
    FORUM_SELECTED=1014,
    FUND_SELECTED=1015,
    GROUP_SELECTED=1016,
    GROUP_BUYING_SELECTED=1017,
    HARDWARE_SELECTED=1018,
    INFORMATION_SELECTED=1019,
    JOB_SELECTED=1020,
    LAUNCH_DEAL_SELECTED=1021,
    MEETUP_SELECTED=1022,
    ORGANIZATION_SELECTED=1023,
    PRODUCTIVITY_SELECTED=1024,
    SELF_IMPROVEMENT_SELECTED=1025,
    SERVICE_SELECTED=1026,
    SOFTWARE_SELECTED=1027,
    STARTUP_SELECTED=1028,
    WEBINAR_SELECTED=1029
};

@interface SettingsViewController : UIViewController <UITableViewDataSource> {
    IBOutlet UIBarButtonItem *menuBarBtn;
    IBOutlet UITableView *tblView ;
    
    NSMutableArray                            *allFieldBoolArray;
    NSDictionary                              *dictionaryForBool ;
    NSArray                                   *boolTitles;
    
    NSMutableArray                            *settingsArray ;
    
    NSMutableArray                            *allFieldTitlesArray;
    NSDictionary                              *fields;
    NSArray                                   *fieldsTitles;
    NSArray                                   *arrSection1Fields;
    NSArray                                   *arrSection2Fields;
    
    NSDictionary                              *dictionaryForType;
    NSArray                                   *typeTitles;

}

@end
