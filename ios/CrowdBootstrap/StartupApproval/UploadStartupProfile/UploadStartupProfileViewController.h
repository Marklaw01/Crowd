//
//  UploadStartupProfileViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 22/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadStartupProfileViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *fileNameTxtFld;
    IBOutlet UITextField *startupNameTxtFld;
    IBOutlet UIButton *profileLinkBtn;
}


@end
