//
//  Profile_AddStartup_ViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 28/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_ProfileAddStartup   @"ProfileAddStartupCell"

@interface Profile_AddStartup_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView        *tblView ;
    
    IBOutlet UILabel            *noStartupLbl;
    
    IBOutlet UIButton           *submitButton;
    
    NSMutableArray              *startupsArray ;
}

@end
