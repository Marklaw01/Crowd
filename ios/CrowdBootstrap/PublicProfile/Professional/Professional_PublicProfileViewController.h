//
//  Professional_PublicProfileViewController.h
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROFESSIONAL_PROF_KEYWORDS_CELL_IDENTIFIER    @"KeywordsCell"
#define kCellIdentifier_DynamicCell                   @"DynamicTableViewCell"

#define PROFESSIONAL_PROF_DESCRIPTION_CELL_INDEX      2

#define kContPublicProfKeywordsCellIndex              1
#define kContPublicProfQualificationsCellIndex        2
#define kContPublicProfCertificationsCellIndex        3
#define kContPublicProfSkillsCellIndex                4
#define kContPublicProfPreferredStartupCellIndex      6

#define kEntPublicProfKeywordsCellIndex               3
#define kEntPublicProfQualificationsCellIndex         4
#define kEntPublicProfSkillsCellIndex                 5


@interface Professional_PublicProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray       *profProfileArray ;
    
    NSMutableArray       *selectedKeywordsArray ;
    NSMutableArray       *selectedQualificationsArray ;
    NSMutableArray       *selectedCertificationsArray ;
    NSMutableArray       *selectedSkillsArray ;
    NSMutableArray       *selectedPreferredStartupArray ;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@end
