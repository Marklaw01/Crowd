//
//  ManageNotesViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 10/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Note    @"noteCell"

@interface ManageNotesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    // --- IBOutlets ---
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoNotesAvailable;
    
    // --- Variables ---
    NSMutableArray                           *notesArray ;
    NSInteger                                totalItems ;
    int                                      pageNo ;
    NSString                                 *noteID;
}

@property(nonatomic) NSString *selectedCardId;

@end
