//
//  NotesViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "CoreDataManager.h"

#define NOTE_ICON @"Note_noteIcon"

@interface NotesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>{
    IBOutlet UIBarButtonItem *menuBarBtn;
    IBOutlet UITableView *notesTblView ;
    
    NSMutableArray *startupsArray ;
    NSMutableArray *notesArray ;
}

//@property (nonatomic,strong) CoreDataManager *coreDataManager;

@end
