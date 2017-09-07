//
//  MessagesViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface MessagesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>{
    
    IBOutlet UIBarButtonItem        *menuBarBtn;
    
    NSMutableArray                  *messagesArray ;
    int                             pageNo ;
    int                             totalItems ;
}

@property (strong, nonatomic) IBOutlet UITableView *messageTblView;

@end
