//
//  SettingsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum{
    NOTIFICATIONS_SELECTED,
    PUBLIC_PROFILE_SELECTED
};

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIBarButtonItem *menuBarBtn;
    IBOutlet UITableView *tblView ;
    
    NSMutableArray *settingsArray ;
}

@end
