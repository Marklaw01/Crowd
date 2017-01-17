//
//  CampaignsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CAMPAIGN_TYPE{
    RECOMMENDED_SELECTED,
    FOLLOWING_SELECTED,
    COMMITMENTS_SELECTED,
    MY_CAMPAIGNS_SELECTED,
};

@interface CampaignsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIBarButtonItem          *menuBarBtn;
    IBOutlet UISegmentedControl       *segmentedControl;
    IBOutlet UITableView              *campaignsTblView;
    IBOutlet UIButton                 *addCampaignBtn;
    
    NSMutableArray                    *campaignsArray ;
    int                               selectedCampaignType ;
    float                             originalTblViewHeight ;
    int                               pageNo ;
    int                               totalItems ;
    NSNumberFormatter                 *formatter ;
}

@end
