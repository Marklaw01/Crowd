//
//  AddBusinessCardViewController.h
//  CrowdBootstrap
//
//  Created by osx on 01/12/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBusinessCardViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    // IBOutlets
    __weak IBOutlet UIImageView *imgVwUser;
    __weak IBOutlet UILabel *lblUsername;
    __weak IBOutlet UITextView *txtVwUserBio;
    __weak IBOutlet UITextView *txtVwUserInterest;
    __weak IBOutlet UITextView *txtVwUserStatement;
    __weak IBOutlet UIImageView *imgVwBusinessCard;

    // Variables
    UIImage *chosenImage;
    NSData *imgData ;
    NSDictionary *cardDict;
    
    NSString *defaultUsername;
    NSString *defaultUserImage;

}
@property(nonatomic) NSString *strBusinessCardScreenType;
@property(nonatomic) NSString *selectedCardId;
@property(nonatomic) NSDictionary *userLinkedInfo;

@end
