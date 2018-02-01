//
//  BusinessCardsViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 10/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_Card    @"cardCell"

@interface BusinessCardsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    // --- IBOutlets ---
    IBOutlet UITableView                     *tblView ;
    IBOutlet UILabel                         *lblNoCardsAvailable;

    // --- Variables ---
    NSMutableArray                           *cardsArray ;
    NSInteger                                selectedIndex;
}
@end
