//
//  ContactsViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 25/05/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCPopup.h"

enum {
    CHATS_SELECTED,
    CONTACTS_SELECTED
};

#define DEFAULT_NO_CHATS_AVAILABLE       @"No Chats Available."
#define DEFAULT_NO_CONTACTS_AVAILABLE    @"No Contacts Available."
#define VALIDATION_GROUP_NAME_REQUIRED   @"Group Name Required."   
#define VALIDATION__GROUP_CHAT           @"Select at least two members for group chat."

#define MIN_GROUP_CHAT_MEM_REQ           3

@interface ContactsViewController : UIViewController<UITextFieldDelegate,QMChatServiceDelegate,
QMAuthServiceDelegate,QMChatConnectionDelegate> {
    IBOutlet UISegmentedControl          *segmentControl;
    IBOutlet UILabel                     *NoChatsAvailableLbl;
    //IBOutlet UITableView                 *tblView;
    IBOutlet UIBarButtonItem             *menuBarBtn;
    IBOutlet UIButton                    *chatButton;
    IBOutlet UIImageView                 *chatImage;
    IBOutlet UITextField                 *groupNameTxtFld;
    IBOutlet UITableView                 *popupTblView;
    IBOutlet UIView                      *popupView;
    
    //NSMutableArray                       *chatUsersArray ;
    NSMutableArray                       *contactsArray ;
    NSMutableArray                       *allUsersArray ;
    NSMutableArray                       *selectedUsersForGroup ;
    int                                  totalNumberOfPages ;
    int                                  pageNo ;
    NSDateFormatter                      *dateFormatter ;
    
}

//@property (strong, nonatomic) QBChatDialog *createdDialog;
@property (nonatomic, strong) id <NSObject> observerDidBecomeActive;
@property (nonatomic, readonly) NSArray *dialogs;

@property (strong, nonatomic) UITableView *tblView;

@end
