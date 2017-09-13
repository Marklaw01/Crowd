//
//  StartupsProfile_ViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartupsProfile_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblView ;
    IBOutlet UILabel *noStartupAvailableLbl;
    
    NSMutableArray                  *startupsArray ;
    NSMutableArray                  *arrayForBool;
}

@end
