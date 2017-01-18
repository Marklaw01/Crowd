//
//  PublicProfileViewController.h
//  CrowdBootstrap
//
//  Created by RICHA on 14/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface PublicProfileViewController : UIViewController{
    IBOutlet UIBarButtonItem     *menuBarBtn;
    IBOutlet UIView              *basicView;
    IBOutlet UIView              *professionalView;
    IBOutlet UIView              *startupsView;
    IBOutlet UISegmentedControl  *segmentControl;
    IBOutlet UIImageView         *profileImageView;
    IBOutlet UITextField         *userNameTxtFld;
    IBOutlet UITextField         *hoursTxtFld;
    IBOutlet UIImageView         *toggleImageView;
    IBOutlet UIButton            *followButton;
    IBOutlet UIButton            *connectButton;
    IBOutlet UIButton            *chatButton;
    IBOutlet UIButton            *entButton;
    IBOutlet UIButton            *contButton;
    IBOutlet HCSStarRatingView   *starView;
    
    int                          selectedUserType ;
    int                          quickBloxID ;
    int                          connectionID;
}

@property(strong, nonatomic)NSString *profileMode ;

@end
