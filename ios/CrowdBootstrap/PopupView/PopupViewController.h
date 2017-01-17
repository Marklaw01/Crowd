//
//  PopupViewController.h
//  CrowdBootstrap
//
//  Created by RICHA on 16/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tbleView;
    
    int selectedCellIndex ;
    NSString *currentViewIdentifier ;
}
@property(strong,nonatomic)NSString *sectionTitle ;
@property(strong,nonatomic)NSMutableArray *tblArray ;

-(void)displayListForView:(NSString*)viewIdentifer withData:(NSMutableArray*)array withTitle:(NSString*)title;

@end
