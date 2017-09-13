//
//  PaymentsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIBarButtonItem *menuBarBtn;
    IBOutlet UIView *agreementView;
    IBOutlet UIButton *agreeBtn;
    IBOutlet UITableView *tbleView;
    
    NSArray *companyArray ;
    NSArray *contentArray ;
    
    int selectedCompanyIndex ;
}

@end
