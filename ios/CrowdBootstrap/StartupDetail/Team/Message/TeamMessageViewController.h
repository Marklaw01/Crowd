//
//  TeamMessageViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 09/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMessageViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>{
    
   IBOutlet UITextField            *toTxtFld;
   IBOutlet UITextField            *subjectTxtFld;
   IBOutlet UITextView             *messagetxtView ;
    ;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView ;
@property UIView                                  *selectedItem ;


@property (weak, nonatomic) NSMutableDictionary   *dict ;
@property (weak, nonatomic) NSString              *roleID ;

@end
