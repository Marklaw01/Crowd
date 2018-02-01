//
//  GroupTableViewCell.h
//  CrowdBootstrap
//
//  Created by Shikha on 09/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupTableViewCellDelegate <NSObject>

@required
- (void)deleteGroup:(NSInteger)tag;
- (void)saveGroupName:(NSString *)text tag: (NSInteger)tag;
- (void)saveGroupDesc:(NSString *)text tag: (NSInteger)tag;

@end

@interface GroupTableViewCell : UITableViewCell<UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, strong)IBOutlet UITextField *txtGroupName;
@property (weak, nonatomic) IBOutlet UITextView *txtVwGroupDesc;
@property(nonatomic, strong)IBOutlet UIButton *btnDelete;
@property(nonatomic, weak) id<GroupTableViewCellDelegate> delegate;


@end
