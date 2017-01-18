//
//  ChooseSecurityQuesTableViewCell.h
//  Signup
//
//  Created by RICHA on 10/02/16.
//  Copyright © 2016 RICHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSecurityQuesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *securityQuesTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *answerTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *dropdownBtn;
@property (strong, nonatomic) IBOutlet UILabel *securityQuesLbl;

@end
