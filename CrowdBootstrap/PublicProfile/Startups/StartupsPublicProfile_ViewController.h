//
//  StartupsPublicProfile_ViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 31/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartupsPublicProfile_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView            *tblView ;
    IBOutlet UILabel                *noStartupAvailableLbl;
    IBOutlet UIButton               *addContractorBtn;
    
    NSMutableArray                  *startupsArray ;
    NSMutableArray                  *arrayForBool;
}
@end
