//
//  PopupView.h
//  CrowdBootstrap
//
//  Created by OSX on 16/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PopupView : UIView<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tbleView;
    
    int selectedCellIndex ;
    NSString *currentViewIdentifier ;
}
@property(strong,nonatomic)NSString *sectionTitle ;
@property(strong,nonatomic)NSMutableArray *tblArray ;

-(void)displayListForView:(NSString*)viewIdentifer withData:(NSMutableArray*)array withTitle:(NSString*)title;

@end
