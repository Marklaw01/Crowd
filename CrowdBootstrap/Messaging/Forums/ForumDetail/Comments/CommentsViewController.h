//
//  CommentsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 05/05/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView                  *tblView;
    
    NSMutableArray                        *commentsArray ;
    int                                   pageNo ;
    int                                   totalItems ;
    
}

@end
