//
//  MyStartupsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 23/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStartupsViewController : UIViewController<UITableViewDelegate>{
    IBOutlet UIBarButtonItem        *menuBarBtn;
    IBOutlet UITableView            *tblView ;
    
    NSMutableArray                  *startupsArray ;
    int                             pageNo ;
    int                             totalItems ;
    BOOL                            isUploadAppSelected ;
}

-(void)getMyStartupListForType:(BOOL)isUploadApp ;

@end
