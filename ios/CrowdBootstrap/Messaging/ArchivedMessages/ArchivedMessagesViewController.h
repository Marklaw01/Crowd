//
//  ArchivedMessagesViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 09/06/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivedMessagesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIBarButtonItem              *menuBarBtn;
    IBOutlet UITableView                  *tblView ;
    
    NSMutableArray                        *messagesArray ;
    int                                   pageNo ;
    int                                   totalItems ;
}


@end
