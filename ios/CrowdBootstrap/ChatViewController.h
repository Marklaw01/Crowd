//
//  ChatViewController.h
//  sample-chat
//
//  Created by Andrey Moskvin on 6/9/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMChatViewController.h"

@interface ChatViewController : QMChatViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView                 *popupTblView;
    IBOutlet UIView                      *popupView;
    IBOutlet UILabel                     *groupNameLbl;
    
    NSMutableArray                       *usersArray ;
    
}

@property (nonatomic, strong) QBChatDialog *dialog;

@end
