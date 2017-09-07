//
//  AddFeedViewController.h
//  CrowdBootstrap
//
//  Created by Shikha on 29/06/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FEED_MESSAGE_SECTION_INDEX  0
#define FEED_IMAGE_SECTION_INDEX    1

#define kAddFeed_SuccessMessage     @"Feed added Successfully."

@interface AddFeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    // --- IBOutlets ---
    
    // --- Variables ---
    NSMutableArray                            *sectionsArray ;
    NSMutableArray                            *arrayForBool;
    NSData                                    *imgData ;
    UIImage                                   *chosenImage;

}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property UIView    *selectedItem;

@end
