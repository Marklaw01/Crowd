//
//  AchievementAwardViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 20/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Review      @"reviewsCell"

@interface AchievementAwardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView            *tblView;
    IBOutlet UIButton               *rateButton;
    
    NSMutableArray                  *reviewsArray ;
}

@end
