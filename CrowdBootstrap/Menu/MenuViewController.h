//
//  MenuViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 12/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define kMyProfileSectionIcon          @"menu_myprofile"
#define kStartupSectionIcon            @"menu_main_startup"
#define kContractorSectionIcon         @"menu_main_contractor"
#define kOrganizationSectionIcon       @"menu_main_startup"
#define kMessagesSectionIcon           @"menu_main_messaging"
#define kResourcesSectionIcon          @"menu_resources"
#define kEventsSectionIcon             @"menu_events"
#define kOpportunitiesSectionIcon      @"menu_opportunities"

#define kMenuIdentifier_SelfImprovement      @"selfImprovementIdentifier"
#define kMenuIdentifier_CareerAdvancement    @"careerAdvancementIdentifier"

#define kMenuIdentifier_jobs           @"jobsIdentifier"
#define kMenuIdentifier_recruiter      @"recruiterIdentifier"

#define kMenuIdentifier_BetaTesters    @"betaTesterIdentifier"
#define kMenuIdentifier_boardMembers   @"boardMemberIdentifier"
#define kMenuIdentifier_earlyAdaptors  @"earlyAdaptorsIdentifier"
#define kMenuIdentifier_endorsers      @"endorsersIdentifier"
#define kMenuIdentifier_focusGroups    @"focusGroupsIdentifier"

#define kMenuIdentifier_Hardware       @"hardwareIdentifier"
#define kMenuIdentifier_Software       @"softwareIdentifier"

#define kMenuIdentifier_Consulting     @"consultingIdentifier"
#define kMenuIdentifier_communalAssets @"communalAssetsIdentifier"


#define kMyProfielSectionCellIndex     3
#define kStartupSectionCellIndex       4
#define kContractorSectionCellIndex    5
#define kOrganizationSectionCellIndex  6
#define kMessagesSectionCellIndex      7
#define kResourcesSectionCellIndex     8
#define kEventsSectionCellIndex        9
#define kOpportunitiesSectionCellIndex 10



@interface MenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    IBOutlet UITableView *tblView ;
    
    NSArray *menuArray ;
    NSMutableArray  *arrayForBool;
    NSArray *profileArray ;
    NSArray *startupArray ;
    NSArray *contractorsArray ;
    NSArray *organizationsArray ;
    NSArray *messagesArray ;
    NSArray *resourcesArray ;
    NSArray *eventsArray ;
    NSArray *opportunitiesArray ;
    
    int selectedUserType;
    NSString *selectedMenuTitle ;
}

@end
