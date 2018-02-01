//
//  GroupTableViewCell.m
//  CrowdBootstrap
//
//  Created by Shikha on 09/11/17.
//  Copyright © 2017 trantor.com. All rights reserved.
//

#import "GroupTableViewCell.h"


@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [UtilityClass addMarginsOnTextField:self.txtGroupName];
    [UtilityClass addMarginsOnTextView:self.txtVwGroupDesc];

    [UtilityClass setTextFieldBorder:self.txtGroupName];
    [UtilityClass setTextViewBorder:self.txtVwGroupDesc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resignTextfield {
    [_txtGroupName resignFirstResponder];
}

#pragma mark - TextField Delegate Methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self resignTextfield];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(saveGroupName:tag:)]) {
        [self.delegate saveGroupName:textField.text tag:[textField tag]];
    }
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if([textView.text isEqualToString:@"Group Description"] && textView.textColor == [UIColor lightGrayColor]){
        textView.text = @"" ;
        textView.textColor = [UtilityClass textColor] ;
    }
    return YES ;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    if([textView.text isEqualToString:@""]) {
        textView.text = @"Group Description" ;
        textView.textColor = [UIColor lightGrayColor] ;
    }
    
    if ([self.delegate respondsToSelector:@selector(saveGroupDesc:tag:)]) {
        if ([textView.textColor isEqual:[UIColor lightGrayColor]])
            [self.delegate saveGroupDesc:@"" tag:[textView tag]];
        else
            [self.delegate saveGroupDesc:textView.text tag:[textView tag]];
    }
}

#pragma mark - IBAction Methods
- (IBAction)btnDeleteGroupClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteGroup:)]) {
        [self.delegate deleteGroup:[sender tag]];
    }
}

@end
